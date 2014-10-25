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

/**
 *  Redirect the user to the authorization endpoint.
 *
 *  @param scope Application privileges. See online rif: http://dev.lelylan.com/developers#oauth-scopes
 */
- (void)authenticationRequest:(NSSet *)scope;

/**
 *  With the Lelylan's server response, this method send the token request.
 *
 *  @param openURL The openURL in the server response.
 */
- (void)authenticationOpenURL:(NSURL *)openURL;

@end
