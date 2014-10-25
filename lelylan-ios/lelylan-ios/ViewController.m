//
//  ViewController.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 18/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "ViewController.h"

#import "LLLOauthManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  OAuth 2.0 request with generic scope.
     */
//    [[LLLOauthManager sharedInstance] authenticationRequest:[NSSet setWithObject:@"resources"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
