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
 *    Verify if your logged with Lelylan correctly
 *
 *    @return BOOL value, YES if logged, NO otherwise.
 */
- (BOOL)isAuthenticated;

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

/**
 *    For security reasons an access token expires every 24 hours. To get a new one use the refresh token you previously received together with the access token.
 */
- (void)refreshAccessToken:(void(^)(NSDictionary *token))success
                   failure:(void(^)(NSError *error))failure;

@end
