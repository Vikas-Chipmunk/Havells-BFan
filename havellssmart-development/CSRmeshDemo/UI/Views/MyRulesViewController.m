//
//  MyRulesViewController.m
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 27/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "MyRulesViewController.h"
#import "MyRuleCell.h"
#import "AddRulesViewController.h"
#import "AppDelegate.h"
#import "CSRDatabaseManager.h"
#import "Places.h"
#import "CSRmeshDevice.h"
#import "MyRules.h"
#import "CSRDeviceEntity.h"
#import "CSRDevicesManager.h"
#import "Places.h"

@interface MyRulesViewController ()<AddRulesViewDelegate,MyRuleCellDelegate>

{
    AppDelegate *appDelegate;
    CSRmeshDevice *selectedDevice;
    UIPickerView *pickerview;
    NSMutableArray *devicesAddedWithRules;
    NSString *selectedSensor;
    NSString *sensorId;
    NSMutableArray *myRules;
    NSIndexPath *ruleToDelete;
}

@end

@implementation MyRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showNavMenuButton=YES;
   appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self.tblViewMyRules registerNib:[UINib nibWithNibName:@"MyRuleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyRuleCell"];
    
   // NSSet *placesSet=[[CSRDatabaseManager sharedInstance] fetchObjectsWithEntityName:@"Places" withPredicate:nil];
    devicesAddedWithRules=[[NSMutableArray alloc] init];
    [self getSensorId];
    
     selectedSensor=SENSOR_TYPE_MOTION;
    
    [self getMyRules:selectedSensor];
}


-(void)getMyRules:(NSString *)sensorType{
    myRules=[[[CSRDatabaseManager sharedInstance] managedObjectsForClass:NSStringFromClass([MyRules class]) sortedByKey:@"entityId" usingArrayOfIds:@[sensorType] inArrayOfIds:YES forEntity:@"sensorType"] mutableCopy];
    [self.tblViewMyRules reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-tableView datasource and delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myRules.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //set custom color for cell background before display
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MyRuleCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    [(MyRuleCell*)cell setMyRuleCellDelegate:self];
    
    MyRules *rules=[myRules objectAtIndex:indexPath.row];
    
    [[(MyRuleCell *)cell lblTitle] setText:rules.deviceName];
    
    if ([rules.sensorType isEqualToString:SENSOR_TYPE_MOTION]) {
        if ([rules.rule intValue]==0) {
            [[(MyRuleCell *)cell btnTruFalse] setTitle:@"True" forState:UIControlStateNormal];
        }
        else{
            [[(MyRuleCell *)cell btnTruFalse] setTitle:@"False" forState:UIControlStateNormal];
        }
    }
    else if ([rules.sensorType isEqualToString:SENSOR_TYPE_LUMINANCE]){
           [[(MyRuleCell *)cell btnTruFalse] setTitle:rules.rule forState:UIControlStateNormal];
    }

    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //do sth.
        ruleToDelete=indexPath;
        [self showAlert:APPLICATION_NAME message:[self prepareDeleteAlertMessage:[(MyRuleCell*)[self.tblViewMyRules cellForRowAtIndexPath:indexPath] lblTitle].text] Delegate:self];
        
        
    }
}



#pragma mark-general button clicks

- (IBAction)clickBtnLeft:(id)sender {
    
    selectedSensor=SENSOR_TYPE_TEMPERATURE;
    [self getMyRules:selectedSensor];
    [_btnLeft setSelected:YES];
    [_btnCentre setSelected:NO];
    [_btnRight setSelected:NO];
    [_imgViewMotionCentre setImage:[UIImage imageNamed:@"temperature"]];
}

- (IBAction)clickBtnCentre:(id)sender {
    
    selectedSensor=SENSOR_TYPE_MOTION;
    [self getMyRules:selectedSensor];
    [_btnLeft setSelected:NO];
    [_btnCentre setSelected:YES];
    [_btnRight setSelected:NO];
    [_imgViewMotionCentre setImage:[UIImage imageNamed:@"img_motion"]];
}

- (IBAction)clickBtnRight:(id)sender {
    
   selectedSensor=SENSOR_TYPE_LUMINANCE;
    [self getMyRules:selectedSensor];
    [_btnLeft setSelected:NO];
    [_btnCentre setSelected:NO];
    [_btnRight setSelected:YES];
    [_imgViewMotionCentre setImage:[UIImage imageNamed:@"luminanace"]];
    
}
- (IBAction)clickBtnRemoveRule:(id)sender {
    
    [self.tblViewMyRules setEditing:YES];
    
}
- (IBAction)clickBtnAddRule:(id)sender {
    if (!sensorId) {
        [self showAlertMessage:APPLICATION_NAME message:@"Please add a sensor to add rules" Delegate:self];
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddRulesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddRulesViewController"];
    
    [vc setAddRuleViewDelegate:self];
    
    [vc setSelectedSensor:selectedSensor];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark- alertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
    }
    else if (buttonIndex==1){
        //write code to delete the rule
        [self removeRule];
    }
}



#pragma mark-general functions


-(void)removeRule{
    MyRules *rules=[myRules objectAtIndex:ruleToDelete.row];
    [[CSRDatabaseManager sharedInstance] deleteManagedObjectWithClassName:NSStringFromClass([MyRules class]) withEntityId:rules.deviceId];
    [self getMyRules:selectedSensor];
}

-(NSString*)prepareDeleteAlertMessage:(NSString*)itemTitle{
    return [NSString stringWithFormat:@"Do you want to delete this? \r %@ will only work in manual mode.",itemTitle];
}

#pragma mark-add rule view delegate
-(void)gotoMyRulesView:(CSRmeshDevice *)meshDevice andRule:(NSString*)rule{
    if (meshDevice != nil && rule != nil)
    {
        selectedDevice=meshDevice;
        [devicesAddedWithRules addObject:meshDevice];
        [self saveMyruleData:meshDevice andRule:rule];
        
        [self getMyRules:selectedSensor];
    }
}


#pragma mark-my rule cell delegate
-(void)gotoMyRuleView:(NSIndexPath *)indexPath{
    
    MyRules *rule=[myRules objectAtIndex:indexPath.row];
    
    CSRmeshDevice *meshDevice=[[CSRDevicesManager sharedInstance] getDeviceFromDeviceId:[NSNumber numberWithInt:[rule.deviceId intValue]]];
        [meshDevice setPower:YES];
    
}

#pragma do some core data operation

-(void)saveMyruleData:(CSRmeshDevice*)meshDevice andRule:(NSString*)rule{
    
    
    NSManagedObjectContext *managedObjectContext = [[CSRDatabaseManager sharedInstance] managedObjectContext];
    
    NSManagedObject *managedObject = [[CSRDatabaseManager sharedInstance] newManagedObjectWithClassName:NSStringFromClass([MyRules class]) withEntityId:[NSString stringWithFormat:@"%@",meshDevice.deviceId]];
    
    [managedObject setValue:[NSString stringWithFormat:@"%@",meshDevice.deviceId] forKey:@"deviceId"];
    [managedObject setValue:meshDevice.name forKey:@"deviceName"];
    [managedObject setValue:selectedSensor forKey:@"sensorType"];
    [managedObject setValue:rule forKey:@"rule"];
    [managedObject setValue:sensorId forKey:@"sensorId"];
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Unable to save context for class");
    };
}

-(void)getSensorId{
    NSArray *devicesArray = [[CSRDevicesManager sharedInstance] getAllAssociatedDevices];
    
       devicesArray=[[[CSRDatabaseManager sharedInstance] managedObjectsForClass:NSStringFromClass([CSRDeviceEntity class]) sortedByKey:@"deviceId" usingArrayOfIds:nil inArrayOfIds:NO forEntity:@"deviceId"] mutableCopy];
    
    for (CSRDeviceEntity *device in devicesArray)
    {
        NSString *originalUUID = @"";
        if ([device uuidString]!= nil)
        {
            originalUUID = [NSString stringWithFormat:@"%@",[device uuidString]];
            NSString *actualUUID = [originalUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *deviceID = [actualUUID substringWithRange:NSMakeRange(actualUUID.length - 14, 2)];
            
            if ([deviceID isEqualToString:@"06"])
                sensorId=deviceID;
        }
    }
    
    if (!sensorId) {
          [self showAlertMessage:APPLICATION_NAME message:@"Please add a sensor device to add rule." Delegate:self];
    }

}
@end
