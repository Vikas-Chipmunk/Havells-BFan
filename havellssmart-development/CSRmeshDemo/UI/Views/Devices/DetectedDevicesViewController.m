//
//  DetectedDevicesViewController.m
//  CSRmeshDemo
//
//  Created by SudheerPalchuri on 06/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "DetectedDevicesViewController.h"
#import "CSRAppStateManager.h"
#import "CSRDeviceEntity.h"
#import "CSRDatabaseManager.h"
#import "AppDelegate.h"
#import "CSRmeshArea.h"
#import <CSRmesh/GroupModelApi.h>

@interface DetectedDevicesViewController ()
{
    CSRDatabaseManager *dataBaseMng;
    AppDelegate *appDelegate;
    NSUInteger selectedIndex;
}
@property (nonatomic,strong)NSMutableArray *arrDevices,*arrDevicesSelected;
@property (weak, nonatomic) IBOutlet UITableView *tblViewAssociatedDevices;

@property (nonatomic, retain) NSArray *devicesArray;
@property (nonatomic, retain) CSRmeshArea *selectedArea;

@end

@implementation DetectedDevicesViewController
@synthesize placeSelected,arrDevices,arrDevicesSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:11.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    arrDevices = [[NSMutableArray alloc]init];
    arrDevicesSelected = [[NSMutableArray alloc]init];
    
    dataBaseMng = [CSRDatabaseManager sharedInstance];

    
    self.title = @"Add a device";
    
    [self refreshDevices:nil];
    self.tblViewAssociatedDevices.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if([arrDevices count])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnSaveClicked)];

    }
    
    _theDefaultArray = [NSMutableArray new];
    _theNewArray = [NSMutableArray new];
    _theAddArray = [NSMutableArray new];
    _theDeleteArray = [NSMutableArray new];
    
    NSSet *alreadyPresentDevicesSet = _areaEntity.devices;
    _listOfLocalDevices = [NSMutableArray array];
    for (CSRDeviceEntity *deviceObj in alreadyPresentDevicesSet) {
        [_listOfLocalDevices addObject:deviceObj];
        [_theDefaultArray addObject:deviceObj.deviceId];
    }
    [_theNewArray addObjectsFromArray:_theDefaultArray];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    _devicesArray = [[CSRAppStateManager sharedInstance].selectedPlace.devices allObjects];
}

-(void)btnSaveClicked
{

    [placeSelected addRelationshipToDevices:[NSSet setWithArray:arrDevicesSelected]];
    
    [dataBaseMng.managedObjectContext save:nil];
    
    for (CSRDeviceEntity *obj in arrDevicesSelected) {
        obj.isAssociatedToAPlace = [NSNumber numberWithBool:1];
        [dataBaseMng.managedObjectContext save:nil];
    }

//    [appDelegate.window makeToast:@"Device is associated successfully" duration:3 position:CSToastPositionTop title:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self sendOfData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDevices:(id)sender
{
    
    [arrDevices removeAllObjects];
    
    arrDevices = [[[CSRAppStateManager sharedInstance].selectedPlace.devices allObjects] mutableCopy];
    
    //Sort devices alphabetically
    if (arrDevices != nil || [arrDevices count] != 0) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [arrDevices sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    //Filter unassociated Devices only to show on screen
    arrDevices = (NSMutableArray*)[arrDevices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAssociatedToAPlace == 0 OR isAssociatedToAPlace == nil"]];
    //arrDevices = (NSMutableArray*)[arrDevices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAssociatedToAPlace == 1"]];

    [self.tblViewAssociatedDevices reloadData];
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
        //CSRDeviceEntity *obj = [_devicesArray objectAtIndex:indexPath.row];
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
    //    [self performSegueWithIdentifier:@"placesListToDevices" sender:nil];
    
    /*
    if([arrDevices count])
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [arrDevicesSelected removeObject:[arrDevices objectAtIndex:indexPath.row]];
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [arrDevicesSelected addObject:[arrDevices objectAtIndex:indexPath.row]];
        }
    }
     */
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    CSRDeviceEntity *deviceEntity = [_devicesArray objectAtIndex:indexPath.row];
    
    if([arrDevices count])
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [arrDevicesSelected removeObject:[arrDevices objectAtIndex:indexPath.row]];
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [arrDevicesSelected addObject:[arrDevices objectAtIndex:indexPath.row]];
        }
    }
    
    if ([_theNewArray containsObject:deviceEntity.deviceId]) {
        [_theNewArray removeObject:deviceEntity.deviceId];
        //[self deleteGroup:deviceEntity.deviceId];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [_theNewArray addObject:deviceEntity.deviceId];
        //[self writeGroup:deviceEntity.deviceId];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    selectedIndex = indexPath.row;
    
}

- (void) sendOfData
{
    
    
    if (![_theNewArray isEqualToArray:_theDefaultArray]) {
        if ([_theDefaultArray count] > [_theNewArray count]) {
            [self getDeleteArray];
        } else if ([_theDefaultArray count] < [_theNewArray count]) {
            [self getAddArray];
        }
    } else {
        NSLog(@"No changes");
    }
    
    if ([_theAddArray count] != 0 && _areaEntity != nil)
    {
        [_theAddArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *localDeviceId = (NSNumber*)obj;
            
            CSRDeviceEntity *deviceEntity = [[CSRDatabaseManager sharedInstance] getDeviceEntityWithId:localDeviceId];
            
            NSNumber *groupIndex = [self getValueByIndex:deviceEntity];
            if (![groupIndex  isEqual:@(-1)])
            {
                [[GroupModelApi sharedInstance] setModelGroupId:deviceEntity.deviceId
                                                        modelNo:@(0xff)
                                                     groupIndex:groupIndex // index of the array where there is first 0 or -1
                                                       instance:@(0)
                                                        groupId:_areaEntity.areaID //id of area
                                                        success:^(NSNumber *deviceId,
                                                                  NSNumber *modelNo,
                                                                  NSNumber *groupIndex,
                                                                  NSNumber *instance,
                                                                  NSNumber *desired) {
                                                            
                                                            NSMutableData *myData = (NSMutableData*)deviceEntity.groups;
                                                            uint16_t desiredValue = [desired unsignedShortValue];
                                                            int groupIndexInt = [groupIndex intValue];
                                                            if (groupIndexInt>-1) {
                                                                uint16_t *groups = (uint16_t *) myData.mutableBytes;
                                                                *(groups + groupIndexInt) = desiredValue;
                                                            }
                                                            
                                                            deviceEntity.groups = (NSData*)myData;
                                                            
                                                            CSRAreaEntity *areaEntity = [[CSRDatabaseManager sharedInstance] getAreaEntityWithId: desired];
                                                            
                                                            if (areaEntity) {
                                                                //NSLog(@"deviceEntity2 :%@", deviceEntity);
                                                                [_areaEntity addDevicesObject:deviceEntity];
                                                            }
                                                            [[CSRDatabaseManager sharedInstance] saveContext];
                                                            
                                                            
                                                            [appDelegate.window makeToast:@"Device is associated successfully" duration:3 position:CSToastPositionTop title:nil];
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                            
                                                        } failure:^(NSError *error) {
                                                            NSLog(@"mesh timeout");
                                                            
                                                        }];
            } else {
                NSLog(@"Device has 4 areas or something went wrong");
            }
            [NSThread sleepForTimeInterval:0.3];
            
        }];
        
    }
    if ([_theDeleteArray count] != 0)
    {
        [_theDeleteArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *localDeviceId = (NSNumber*)obj;
            
            CSRDeviceEntity *deviceEntity = [[CSRDatabaseManager sharedInstance] getDeviceEntityWithId:localDeviceId];
            
            NSNumber *groupIndex = [self getValueByIndex:deviceEntity];
            [[GroupModelApi sharedInstance] setModelGroupId:deviceEntity.deviceId
                                                    modelNo:@(0xff)
                                                 groupIndex:groupIndex // index of the array where that value was located
                                                   instance:@(0)
                                                    groupId:@(0) //0 for deleting
                                                    success:^(NSNumber *deviceId,
                                                              NSNumber *modelNo,
                                                              NSNumber *groupIndex,
                                                              NSNumber *instance,
                                                              NSNumber *desired) {
                                                        
                                                        uint16_t *dataToModify = (uint16_t*)deviceEntity.groups.bytes;
                                                        NSMutableArray *desiredGroups = [NSMutableArray new];
                                                        for (int count=0; count < deviceEntity.groups.length/2; count++, dataToModify++) {
                                                            NSNumber *groupValue = @(*dataToModify);
                                                            [desiredGroups addObject:groupValue];
                                                        }
                                                        
                                                        NSNumber *areaValue = [desiredGroups objectAtIndex:[groupIndex integerValue]];
                                                        
                                                        CSRAreaEntity *areaEntity = [[CSRDatabaseManager sharedInstance] getAreaEntityWithId:areaValue];
                                                        
                                                        if (areaEntity) {
                                                            [_areaEntity removeDevicesObject:deviceEntity];
                                                            
                                                        }
                                                        NSMutableData *myData = (NSMutableData*)deviceEntity.groups;
                                                        uint16_t desiredValue = [desired unsignedShortValue];
                                                        int groupIndexInt = [groupIndex intValue];
                                                        if (groupIndexInt>-1) {
                                                            uint16_t *groups = (uint16_t *) myData.mutableBytes;
                                                            *(groups + groupIndexInt) = desiredValue;
                                                        }
                                                        
                                                        deviceEntity.groups = (NSData*)myData;
                                                        
                                                        [[CSRDatabaseManager sharedInstance] saveContext];
                                                        
                                                        [appDelegate.window makeToast:@"Device is associated successfully" duration:3 position:CSToastPositionTop title:nil];
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                        
                                                        
                                                    } failure:^(NSError *error) {
                                                        NSLog(@"mesh timeout");
                                                        
                                                    }];
            
            [NSThread sleepForTimeInterval:0.3];
            
        }];
    }
    
}

- (void) getAddArray
{
    //add - new to default
    
    [_theNewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![_theDefaultArray containsObject:obj]) {
            [_theAddArray addObject:obj];
        }
    }];
    
}
- (void) getDeleteArray
{
    //delete - default to new
    [_theDefaultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![_theNewArray containsObject:obj]) {
            [_theDeleteArray addObject:obj];
        }
        
    }];
}

//method to getIndexByValue
- (NSNumber *) getValueByIndex:(CSRDeviceEntity*)deviceEntity
{
    
    uint16_t *dataToModify = (uint16_t*)deviceEntity.groups.bytes;
    
    for (int count=0; count < deviceEntity.groups.length/2; count++, dataToModify++) {
        if (*dataToModify == [_areaEntity.areaID unsignedShortValue]) {
            return @(count);
            
        } else if (*dataToModify == 0){
            return @(count);
        }
    }
    
    return @(-1);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
