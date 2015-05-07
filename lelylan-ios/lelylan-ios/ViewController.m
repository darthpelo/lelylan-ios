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

#import "LLLDevice.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *devicesTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) NSArray *devicesList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshDevicesList)
                                                 name:@"com.lelylanios.tokenSaved"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[LLLOauthManager sharedInstance] isAuthenticated] == YES) {
        [self refreshDevicesList];
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

- (IBAction)addDevicePressed:(id)sender {
}

- (void)refreshDevicesList
{
    self.statusLabel.text = @"Updating...";
    
    __weak __typeof(self)weakSelf = self;
    
    [[[LLLDevicesManager sharedInstance] getAllDevices:nil] continueWithBlock:^id(BFTask *task) {
        if (!task.error) {
            NSArray *list = task.result;
            NSMutableArray *tempList = @[].mutableCopy;
            
            for (NSDictionary *dict in list) {
                LLLDevice *device = [LLLDevice new];
                device.deviceID = dict[@"id"];
                device.deviceName = dict[@"name"];
                device.category = dict[@"category"];
                device.URI = dict[@"uri"];
                device.activated = [dict[@"activated"] boolValue];
                device.deviceProperties = dict[@"properties"];
                
                [tempList addObject:device];
            }
            
            dispatch_queue_t queue = dispatch_get_main_queue();
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(queue,^{
                strongSelf.devicesList = [NSArray arrayWithArray:tempList];
                [strongSelf.devicesTableView reloadData];
                strongSelf.statusLabel.text = @"";
            });
        } else {
            dispatch_queue_t queue = dispatch_get_main_queue();
            
            dispatch_async(queue,^{
                weakSelf.statusLabel.text = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                                message:@"No Devices"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil];
                
                [alert show];
            });
        }
        return nil;
    }];
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devicesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"deviceCell"];
    }
    
    LLLDevice *device = self.devicesList[indexPath.row];
    
    cell.textLabel.text = device.deviceName;
    
    if (device.deviceProperties.count == 1) {
        NSString *str = [[device.deviceProperties firstObject] objectForKey:@"value"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Type: %@ - Status: %@", device.category, [str uppercaseString]];
    }
    
    return cell;
}


@end
