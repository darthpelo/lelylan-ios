//
//  LLLDevicesManagerTests.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 20/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "LLLDevicesManager.h"

@interface LLLDevicesManagerTests : XCTestCase

@end

@implementation LLLDevicesManagerTests

#pragma mark - helper methods

- (LLLDevicesManager *)createUniqueInstance {
    
    return [[LLLDevicesManager alloc] init];
    
}

- (LLLDevicesManager *)getSharedInstance {
    
    return [LLLDevicesManager sharedInstance];
    
}

#pragma mark - tests

- (void)testSingletonSharedInstanceCreated {
    
    XCTAssertNotNil([self getSharedInstance]);
    
}

- (void)testSingletonUniqueInstanceCreated {
    
    XCTAssertNotNil([self createUniqueInstance]);
    
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    
    LLLDevicesManager *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
    
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    
    LLLDevicesManager *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    LLLDevicesManager *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

#pragma mark - methods test

- (void)testGetDeviceMethods {
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"device"];
    
    NSString *deviceID = @"54456eedb9bd462084000001";
    [s1 getDevice:deviceID
          success:^(id responseData) {
              XCTAssertNotNil(responseData);
              
              [expectation fulfill];
          }
          failure:^(NSError *error) {
              XCTAssertNil(error);
              
              [expectation fulfill];
          }
     ];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testGetAllDevicesMethods {
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"devices"];
    
    [s1 getAllDevices:nil
              success:^(id responseData) {
                  XCTAssertNotNil(responseData);
                  
                  [expectation fulfill];
              } failure:^(NSError *error) {
                  XCTAssertNil(error);
                  
                  [expectation fulfill];
              }
     ];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

@end
