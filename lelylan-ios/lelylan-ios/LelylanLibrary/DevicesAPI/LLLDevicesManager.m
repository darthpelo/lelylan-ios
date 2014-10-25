//
//  LLLDevicesManager.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 20/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "LLLDevicesManager.h"

#import "FDKeychain.h"
#import "AFNetworking.h"
#import "DLLog.h"

static NSString * const kGetDeviceURL = @"http://api.lelylan.com/devices/";
static NSString * const kGetDevicePrivateInfoURL = @"http://api.lelylan.com/devices/%@/privates";

@interface LLLDevicesManager ()
@property (nonatomic, strong) NSDictionary *tokenData;
@end

@implementation LLLDevicesManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static LLLDevicesManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[LLLDevicesManager alloc] init]; });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSError *error;
        _tokenData = [FDKeychain itemForKey:@"com.lelylanios.tokendata"
                                 forService:@"lelylan"
                                      error:&error
                      ];
        NSAssert(!error, @"Failed retrive token");
    }
    
    return self;
}

#pragma mark - Public methods

- (void)getDevice:(NSString *)deviceID success:(void(^)(NSDictionary *device))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Headers
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    [manager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    // URL
    NSString *URL = [NSString stringWithFormat:@"%@%@",kGetDeviceURL, deviceID];
    
    [manager GET:URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             DLLogDebug(@"%@", responseObject);
             success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLLogError(@"%@", error.debugDescription);
        failure(error);
    }];
}

- (void)getDevicePrivate:(NSString *)deviceID success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Headers
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    [manager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    // URL
    NSString *URL = [NSString stringWithFormat:@"%@%@",kGetDevicePrivateInfoURL, deviceID];
    
    [manager GET:URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             DLLogDebug(@"%@", responseObject);
             success(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLLogError(@"%@", error.debugDescription);
             failure(error);
         }];
}

- (void)getAllDevices:(NSDictionary *)parameters success:(void(^)(NSArray *devices))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Headers
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    [manager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [manager GET:kGetDeviceURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             DLLogDebug(@"%@", responseObject);
             success(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLLogError(@"%@", error.debugDescription);
             failure(error);
         }];
}

- (void)createDevice:(NSDictionary *)parameters success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:kGetDeviceURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    config.HTTPAdditionalHeaders = @{
                                     @"Authorization": value,
                                     @"Content-Type"  : @"application/json"
                                     };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data
                                                          completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                              if (!error) {
                                                                  NSError* error;
                                                                  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                       options:kNilOptions
                                                                                                                         error:&error];
                                                                  if (!error) {
                                                                      DLLogDebug(@"%@", json);
                                                                      
                                                                      if (json[@"error"]) {
                                                                          NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey: json[@"error"][@"description"]};
                                                                          error = [[NSError alloc] initWithDomain:json[@"error"][@"code"]
                                                                                                             code:[json[@"status"] integerValue]
                                                                                                         userInfo:errorDictionary];
                                                                          
                                                                          failure(error);
                                                                      } else {
                                                                          success(json);
                                                                      }
                                                                  } else {
                                                                      failure(error);
                                                                  }
                                                              } else {
                                                                  failure(error);
                                                              }
                                                          }
                                              ];
        
        [uploadTask resume];
    }

}

#warning SERVER ERROR: code 500
- (void)updateDevice:(NSString *)deviceID parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Headers
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    [manager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // URL
    NSString *URL = [NSString stringWithFormat:@"%@%@",kGetDeviceURL, deviceID];
    
    [manager PUT:URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             DLLogDebug(@"%@", responseObject);
             success(responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLLogError(@"%@", error.debugDescription);
             failure(error);
         }
     ];
}

#warning WORK IN PROGRESS
- (void)updateDeviceProperties:(NSString *)deviceID properties:(NSDictionary *)properties success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
}

- (void)deleteDevice:(NSString *)deviceID success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Headers
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    [manager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    // URL
    NSString *URL = [NSString stringWithFormat:@"%@%@",kGetDeviceURL, deviceID];
    
    [manager DELETE:URL
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DLLogDebug(@"%@", responseObject);
                success(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DLLogError(@"%@", error.debugDescription);
                failure(error);
            }
     ];
}

@end
