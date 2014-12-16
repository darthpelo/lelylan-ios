//
//  LLLDevicesManager.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 20/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "LLLDevicesManager.h"
#import "LLLOauthManager.h"

#import "FDKeychain.h"
#import "AFNetworking.h"
#import "DLLog.h"

static NSString * const kGetDeviceURL = @"http://api.lelylan.com/devices/";
static NSString * const kGetDevicePrivateInfoURL = @"http://api.lelylan.com/devices/%@/privates";
static NSString * const kPutDevicePropertiesURL = @"http://api.lelylan.com/devices/%@/properties";

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
        [self getToken];
    }
    
    return self;
}

#pragma mark - Public methods
#pragma mark GET methods
- (void)getDevice:(NSString *)deviceID success:(void(^)(NSDictionary *device))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Check token
    if (!self.tokenData) {
        [self getToken];
    }
    
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
    
    // Check token
    if (!self.tokenData) {
        [self getToken];
    }
    
    // Headers
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    [manager.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    // URL
    NSString *URL = [NSString stringWithFormat:kGetDevicePrivateInfoURL, deviceID];
    
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
    
    // Check token
    if (!self.tokenData) {
        [self getToken];
    }
    
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

#pragma mark POST methods
- (void)createDevice:(NSDictionary *)parameters success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure
{
    // Check token
    if (!self.tokenData) {
        [self getToken];
    }
    
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

- (void)updateDevice:(NSString *)deviceID parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // Check token
    if (!self.tokenData) {
        [self getToken];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kGetDeviceURL, deviceID]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    config.HTTPAdditionalHeaders = @{
                                     @"Authorization": value,
                                     @"Content-Type"  : @"application/json"
                                     };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PUT";
    
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

- (void)updateDeviceProperties:(NSString *)deviceID properties:(NSDictionary *)properties success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // Check token
    if (!self.tokenData) {
        [self getToken];
    }
    
    NSString *strUrl = [NSString stringWithFormat:kPutDevicePropertiesURL, deviceID];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *value = [NSString stringWithFormat:@"Bearer %@", self.tokenData[@"access_token"]];
    config.HTTPAdditionalHeaders = @{
                                     @"Authorization": value,
                                     @"Content-Type"  : @"application/json"
                                     };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties
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

#pragma mark DELETE method

- (void)deleteDevice:(NSString *)deviceID success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Check token
    if (!self.tokenData) {
        [self getToken];
    }
    
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

#pragma mark - Private methods
- (void)getToken
{
    NSError *error;
    _tokenData = [FDKeychain itemForKey:@"com.lelylanios.tokendata"
                             forService:@"lelylan"
                                  error:&error
                  ];
    
    NSDate *endTime = [NSDate date];
    NSDate *startTime = self.tokenData[@"start_time"];
    NSTimeInterval diff = [endTime timeIntervalSinceDate:startTime];
    DLLogDebug(@"Time difference is: %f", diff);
    
   /*
    NSAssert(!error, @"Failed retrive token");
    if (error) {
        [[LLLOauthManager sharedInstance] authenticationRequest:[NSSet setWithObjects:@"resources", @"privates", nil]];
    }
   */
}

@end
