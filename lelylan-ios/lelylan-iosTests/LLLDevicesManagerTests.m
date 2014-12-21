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
    
    NSString *deviceID = @"544baca9e723c2b6af00002a";
    
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

- (void)testGetDevicePrivateMethod {
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"device"];
    
    NSString *deviceID = @"544baca9e723c2b6af00002a";
    
    [s1 getDevicePrivate:deviceID
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

- (void)DISABLED_testCreateDeviceMethods {
    NSDictionary *parameters = @{
                                 @"name": @"Closet dimmer",
                                 @"type": @{ @"id": @"518be84900045e1521000007" },
                                 @"physical": @{ @"uri": @"http://pluto.com" }
                                 };

    
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

- (void)DISABLED_testDeleteDeviceMethods {
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    //
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"delete device"];

    [s1 deleteDevice:@"544cdc6055d3a495d200003f"
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

- (void)DISABLED_testUpdateADeviceMethod {
    NSString *deviceID = @"544bb0fee723c25f0c000025";
    
    NSDictionary *parameters = @{
                                 @"name":@"pippo pluto",
                                 @"type":@{
                                         @"id":@"518be84900045e1521000007"
                                         }
                                 };
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"update device"];
    
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

- (void)DISABLED_testUpdateDevicePropertiesMethod {
    NSString *deviceID = @"544bb0fee723c25f0c000025";
    
    NSDictionary *properties = @{
                            @"properties": @[
                                    @{@"id":@"518be88300045e0610000008",
                                      @"value":@"on"
                                      }
                                    ]
                            };
    LLLDevicesManager *s1 = [self createUniqueInstance];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"update device"];
    
    [s1 updateDeviceProperties:deviceID
          properties:properties
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
