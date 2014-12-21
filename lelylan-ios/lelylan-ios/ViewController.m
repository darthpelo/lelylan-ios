//
//  ViewController.m
//  lelylan-ios
//
//  Created by Alessio Roberto on 18/10/14.
//  Copyright (c) 2014 Alessio Roberto. All rights reserved.
//

#import "ViewController.h"

#import "LLLOauthManager.h"
#import "LLLDevicesManager+Bolts.h"

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
    
    if ([[LLLOauthManager sharedInstance] isAuthenticated] == YES) {
        [[[LLLDevicesManager sharedInstance] getAllDevices:nil] continueWithBlock:^id(BFTask *task) {
            if (!task.error) {
                NSArray *list = task.result;
                NSLog(@"%@", list);
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mesasggio"
                                                                message:@"No Devices"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil];
                
                [alert show];
            }
            return nil;
        }];
    } else {
        /**
         *  OAuth 2.0 request with generic scope.
         */
        [[LLLOauthManager sharedInstance] authenticationRequest:[NSSet setWithObjects:@"resources", @"privates", nil]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
