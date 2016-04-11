//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//

#import "CSRDeviceDetailsViewController.h"
#import "CSRAppStateManager.h"
#import "CSRDatabaseManager.h"
#import "CSRDeviceEntity.h"
#import "CSRmeshStyleKit.h"
#import "CSRUtilities.h"
#import "CSRDevicesManager.h"
#import "CSRAreaSelectionViewController.h"
#import "CSRDeviceSelectionTableViewCell.h"
#import <CSRmesh/BatteryModelApi.h>
#import <CSRmesh/AttentionModelApi.h>
#import <CSRmesh/ConfigModelApi.h>
#import <CSRmesh/DataModelApi.h>
#import <CSRmesh/FirmwareModelApi.h>
#import "CSRDeviceTableViewCell.h"
#import "CSRDeviceDetailsTableViewCell.h"

@interface CSRDeviceDetailsViewController ()
{
    id presenter;
}

@property (nonatomic) NSMutableArray *areasArray;
@property (nonatomic, weak) CSRmeshDevice *meshDeviceInAttentation;
@property (nonatomic) BOOL toggleButton;
@property (nonatomic, strong) NSString *batteryLevelString;
@property (nonatomic, strong) NSString *firmwareVersionString;
@property (nonatomic) UIButton *favButton;
@property (nonatomic) UIButton *srtButton;

@end

@implementation CSRDeviceDetailsViewController
@synthesize meshDeviceInAttentation;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:kCSRRefreshNotification
                                               object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _deviceDetailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _areasArray = [NSMutableArray new];

    NSSet *areasSet = _deviceEntity.areas ;
    for (CSRAreaEntity *area in areasSet) {
        [_areasArray addObject:area];
    }
    
    //Set navigation buttons
    _backButton = [[UIBarButtonItem alloc] init];
    _backButton.image = [CSRmeshStyleKit imageOfBack_arrow];
    _backButton.action = @selector(back:);
    _backButton.target = self;
    
    //Added for automation
    _backButton.isAccessibilityElement = YES;
    _backButton.accessibilityLabel = @"back";
    
    [super addCustomBackButtonItem:_backButton];
    
    _deviceTitleTextField.delegate = self;
    
    if (![CSRUtilities isStringEmpty:_deviceEntity.name]) {
        _deviceTitleTextField.text = _deviceEntity.name;
    }
    _deviceIcon.image = [CSRmeshStyleKit imageOfLight_on];

    [self getDeviceDetails];
    _toggleButton = YES;
    
    _batteryLevelString = @"Waiting...";
    _firmwareVersionString = @"Waiting...";
}

#pragma mark --
#pragma mark Device Details

- (void) getDeviceDetails
{
    NSNumber *deviceNumber = [_deviceEntity deviceId];
    
    [[BatteryModelApi sharedInstance] getState:deviceNumber
                                       success:^(NSNumber *deviceId, NSNumber *batteryLevel, NSNumber *batteryState) {
                                           _batteryLevelString = [NSString stringWithFormat:@"%d%%",[batteryLevel unsignedShortValue]];
                                           [_deviceDetailsTableView reloadData];
                                           
                                       } failure:^(NSError *error) {
                                           NSLog(@"Error :%@", error);
                                           _batteryLevelString = @"N/A";
                                           [_deviceDetailsTableView reloadData];
                                       }];
    
    [[FirmwareModelApi sharedInstance] getVersionInfo:_deviceEntity.deviceId
                                              success:^(NSNumber *deviceId, NSNumber *versionMajor, NSNumber *versionMinor) {
                                                  _firmwareVersionString = [NSString stringWithFormat:@"%@.%@", versionMajor, versionMinor];
                                                  [_deviceDetailsTableView reloadData];
                                              } failure:^(NSError *error) {
                                                  NSLog(@"error :%@", error);
                                                  _firmwareVersionString = @"N/A";
                                                  [_deviceDetailsTableView reloadData];
                                              }];
    
    //    [[ConfigModelApi sharedInstance] getInfo:_deviceEntity.deviceId
    //                                    infoType:@(CSR_VID_PID_Version) success:^(NSNumber *deviceId, NSDictionary *info, NSNumber *infoType) {
    //                                        NSNumber *versionNumber = info[@"CSR_VERSION_NUMBER"];
    //                                        int versionInt = [versionNumber intValue];
    //                                        uint8_t *v = (uint8_t *) &versionInt;
    //                                        _firmwareVersionString = [NSString stringWithFormat:@"%d.%d.%d.%d",*(v+1), *v, *(v+2), *(v+3) ];
    //                                        
    //                                    } failure:^(NSError *error) {
    //                                        
    //                                    }];
    
    
}

- (void) refreshView
{
    [_areasArray removeAllObjects];
    
    NSSet *areaSet = _deviceEntity.areas;
    
    for (CSRAreaEntity *area in areaSet) {
        [_areasArray addObject:area];
    }
    
    [self.deviceDetailsTableView reloadData];
}


#pragma mark - Layout Subviews

-(UIImage*) displayFavouriteState :(BOOL) state
{
    if (state) {
        [_favButton setBackgroundImage:[CSRmeshStyleKit imageOfFavourites_on] forState:UIControlStateNormal];
        _favButton.accessibilityLabel = @"Favourites_On";
        return [CSRmeshStyleKit imageOfFavourites_on];
    } else {
        [_favButton setBackgroundImage:[CSRmeshStyleKit imageOfFavourites_off] forState:UIControlStateNormal];
        _favButton.accessibilityLabel = @"Favourites_Off";
        return [CSRmeshStyleKit imageOfFavourites_off];
    }
    return nil;
}


#pragma mark - Button actions

- (IBAction)saveDeviceConfiguration:(id)sender
{
    _deviceEntity.name = _deviceTitleTextField.text;
    _device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:_deviceEntity.deviceId];
    _device.name = _deviceTitleTextField.text;
    
    [[CSRDatabaseManager sharedInstance] saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editAreas:(id)sender
{
    [self performSegueWithIdentifier:@"groupSelectionSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return [_areasArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 30;
    }
    if (section == 2) {
        return 30;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        return view;
    }
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, tableView.frame.size.width/2, 18)];
        [label setText:@"DETAILS"];
        label.backgroundColor=[UIColor clearColor];
        label.textColor = [UIColor orangeColor];;
        [view addSubview:label];

        return view;
    }
    if (section == 2) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, tableView.frame.size.width/2, 18)];
        [label setText:@"AREAS"];
        label.backgroundColor=[UIColor clearColor];
        label.textColor = [UIColor orangeColor];
        [view addSubview:label];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 75., 5, 75., 18)];
        [button setTitle:@"EDIT" forState:UIControlStateNormal];
        
        button.layer.masksToBounds = NO;
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOpacity = 0.6;
        button.layer.shadowRadius = 1;
        button.layer.shadowOffset = CGSizeMake(1., 1.);
        
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(editAreas:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}

//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    //To show a line after section 1
//    if (section == 1) {
//        UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView*)view;
//        v.backgroundView.backgroundColor = [UIColor lightGrayColor];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.;
    }
    if (indexPath.section == 1) {
        return 80.;
    }
    if (indexPath.section == 2) {
        return 40.;
    }
    return 0.;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CSRDeviceDetailsButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CSRDeviceDetailsButtonsTableViewCellIdentifier];
        if (!cell) {
            cell = [[CSRDeviceDetailsButtonsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSRDeviceDetailsButtonsTableViewCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [cell.favouriteButton setBackgroundImage:[self displayFavouriteState:[_deviceEntity.favourite boolValue]] forState:UIControlStateNormal];
        [cell.favouriteButton addTarget:self action:@selector(favouriteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //Added for automation
        cell.favouriteButton.isAccessibilityElement = YES;
        
        _favButton = cell.favouriteButton;
        if ([CSRMeshUserManager sharedInstance].bearerType == CSRBearerType_Bluetooth) {
            
            [cell.attentionButton setBackgroundImage:[CSRmeshStyleKit imageOfAttention] forState:UIControlStateNormal];
            [cell.attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.otauButton setBackgroundImage:[CSRmeshStyleKit imageOfOtau] forState:UIControlStateNormal];
            [cell.otauButton addTarget:self action:@selector(startModeAction:) forControlEvents:UIControlEventTouchUpInside];
            _srtButton = cell.otauButton;
            
            //Added for automation
            cell.attentionButton.isAccessibilityElement = YES;
            cell.attentionButton.accessibilityLabel = @"Attention";
            cell.otauButton.isAccessibilityElement = YES;
            cell.otauButton.accessibilityLabel = @"Otau";
            
//            [cell.attentionLabel setHidden:NO];
//            [cell.otauLabel setHidden:NO];
        } else {
            [cell.attentionButton setHidden:YES];
            [cell.otauButton setHidden:YES];
            
            [cell.attentionLabel setHidden:YES];
            [cell.otauLabel setHidden:YES];
        }
        
        
        

        return cell;

    }
    if (indexPath.section == 1) {
        CSRDeviceDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CSRDeviceDetailTableViewCellIdentifier];
        if (!cell) {
            cell = [[CSRDeviceDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSRDeviceDetailTableViewCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([CSRMeshUserManager sharedInstance].bearerType == CSRBearerType_Bluetooth) {
            
            cell.firmwareDynamicLabel.text = _firmwareVersionString;
            cell.batteryDynamicLabel.text = _batteryLevelString;
        } else {
            [cell.firmwareStaticLabel setHidden:YES];
            [cell.firmwareDynamicLabel setHidden:YES];
            cell.batteryDynamicLabel.text = _batteryLevelString;

        }

        return cell;

    } 
    if (indexPath.section == 2) {
        
        CSRDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CSRDeviceTableViewCellIdentifier];
        if (!cell) {
            cell = [[CSRDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSRDeviceTableViewCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_areasArray && [_areasArray count] > 0) {
            
            CSRAreaEntity *areaEntity = [_areasArray objectAtIndex:indexPath.row];
            
            cell.iconImageView.image = [CSRmeshStyleKit imageOfAreasIcon];
            cell.deviceNameLabel.text = areaEntity.areaName;
            return cell;
            
        }
    }
    return nil;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupSelectionSegue"]) {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        CSRAreaSelectionViewController *vc = (CSRAreaSelectionViewController*)[navController topViewController];
        vc.deviceEntity = _deviceEntity;
    }
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonTapped:(id)sender
{
    _device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:_deviceEntity.deviceId];
    
    if (presenter) {
        presenter = nil;
    }
    
    presenter = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Remove %@?", _device.name]
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController.view setTintColor:[CSRUtilities colorFromHex:kColorBlueCSR]];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         if (_device) {
                                                             [[CSRDevicesManager sharedInstance] initiateRemoveDevice:_device];
                                                         }
                                                         if(_deviceEntity) {
                                                             [[CSRAppStateManager sharedInstance].selectedPlace removeDevicesObject:_deviceEntity];
                                                             [[CSRDatabaseManager sharedInstance].managedObjectContext deleteObject:_deviceEntity];
                                                             [[CSRDatabaseManager sharedInstance] saveContext];
                                                         }
                                                         if (_device) {
//                                                             [[CSRDevicesManager sharedInstance] removeDevice:_device];
                                                         }
                                                         
                                                         NSNumber *deviceNumber = [[CSRDatabaseManager sharedInstance] getNextFreeDeviceNumber];
                                                         [[MeshServiceApi sharedInstance] setNextDeviceId:deviceNumber];
                                                         [[CSRDevicesManager sharedInstance] setDeviceIdNumber:deviceNumber];
                                                         
                                                         [presenter dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
//    if (_device != nil) {
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void) removeDeviceAlert :(NSTimer *)timer {
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.backgroundColor = [UIColor clearColor];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Button Action Methods

- (IBAction)favouriteAction:(UIButton *)sender
{
    //
    // 1. Toggle favourite for this Device
    // 2. Update image for this device to inidicate new Favourite state
    //

    if (_deviceEntity) {
        BOOL state = [_deviceEntity.favourite boolValue];
        state = !state;
        [_deviceEntity setFavourite:@(state)];
        [[CSRDatabaseManager sharedInstance] saveContext];
        
        // update Image
        [self displayFavouriteState:state];
        
    }
}

- (IBAction)attentionAction:(UIButton *)sender
{
    if (_deviceEntity.deviceHash != nil) {
        [[AttentionModelApi sharedInstance] setState:_deviceEntity.deviceId attractAttention:YES duration:@(6000) success:^(NSNumber *deviceId, NSNumber *state) {
            NSLog(@"state :%@", state);
        } failure:^(NSError *error) {
            NSLog(@"error :%@", error);
        }];
    }
}
- (IBAction)startModeAction:(UIButton *)sender
{
    if (_toggleButton) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm"
                                                                                  message:@"Enter OTAU mode? You will no longer be able to control the device."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             [[FirmwareModelApi sharedInstance] setUpdateRequired:_deviceEntity.deviceId success:^(NSNumber *deviceId) {
                                                                     NSLog(@"Received DeviceId :%@", deviceId);
                                                                 } failure:^(NSError *error) {
                                                                     NSLog(@"Received Error :%@", error);
                                                                 }];
                                                             
                                                         }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                             }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } else {
        for (UIView *view in self.view.subviews) {
            view.userInteractionEnabled = YES;
        }
    }
    _toggleButton = !_toggleButton;
}


@end
