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

