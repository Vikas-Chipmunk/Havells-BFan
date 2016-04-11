//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//

#import "CSRDevicesListViewController.h"
#import "CSRDeviceDetailsViewController.h"
#import "CSRDevicesSearchListTableViewController.h"
#import "CSRDeviceTableViewCell.h"
#import "CSRAddDeviceWizardViewController.h"
#import "CSRLightViewController.h"
#import "CSRmeshStyleKit.h"
#import "CSRAppStateManager.h"
#import "CSRMenuSlidingSegue.h"
#import "CSRUtilities.h"
#import "CSRConstants.h"
#import "CSRDevicesManager.h"
#import "CSRDatabaseManager.h"
#import "CSRmeshDevice.h"
#import "CSRMeshUtilities.h"
#import "CSRNewLightViewController.h"

#import "CSRWizardPopoverViewController.h"

@interface CSRDevicesListViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate, UISearchResultsUpdating, UIToolbarDelegate, UIPopoverPresentationControllerDelegate, CSRDevicesSearchListDelegate>
{
    NSUInteger selectedIndex;
    NSUInteger wizardMode;
    CSRDeviceEntity *associatedDevice;
}

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) CSRDevicesSearchListTableViewController *devicesSearchListTableViewController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)showAlertControl:(id)sender;
- (IBAction)segmentControl_Clicked:(id)sender;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;


@end

@implementation CSRDevicesListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"DEVICES";
    
    //Set navigation bar colour
    //self.navigationController.navigationBar.barTintColor = [CSRUtilities colorFromHex:kColorBlueCSR];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG2.png"]];
    self.navigationItem.backBarButtonItem = nil;
    
    //Add table delegates
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    //Search controller details
//    _devicesSearchListTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CSRDevicesSearchListTableViewController"];
//    _devicesSearchListTableViewController.delegate = self;
//    _searchController = [[UISearchController alloc] initWithSearchResultsController:_devicesSearchListTableViewController];
//    self.searchController.searchResultsUpdater = self;
//    [self.searchController.searchBar sizeToFit];
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.searchBar.placeholder = @"Search for devices";
//    
//    self.searchController.delegate = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.delegate = self;
    
    //State control
    self.definesPresentationContext = YES;
    [self.tableView reloadData];
    
    //Display control notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayLightControl)
                                                 name:@"CSRDevicesSearchListControlDisplay"
                                               object:nil];
    
//    self.tableView.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:84.0/255.0 blue:94.0/255.0 alpha:0.5];
    self.tableView.layer.cornerRadius = 10.0;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.segmentControl.selectedSegmentIndex = 0;

    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAssociateDeviceNotificationInListView:)
                                                 name:kCSRmeshManagerDidAssociateDeviceNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetDeviceNotificationInListView:)
                                                 name:kCSRmeshManagerDidGetDeviceInfoNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(displayDeviceDetailsViewForDevice:)
//                                                 name:kCSRmeshManagerDeviceAssociationSuccessNotification
//                                               object:nil];

    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
    
    //Hide search bar
    [self hideSearchBarWithAnimation:YES];
    
    _devices = [NSMutableArray new];
    
    selectedIndex = -1;

    [self refreshDevices:nil];

}

- (void)dealloc
{
    self.view = nil;
}

- (void)refreshDevices:(id)sender
{
    
    [_devices removeAllObjects];
    
    _devices = [[[CSRAppStateManager sharedInstance].selectedPlace.devices allObjects] mutableCopy];
    
    //Sort devices alphabetically
    if (_devices != nil || [_devices count] != 0) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [_devices sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_devices count];
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
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(tableView.bounds));

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CSRDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CSRDeviceTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[CSRDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSRDeviceTableViewCellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:84.0/255.0 blue:94.0/255.0 alpha:0.3];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    cell.btnEdit.layer.cornerRadius = 5;
    cell.btnEdit.layer.masksToBounds = YES;
    [cell.btnEdit setTag:indexPath.row];

    CSRDeviceEntity *deviceEntity =  [_devices objectAtIndex:indexPath.row];
//    CSRmeshDevice *device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:deviceEntity.deviceId];
    
    if (deviceEntity.name != nil) {
        cell.deviceNameLabel.text = [NSString stringWithFormat:@"%@",deviceEntity.name];
    }

//    if ([deviceEntity.appearance isEqualToNumber:@(CSRApperanceNameLight)]) {
//        
//        cell.iconImageView.image = [CSRmeshStyleKit imageOfLight_on];
//        
//    } else if ([deviceEntity.appearance isEqualToNumber:@(CSRApperanceNameSensor)]) {
//        
//        cell.iconImageView.image = [CSRmeshStyleKit imageOfSensor];
//        
//    } else if ([deviceEntity.appearance isEqualToNumber:@(CSRApperanceNameHeater)]) {
//        
//        cell.iconImageView.image = [CSRmeshStyleKit imageOfTemperature_on];
//        
//    } else {
//        
//        cell.iconImageView.image = [CSRmeshStyleKit imageOfMesh_device];
//        
//    }
    
    NSArray *arrAreas = [deviceEntity.areas allObjects];
    if([arrAreas count])
    {
        CSRAreaEntity *area = [arrAreas objectAtIndex:0];
        cell.lblRoomName.text = area.areaName;
    }
    else
    {
        cell.imgViewRoom.image = nil;
        cell.lblRoomName.text = @"";
    }
    
    [cell.btnEdit addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    //Create accessory view for each cell
//    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 65., 65.)];
//    [accessoryButton setBackgroundImage:[CSRmeshStyleKit imageOfAccessoryGear ] forState:UIControlStateNormal];
//    [accessoryButton addTarget:self action:(@selector(accessoryButtonTapped:)) forControlEvents:UIControlEventTouchUpInside];
//    accessoryButton.tag = indexPath.row;
//    
//    cell.accessoryView = accessoryButton;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    selectedIndex  = indexPath.row;
//    CSRDeviceEntity *deviceEntity =  [_devices objectAtIndex:selectedIndex];
//    CSRmeshDevice *device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:deviceEntity.deviceId];
//    
//    if ([deviceEntity.appearance isEqualToNumber:@(CSRApperanceNameSensor)] || [deviceEntity.appearance isEqualToNumber:@(CSRApperanceNameHeater)]) {
//        
//    } else {
//        [[CSRDevicesManager sharedInstance] setSelectedDevice:device];
//        [self performSegueWithIdentifier:@"lightControlSegue" sender:self];
//        
//        
//    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hideSearchBarWithAnimation:YES];
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = _devices;
    
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // name field matching
        NSExpression *seachFieldName = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *searchStringName = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *nameSearchPredicate = [NSComparisonPredicate
                                            predicateWithLeftExpression:seachFieldName
                                            rightExpression:searchStringName
                                            modifier:NSDirectPredicateModifier
                                            type:NSContainsPredicateOperatorType
                                            options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:nameSearchPredicate];
        
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    
    CSRDevicesSearchListTableViewController *tableController = (CSRDevicesSearchListTableViewController *)self.searchController.searchResultsController;
    tableController.filteredDevicesArray = searchResults;
    [tableController.tableView reloadData];
}

#pragma mark - UIStateRestoration

//  we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const DevicesListViewControllerTitleKey = @"DevicesListViewControllerTitleKey";
NSString *const DevicesListSearchControllerIsActiveKey = @"DevicesListSearchControllerIsActiveKey";
NSString *const DevicesListSearchBarTextKey = @"DevicesListSearchBarTextKey";
NSString *const DevicesListSearchBarIsFirstResponderKey = @"DevicesListSearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.title forKey:DevicesListViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:DevicesListSearchControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:DevicesListSearchBarIsFirstResponderKey];
    }
    
    [coder encodeObject:searchController.searchBar.text forKey:DevicesListSearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    self.title = [coder decodeObjectForKey:DevicesListViewControllerTitleKey];
    _searchControllerWasActive = [coder decodeBoolForKey:DevicesListSearchControllerIsActiveKey];
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:DevicesListSearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:DevicesListSearchBarTextKey];
}

#pragma mark - Hide SearchBar

- (void)hideSearchBarWithAnimation:(BOOL)animated
{

    if ([[CSRDevicesManager sharedInstance] getTotalAssociatedDevices] > 0) {
         [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    }
}

#pragma mark - Parent controller menthods

- (void)displayLightControl
{
    
    if (self.searchController.searchBar) {
        [self searchBarCancelButtonClicked:self.searchController.searchBar];
        [self performSegueWithIdentifier:@"lightControlSegue" sender:self];
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[CSRMenuSlidingSegue class]]) {
        [super showCoverView];
    }
    
    if ([segue.identifier isEqualToString:@"deviceConfigurationSegue"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        CSRDeviceDetailsViewController *vc = (CSRDeviceDetailsViewController*)[navController topViewController];
        
        if (selectedIndex != -1) {
            
            vc.deviceEntity = [_devices objectAtIndex:selectedIndex];

        } else {
            
            vc.deviceEntity = associatedDevice;
        }
        
    }
    
    if ([segue.identifier isEqualToString:@"lightControlSegue"]) {
        
        CSRNewLightViewController *vc = segue.destinationViewController;
        CSRmeshDevice *device;
        if (_devices && _devices.count != 0) {
            CSRDeviceEntity *deviceEntity = [_devices objectAtIndex:selectedIndex];
            device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:deviceEntity.deviceId];
        }
        
        if (device) {
            
            vc.lightDevice = device;
            
        } else {
            
            NSMutableDictionary *deviceDictionary = [NSMutableDictionary new];
            
            if (((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).deviceId) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).deviceId forKey:kDEVICE_NUMBER];
            }
            
            if (((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).deviceHash) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).deviceHash forKey:kDEVICE_HASH];
            }
            
            if (((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).authCode) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).authCode forKey:kDEVICE_AUTH_CODE];
            }
            
            if (((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).name) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).name forKey:kDEVICE_NAME];
            }
            
            if (((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).isAssociated) {
                [deviceDictionary setValue:((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).isAssociated forKey:kDEVICE_ISASSOCIATED];
            }
            
            [[CSRDevicesManager sharedInstance] createDeviceFromProperties:deviceDictionary];
            
            CSRmeshDevice *device = [[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:((CSRDeviceEntity *)[_devices objectAtIndex:selectedIndex]).deviceId];
            
            if (device) {
                
                vc.lightDevice = device;
                
            }
            
        }
        
        
        
    }
    
    if ([segue.identifier isEqualToString:@"addDeviceWizardSegue"]) {
        
//        UINavigationController *navigationController = segue.destinationViewController;
//        CSRAddDeviceWizardViewController *vc = (CSRAddDeviceWizardViewController *)navigationController.topViewController;
//        vc.mode = wizardMode;
        
    }
    
    if ([segue.identifier isEqualToString:@"wizardPopoverAltSegue"]) {
        
        CSRWizardPopoverViewController *vc = segue.destinationViewController;
        vc.mode = wizardMode;
        
        vc.popoverPresentationController.delegate = self;
        vc.popoverPresentationController.presentedViewController.view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        vc.popoverPresentationController.presentedViewController.view.layer.borderWidth = 0.5;
        
        vc.preferredContentSize = CGSizeMake(self.view.frame.size.width - 20., 150.);
        
    }

}

#pragma mark - Accessory type action

- (void)accessoryButtonTapped:(id)sender
{
    UIButton *accessoryButton = (UIButton *)sender;
    NSLog(@"Acessory button tapped at index: %li", (long)accessoryButton.tag);
    selectedIndex = accessoryButton.tag;
    [self performSegueWithIdentifier:@"deviceConfigurationSegue" sender:self];
}

#pragma mark - Alert Control

- (IBAction)showAlertControl:(id)sender
{
    [[MeshServiceApi sharedInstance] setContinuousLeScanEnabled:YES];
    [[CSRDevicesManager sharedInstance] setDeviceDiscoveryFilter:self mode:YES];

    [self performSegueWithIdentifier:@"addDeviceWizardSegue" sender:self];
    return;
    

    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"DEVICE SELECTION"
                                                                   message:@"How do you want to set up your devices?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view setTintColor:[CSRUtilities colorFromHex:kColorBlueCSR]];
    alert.popoverPresentationController.barButtonItem = _addDeviceButton;
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                              [[MeshServiceApi sharedInstance] setContinuousLeScanEnabled:NO];
                                                              [[CSRDevicesManager sharedInstance] setDeviceDiscoveryFilter:self mode:NO];

                                                              
                                                          }];
    UIAlertAction* devicesListAction = [UIAlertAction actionWithTitle:@"Detected Devices List" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
//                                                              wizardMode = CSRAddDeviceWizardMode_DevicesList;
//                                                              [self showAddDeviceWizardWithMode:wizardMode];
                                                              [self performSegueWithIdentifier:@"addDeviceWizardSegue" sender:self];
                                                          }];
    UIAlertAction* scanQRAction = [UIAlertAction actionWithTitle:@"Scan QR Code" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
//                                                              wizardMode = CSRAddDeviceWizardMode_ScanQRCode;
//                                                              [self showAddDeviceWizardWithMode:wizardMode];
                                                              [self performSegueWithIdentifier:@"qrScannerSegue" sender:self];
                                                          }];
    UIAlertAction* shortCodeAction = [UIAlertAction actionWithTitle:@"Set Short Code" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
//                                                              wizardMode = CSRWizardPopoverMode_ShortCode;
//                                                              [self showWizardPopoverWithMode:wizardMode];
                                                              [self performSegueWithIdentifier:@"wizardPopoverAltSegue" sender:self];
                                                          }];
    
    [alert addAction:devicesListAction];
    [alert addAction:scanQRAction];
    [alert addAction:shortCodeAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [self setNavigationBarTitle:self.navigationItem.title];
}

- (IBAction)segmentControl_Clicked:(UISegmentedControl*)sender
{
    if(sender.selectedSegmentIndex == 1)
    {
        [self showAlertControl:nil];
    }
}


//- (void)showAddDeviceWizardWithMode:(CSRAddDeviceWizardMode)mode
//{
//    [self performSegueWithIdentifier:@"addDeviceWizardSegue" sender:self];
//}
//
//- (void)showWizardPopoverWithMode:(CSRWizardPopoverMode)mode
//{
//    [self performSegueWithIdentifier:@"wizardPopoverAltSegue" sender:self];
//}

#pragma mark - Navigation Bar item menthods

- (IBAction)showSearch:(id)sender
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.searchController setActive:YES];
    [self.searchBar becomeFirstResponder];
}


#pragma mark Notifications

- (void)didRemoveUnassociatedDevice:(NSNotification*)notification
{
    [self.tableView reloadData];
}
//
//- (void)displayDeviceDetailsViewForDevice:(NSNotification*)notification
//{
//    [self refreshDevices:nil];
//    
//    selectedIndex = -1;
//    
//    associatedDevice = (CSRDeviceEntity *)[[[CSRDatabaseManager sharedInstance] fetchObjectsWithEntityName:@"CSRDeviceEntity" withPredicate:@"deviceId == %@", notification.userInfo[@"deviceId"]] anyObject];
//    
//    if (associatedDevice) {
//        
//        [self performSegueWithIdentifier:@"deviceConfigurationSegue" sender:self];
//        
//    }
//}

- (void)didAssociateDeviceNotificationInListView:(NSNotification*)notification
{
    [self refreshDevices:nil];
//    [self.tableView reloadData];
}

- (void)didGetDeviceNotificationInListView:(NSNotification*)notification
{
    [self refreshDevices:nil];
//    [self.tableView reloadData];
}

#pragma mark - <UIPopoverPresentationControllerDelegate>

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    // Return no adaptive presentation style, use default presentation behaviour
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    return NO;
}

#pragma mark - <CSRDevicesSearchListDelegate>

- (NSUInteger)selectedItemIndex:(NSUInteger)item
{
    selectedIndex = item;
    
    return selectedIndex;
}

@end
