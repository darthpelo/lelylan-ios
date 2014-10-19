//
//  LLLOAuthTests.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 18/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "LLLOauthManager.h"

@interface LLLOAuthTests : XCTestCase

@end

@implementation LLLOAuthTests

#pragma mark - helper methods

- (LLLOauthManager *)createUniqueInstance {
    
    return [[LLLOauthManager alloc] init];
    
}

- (LLLOauthManager *)getSharedInstance {
    
    return [LLLOauthManager sharedInstance];
    
}

#pragma mark - tests

- (void)testSingletonSharedInstanceCreated {
    
    XCTAssertNotNil([self getSharedInstance]);
    
}

- (void)testSingletonUniqueInstanceCreated {
    
    XCTAssertNotNil([self createUniqueInstance]);
    
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    
    LLLOauthManager *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
    
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    
    LLLOauthManager *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    LLLOauthManager *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

//- (void)testAuthenticationRequest {
//    XCTestExpectation *requestExpectation = [self expectationWithDescription:@"token recived"];
//    
//    LLLOauthManager *s1 = [self createUniqueInstance];
//    
//    [s1 authenticationRequest:^(id resultData) {
//        [requestExpectation fulfill];
//        XCTAssertNotNil(resultData);
//    } failure:^(NSError *error) {
//        XCTAssertNil(error);
//    }];
//    
//    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
//        XCTAssertNil(error);
//    }];
//}



@end
