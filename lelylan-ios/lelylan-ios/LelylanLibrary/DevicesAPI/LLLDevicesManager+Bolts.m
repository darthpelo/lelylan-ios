//
//  LLLDevicesManager+Bolts.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 19/12/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "LLLDevicesManager+Bolts.h"

@implementation LLLDevicesManager (Bolts)

- (BFTask *)getDevice:(NSString *)deviceID
{
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    [self getDevice:deviceID
            success:^(NSDictionary *device) {
                [task setResult:device];
            } failure:^(NSError *error) {
                [task setError:error];
            }];
    
    return task.task;
}

- (BFTask *)getDevicePrivate:(NSString *)deviceID
{
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    [self getDevicePrivate:deviceID success:^(id responseData) {
        [task setResult:responseData];
    } failure:^(NSError *error) {
        [task setError:error];
    }];
    
    return task.task;
}

- (BFTask *)getAllDevices:(NSDictionary *)parameters
{
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    
    [self getAllDevices:parameters success:^(NSArray *devices) {
        [task setResult:devices];
    } failure:^(NSError *error) {
        [task setError:error];
    }];
    
    return task.task;
}
@end
