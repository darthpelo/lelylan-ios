lelylan-ios
===========

[Lelylan](http://www.lelylan.com/) iOS library **work in progress**

Building the Connected Home with a unified APIs and tools that instantly enable
businesses to sell connected products

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

Devices API
===========

Returns extended information for a given device identified from its ID:
```Objective-C
- (void)getDevice:(NSString *)deviceID 
          success:(void(^)(NSDictionary *device))success 
          failure:(void(^)(NSError *error))failure;
```

Returns private information for a given device identified from its ID:
```Objective-C
- (void)getDevicePrivate:(NSString *)deviceID
                 success:(void(^)(id responseData))success 
                 failure:(void(^)(NSError *error))failure;
```
Returns a list of owned devices:
```Objective-C
- (void)getAllDevices:(NSDictionary *)parameters 
              success:(void(^)(NSArray *devices))success 
              failure:(void(^)(NSError *error))failure;
```

Delete a device identified from its ID and return extended information for it:
```Objective-C
- (void)deleteDevice:(NSString *)deviceID 
             success:(void(^)(id responseData))success 
             failure:(void(^)(NSError *error))failure;
```
