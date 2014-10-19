//
//  LLLOauthManager.h
//  lelylan-ios
//
//  Created by Alessio Roberto on 18/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLLOauthManager : NSObject

+ (instancetype)sharedInstance;

- (void)authenticationRequest:(NSSet *)scope;

- (void)authenticationOpenURL:(NSURL *)openURL;

@end
