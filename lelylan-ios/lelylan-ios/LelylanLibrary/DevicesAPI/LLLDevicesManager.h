//
//  LLLDevicesManager.h
//  lelylan-ios
//
//  Created by Alessio Roberto on 20/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLLDevicesManager : NSObject

+ (instancetype)sharedInstance;

- (void)getDevice:(NSString *)deviceID success:(void(^)(NSDictionary *device))success failure:(void(^)(NSError *error))failure;

- (void)getDevicePrivate:(NSString *)deviceID success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

- (void)getAllDevices:(NSDictionary *)parameters success:(void(^)(NSArray *devices))success failure:(void(^)(NSError *error))failure;

- (void)createDevice:(NSDictionary *)parameters success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

- (void)updateDevice:(NSString *)deviceID parameters:(NSDictionary *)parameters success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

- (void)updateDeviceProperties:(NSString *)deviceID properties:(NSDictionary *)properties success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

- (void)deleteDevice:(NSString *)deviceID success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

@end
