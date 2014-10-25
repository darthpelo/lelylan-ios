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

- (void)testCreateDeviceMethods {
    NSDictionary *parameters = @{
                                 @"name":@"test Third Device",
                                 @"type":@{@"id":@"518be84900045e1521000007"},
                                 @"physical": @{ @"uri": @"http://pluto.com"}
                                 };
    /*
     @{
     @"name": @"Closet dimmer",
     @"type": @{ @"id": @"518be84900045e1521000007" },
     @"physical": @{ @"uri": @"http://pluto.com" }
     };
     */
    
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"create device"];
    
    [s1 createDevice:parameters
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

- (void)testDeleteDeviceMethods {
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    //
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"delete device"];

    [s1 deleteDevice:@"54458eacb9bd467e6d000001"
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

- (void)testUpdateADeviceMethod {
    NSString *deviceID = @"544b8851e723c25f0c00001a";
    
    NSDictionary *parameters = @{
                                 @"name":@"testThirdDevice",
                                 @"type":@{
                                         @"id":@"518be5a700045e1521000001"
                                         },
                                 @"physical":@{
                                         @"uri":@"http://api.lelylan.com/properties/518c9c41a2c03fac5a000001"
                                         }
                                 };
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"create device"];
    
    [s1 updateDevice:deviceID
          parameters:parameters
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

@end
