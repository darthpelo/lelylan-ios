lelylan-ios
===========

[Lelylan](http://www.lelylan.com/) iOS library **work in progress**

Building the Connected Home with a unified APIs and tools that instantly enable
businesses to sell connected products.

How to use
===========

This project is a library, then the class *ViewController.m* serves only to run the Unit Test. To understand how to use this library, use all the tests that are in **LLLDevicesManagerTests.m**, showing the operation of each API.

Components tested and completed.
===========

##OAuth 2.0

Redirect the user to the authorization endpoint:
```Objective-C
- (void)authenticationRequest:(NSSet *)scope;
```

With the Lelylan's server response, this method send the token request:
```Objective-C
- (void)authenticationOpenURL:(NSURL *)openURL;
```

##Devices API

* Returns extended information for a given device identified from its ID:
```Objective-C
- (void)getDevice:(NSString *)deviceID 
          success:(void(^)(NSDictionary *device))success 
          failure:(void(^)(NSError *error))failure;
```

* Returns private information for a given device identified from its ID:
```Objective-C
- (void)getDevicePrivate:(NSString *)deviceID
                 success:(void(^)(id responseData))success 
                 failure:(void(^)(NSError *error))failure;
```
* Returns a list of owned devices:
```Objective-C
- (void)getAllDevices:(NSDictionary *)parameters 
              success:(void(^)(NSArray *devices))success 
              failure:(void(^)(NSError *error))failure;
```
* Create a device and returns extended information for it:
```Objective-C
- (void)createDevice:(NSDictionary *)parameters 
             success:(void(^)(id responseData))success 
             failure:(void(^)(NSError *error))failure;
```

* Update a device identified from its ID and returns extended information for it:
```Objective-C
- (void)updateDevice:(NSString *)deviceID 
          parameters:(NSDictionary *)parameters 
             success:(void(^)(id responseData))success 
             failure:(void(^)(NSError *error))failure;
```

* Update properties on a device identified from its ID and returns extended representation for it. If a physical device is connected, Lelylan forward the changes to the physical world:
```Objective-C
- (void)updateDeviceProperties:(NSString *)deviceID 
          properties:(NSDictionary *)properties 
             success:(void(^)(id responseData))success 
             failure:(void(^)(NSError *error))failure;
```


* Delete a device identified from its ID and return extended information for it:
```Objective-C
- (void)deleteDevice:(NSString *)deviceID 
             success:(void(^)(id responseData))success 
             failure:(void(^)(NSError *error))failure;
```

Credits
===========

[Andrea Reginato](https://github.com/andreareginato)
