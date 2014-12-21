//
//  LLLDevicesManager+Bolts.h
//  lelylan-ios
//
//  Created by Alessio Roberto on 19/12/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "LLLDevicesManager.h"
#import <Bolts.h>

@interface LLLDevicesManager (Bolts)

- (BFTask *)getDevice:(NSString *)deviceID;

- (BFTask *)getDevicePrivate:(NSString *)deviceID;

- (BFTask *)getAllDevices:(NSDictionary *)parameters;

@end
