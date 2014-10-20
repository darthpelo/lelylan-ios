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

@end
