lelylan-ios
===========

Lelylan iOS library **work in progress**

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

