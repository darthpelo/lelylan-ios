//
//  LLLOauthManager.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 18/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "LLLOauthManager.h"

#import "NXOAuth2.h"
#import "FDKeychain.h"
#import "AFNetworking.h"

static NSString * const kClientID = @"ccc2346c818da7ca028db7f94610d6f8113ed78ab26c60b677cc3781e8efb464";
static NSString * const kClientSecret = @"609ff6aec374aa501a6361db6c2ffed73dcd7e4c8c56c681a88f73de61c4f186";
static NSString * const kAuthorizationURL = @"http://people.lelylan.com/oauth/authorize";
static NSString * const kTokenURL = @"http://people.lelylan.com/oauth/token";
static NSString * const kRedirectURL = @"lelylanios://lelylan";

@implementation LLLOauthManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static LLLOauthManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[LLLOauthManager alloc] init]; });
    return sharedInstance;
}

#pragma mark - Public methods

- (BOOL)isAuthenticated
{
    NSError *error;
    
    NSDictionary *token = [FDKeychain itemForKey:@"com.lelylanios.tokendata"
                forService:@"lelylan"
                     error:&error
     ];
    
    if (!token || error) {
        return NO;
    } else {
        return YES;
    }
}

- (void)authenticationRequest:(NSSet *)scope
{
    // [NSSet setWithObject:@"resources"]
    [[NXOAuth2AccountStore sharedStore] setClientID:kClientID
                                             secret:kClientSecret
                                              scope:scope
                                   authorizationURL:[NSURL URLWithString:kAuthorizationURL]
                                           tokenURL:[NSURL URLWithString:kTokenURL]
                                        redirectURL:[NSURL URLWithString:kRedirectURL]
                                      keyChainGroup:@""
                                     forAccountType:@"lelylan"
     ];
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"lelylan"];
}

- (void)authenticationOpenURL:(NSURL *)openURL
{
    if ([openURL query]) {
        NSArray *packageList = [[openURL query] componentsSeparatedByString:@"="];
        
        if ([packageList[0] isEqualToString:@"code"]) {
            [self tokenRequest:packageList[1]];
        }
    }
}

- (void)refreshAccessToken:(void(^)(NSDictionary *token))success
                   failure:(void(^)(NSError *error))failure;
{
    [self tokenRefresh:^(NSDictionary *token) {
        success(token);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Private methods

- (void)tokenRequest:(NSString *)code
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"client_id": kClientID,
                                 @"client_secret": kClientSecret,
                                 @"grant_type": @"authorization_code",
                                 @"code": code,
                                 @"redirect_uri":kRedirectURL
                                 };
    [manager POST:kTokenURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              /*
               Printing description of responseObject:
               {
               "access_token" = 264b837f91c1accaa863080842bb222dc3f37a715be1f1da10593eed662b1534;
               "expires_in" = 600;
               "refresh_token" = 298fb052dd8d198d2c6dbe1515e6d3de741c583755b825860964217ab913de07;
               scope = resources;
               "token_type" = bearer;
               }
               */
              NSDictionary *tokenData = @{
                                          @"access_token": responseObject[@"access_token"],
                                          @"token_type": responseObject[@"token_type"],
                                          @"expires_in": responseObject[@"expires_in"],
                                          @"scope": responseObject[@"scope"],
                                          @"refresh_token": responseObject[@"refresh_token"],
                                          @"start_time": [NSDate date]
                                          };
              
              NSError *error = nil;
              
              if ([FDKeychain saveItem:tokenData
                                forKey:@"com.lelylanios.tokendata"
                            forService:@"lelylan"
                                 error:&error
                   ] == NO) {
                  
                  if (error) {
                      NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
                  }
              } else {
                  NSLog(@"%s Token saved", __PRETTY_FUNCTION__);
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"com.lelylanios.tokenSaved" object:self];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }
     ];
}


- (void)tokenRefresh:(void(^)(NSDictionary *token))success
             failure:(void(^)(NSError *error))failure
{
    NSError *error;
    NSDictionary *token = [FDKeychain itemForKey:@"com.lelylanios.tokendata"
                                      forService:@"lelylan"
                                           error:&error
                           ];
    
    if (error) {
        failure(error);
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"client_id": kClientID,
                                 @"client_secret": kClientSecret,
                                 @"grant_type": @"refresh_token",
                                 @"refresh_token":token[@"refresh_token"]
                                 };
    
    [manager POST:kTokenURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              /*
               Printing description of responseObject:
               {
               "access_token" = 264b837f91c1accaa863080842bb222dc3f37a715be1f1da10593eed662b1534;
               "expires_in" = 600;
               "refresh_token" = 298fb052dd8d198d2c6dbe1515e6d3de741c583755b825860964217ab913de07;
               scope = resources;
               "token_type" = bearer;
               }
               */
              NSDictionary *tokenData = @{
                                          @"access_token": responseObject[@"access_token"],
                                          @"token_type": responseObject[@"token_type"],
                                          @"expires_in": responseObject[@"expires_in"],
                                          @"scope": responseObject[@"scope"],
                                          @"refresh_token": responseObject[@"refresh_token"],
                                          @"start_time": [NSDate date]
                                          };
              
              NSError *error = nil;
              
              if ([FDKeychain saveItem:tokenData
                                forKey:@"com.lelylanios.tokendata"
                            forService:@"lelylan"
                                 error:&error
                   ] == NO) {
                  
                  if (error) {
                      NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
                      failure(error);
                  }
              } else {
                  NSLog(@"%s Token saved", __PRETTY_FUNCTION__);
                  success(tokenData);
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              failure(error);
          }
     ];
}

@end
