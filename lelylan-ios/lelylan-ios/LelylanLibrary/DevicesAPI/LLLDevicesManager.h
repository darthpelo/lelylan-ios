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

/**
 *  Returns extended information for a given device identified from its ID.
 *
 *  @param deviceID The ID of the desired device.
 *  @param success  A block with a parameter that rappresents the device's struct.
 *  @param failure  failure block
 */
- (void)getDevice:(NSString *)deviceID success:(void(^)(NSDictionary *device))success failure:(void(^)(NSError *error))failure;

/**
 *  Returns private information for a given device identified from its ID.
 *
 *  @param deviceID The ID of the desired device.
 *  @param success  A block with a parameter that rappresents the private information
 *  @param failure  failure block
 */
- (void)getDevicePrivate:(NSString *)deviceID success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

/**
 *  Returns a list of owned devices.
 *
 *  @param parameters See online documentations: http://dev.lelylan.com/developers#get-all-devices
 *  @param success    A block with a parameter that rappresents an Array with the owned devices
 *  @param failure    failure block
 */
- (void)getAllDevices:(NSDictionary *)parameters success:(void(^)(NSArray *devices))success failure:(void(^)(NSError *error))failure;

/**
 *  Work in progress
 *
 */
- (void)createDevice:(NSDictionary *)parameters success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

/**
 *  Work in progress
 *
 */
- (void)updateDevice:(NSString *)deviceID parameters:(NSDictionary *)parameters success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

/**
 *  Work in progress
 *
 */
- (void)updateDeviceProperties:(NSString *)deviceID properties:(NSDictionary *)properties success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

/**
 *  Delete a device identified from its ID and return extended information for it.
 *
 *  @param deviceID The ID of the desired device.
 *  @param success  A block with a parameter that rappresents the device's struct.
 *  @param failure  failure block
 */
- (void)deleteDevice:(NSString *)deviceID success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

@end
