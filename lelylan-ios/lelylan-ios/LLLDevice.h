//
//  LLLDevice.h
//  lelylan-ios
//
//  Created by Alessio Roberto on 20/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLLDevice : NSObject
@property (nonatomic, assign) BOOL activated;
@property (nonatomic, strong) NSString *URI;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSArray *deviceProperties;
@end
