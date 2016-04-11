//
//  DevicesViewController.m
//  CSRmeshDemo
//
//  Created by SudheerPalchuri on 06/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "DevicesViewController.h"
#import "CSRDeviceEntity.h"
#import "DetectedDevicesViewController.h"
#import "CSRLightViewController.h"
#import "CSRDevicesManager.h"
#import "CSRNewLightViewController.h"
#import "CSRDatabaseManager.h"
#import "CSRAppStateManager.h"
#import "CSRUtilities.h"
#import "CSRTuneableWhiteViewController.h"
#import "CSRFanViewController.h"

@interface DevicesViewController ()
{
    NSInteger intDeviceSelected;
}
@property (weak, nonatomic) IBOutlet UITableView *tblViewDevices;
@property (nonatomic,strong)NSMutableArray *arrDevices;
@end

@implementation DevicesViewController
@synthesize placeSelected,arrDevices;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrDevices = [[NSMutableArray alloc]init];
    
    //self.showNavMenuButton = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddClicked)];
    self.title = placeSelected.name;
    
    self.tblViewDevices.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    if(_areaEntity) {
        _areaEntity.areaName = placeSelected.name;
        [[CSRDatabaseManager sharedInstance] saveContext];
    } else {
        if (![CSRUtilities isStringEmpty:placeSelected.name]) {
            
            _areaEntity = [[CSRDevicesManager sharedInstance] addMeshArea:placeSelected.name];
            [[CSRAppStateManager sharedInstance].selectedPlace addAreasObject:_areaEntity];
            [[CSRDatabaseManager sharedInstance] saveContext];
        } else {
            NSLog(@"Alert: Enter some Value");
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [arrDevices removeAllObjects];
    [arrDevices addObjectsFromArray:[placeSelected.relationshipToDevices allObjects]];
    [self.tblViewDevices reloadData];
    

    
//    NSSet *deviceSet = _areaEntity.devices;
//    
//    for (CSRDeviceEntity *device in deviceSet) {
//        [arrDevices addObject:device];
//    }
//
//   [self.tblViewDevices reloadData];
}

-(void)btnAddClicked
{
    [self performSegueWithIdentifier:@"devicesToDetectedDevices" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([arrDevices count])
        return [arrDevices count];
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if([arrDevices count])
    {
        CSRDeviceEntity *obj = [arrDevices objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = obj.name;
    }
    else
    {
        cell.textLabel.text = @"No devices found";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([arrDevices count])
    {
        intDeviceSelected = indexPath.row;
        //[self performSegueWithIdentifier:@"devicesToRGBScreen" sender:nil];
        //[self performSegueWithIdentifier:@"devicetoNewLight" sender:nil];
        
        CSRDeviceEntity *deviceEntity = [arrDevices objectAtIndex:intDeviceSelected];
        
        //CSRmeshDevice *device=[[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:deviceEntity.deviceId];
        
        NSString *originalString;
        if ([deviceEntity uuidString]!= nil)
            originalString = [NSString stringWithFormat:@"%@",[deviceEntity uuidString]];
        else
            originalString = @"0123456789ABCDEF2306456789ABCDEF";
        
        NSString *actualUUID = [originalString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //NSString *macID = [actualUUID substringWithRange:NSMakeRange(actualUUID.length - 12, 12)];
        NSString *deviceID = [actualUUID substringWithRange:NSMakeRange(actualUUID.length - 14, 2)];
        
        if ([deviceID isEqualToString:@"01"])
            [self performSegueWithIdentifier:@"CSRTuneableWhiteSegueID" sender:nil];
        else if ([deviceID isEqualToString:@"02"])
            [self performSegueWithIdentifier:@"devicetoNewLight" sender:nil];
        else if ([deviceID isEqualToString:@"08"])
            [self performSegueWithIdentifier:@"CSRFanSegueID" sender:nil];
        
        
        //[self performSegueWithIdentifier:@"devicesToLightScreen" sender:nil];
    }
    //[self performSegueWithIdentifier:@"CSRFanSegueID" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"devicesToDetectedDevices"])
    {
        DetectedDevicesViewController *obj = [segue destinationViewController];
        obj.placeSelected = placeSelected;
        obj.areaEntity=_areaEntity;
    }
    else if ([segue.identifier isEqualToString:@"CSRFanSegueID"])
    {
        CSRFanViewController *vc = segue.destinationViewController;
        CSRmeshDevice *device;
        
        CSRDeviceEntity *deviceEntity = [arrDevices objectAtIndex:intDeviceSelected];
        
        vc.deviceEntity = deviceEntity;
        
        device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:deviceEntity.deviceId];
        
        if (device) {
            
            vc.lightDevice = device;
            
        } else {
            
            NSMutableDictionary *deviceDictionary = [NSMutableDictionary new];
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId forKey:kDEVICE_NUMBER];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceHash) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceHash forKey:kDEVICE_HASH];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).authCode) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).authCode forKey:kDEVICE_AUTH_CODE];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).name) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).name forKey:kDEVICE_NAME];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).isAssociated) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).isAssociated forKey:kDEVICE_ISASSOCIATED];
            }
            
            [[CSRDevicesManager sharedInstance] createDeviceFromProperties:deviceDictionary];
            
            CSRmeshDevice *device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId];
            
            if (device) {
                
                vc.lightDevice = device;
                
            }
            
        }
        
        [CSRDevicesManager sharedInstance].selectedDevice = device;
    }
    else if ([segue.identifier isEqualToString:@"CSRTuneableWhiteSegueID"])
    {
        CSRTuneableWhiteViewController *vc = segue.destinationViewController;
        CSRmeshDevice *device;
        
        CSRDeviceEntity *deviceEntity = [arrDevices objectAtIndex:intDeviceSelected];
        
        vc.deviceEntity = deviceEntity;
        
        device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:deviceEntity.deviceId];
        
        if (device) {
            
            vc.lightDevice = device;
            
        } else {
            
            NSMutableDictionary *deviceDictionary = [NSMutableDictionary new];
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId forKey:kDEVICE_NUMBER];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceHash) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceHash forKey:kDEVICE_HASH];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).authCode) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).authCode forKey:kDEVICE_AUTH_CODE];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).name) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).name forKey:kDEVICE_NAME];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).isAssociated) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).isAssociated forKey:kDEVICE_ISASSOCIATED];
            }
            
            [[CSRDevicesManager sharedInstance] createDeviceFromProperties:deviceDictionary];
            
            CSRmeshDevice *device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId];
            
            if (device) {
                
                vc.lightDevice = device;
                
            }
            
        }
        
        [CSRDevicesManager sharedInstance].selectedDevice = device;
    }
    else if([segue.identifier isEqualToString:@"devicesToLightScreen"]||[segue.identifier isEqualToString:@"devicetoNewLight"])
    {
        CSRNewLightViewController *vc = segue.destinationViewController;
        CSRmeshDevice *device;
        
        CSRDeviceEntity *deviceEntity = [arrDevices objectAtIndex:intDeviceSelected];
        
        vc.deviceEntity = deviceEntity;
        
        device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:deviceEntity.deviceId];
        
        if (device) {
            
            vc.lightDevice = device;
            
        } else {
            
            NSMutableDictionary *deviceDictionary = [NSMutableDictionary new];
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId forKey:kDEVICE_NUMBER];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceHash) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceHash forKey:kDEVICE_HASH];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).authCode) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).authCode forKey:kDEVICE_AUTH_CODE];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).name) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).name forKey:kDEVICE_NAME];
            }
            
            if (((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).isAssociated) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).isAssociated forKey:kDEVICE_ISASSOCIATED];
            }
            
            [[CSRDevicesManager sharedInstance] createDeviceFromProperties:deviceDictionary];
            
            CSRmeshDevice *device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:((CSRDeviceEntity *)[arrDevices objectAtIndex:intDeviceSelected]).deviceId];
            
            if (device) {
                
                vc.lightDevice = device;
                
            }
            
        }
        
        [CSRDevicesManager sharedInstance].selectedDevice = device;
    }
}
@end
