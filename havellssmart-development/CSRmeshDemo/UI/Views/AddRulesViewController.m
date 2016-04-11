//
//  AddRulesViewController.m
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 29/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "AddRulesViewController.h"
#import "CSRDatabaseManager.h"
#import "Places.h"
#import "CSRDevicesManager.h"


@interface AddRulesViewController()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *pickerItemArray;
    UIPickerView *pickerview;
    NSSet *placesSet;
    CSRmeshDevice *selectedDevice;
    NSString  *selectedRule;
}
@end

@implementation AddRulesViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    pickerItemArray=[[NSMutableArray alloc] init];
    //pickerItemArray=[[NSMutableArray alloc] initWithObjects:@"Test 1",@"Test 2",@"Test 3", nil];
    pickerview=[[UIPickerView alloc] init];
    [pickerview setHidden:YES];
    
    //placesSet=[[CSRDatabaseManager sharedInstance] fetchObjectsWithEntityName:@"Places" withPredicate:nil];
   // pickerItemArray=[NSMutableArray arrayWithArray:[placesSet allObjects]];
//    for (CSRmeshDevice *meshDevice in [[CSRDevicesManager sharedInstance] getAllAssociatedDevices]) {
//        [pickerItemArray addObject:meshDevice.name];
//    }
    
    [self.tblViewLightOptions reloadData];
    
    self.viewContainingItems.layer.cornerRadius=5.0;
    
}

-(void)getActiveDevices{
    
    
    pickerItemArray=[[CSRDevicesManager sharedInstance] getAllAssociatedDevices];
    
 //   NSArray *devicesArray = [[CSRDevicesManager sharedInstance] getAllAssociatedDevices];
    
//    for (CSRmeshDevice *device in devicesArray)
//    {
//        NSString *originalUUID = @"";
//        if ([device uuid]!= nil)
//        {
//            originalUUID = [NSString stringWithFormat:@"%@",[device uuid]];
//            NSString *actualUUID = [originalUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
//            NSString *deviceID = [actualUUID substringWithRange:NSMakeRange(actualUUID.length - 14, 2)];
//            
//            if ([deviceID isEqualToString:@"00"])
//                [pickerItemArray addObject:device];
//            else if ([deviceID isEqualToString:@"02"])
//                [pickerItemArray addObject:device];
//        }
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}



- (IBAction)clickBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickBtnOk:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.addRuleViewDelegate gotoMyRulesView:selectedDevice andRule:selectedRule];
    
}

- (IBAction)clickBtnLight:(id)sender {
    if (pickerview.isHidden==YES) {
        self.btnMotionOptions.hidden=YES;
        
        //placesSet=[[CSRDatabaseManager sharedInstance] fetchObjectsWithEntityName:@"Places" withPredicate:nil];
        // pickerItemArray=[NSMutableArray arrayWithArray:[placesSet allObjects]];
//        for (Places *place in [placesSet allObjects]) {
//            [pickerItemArray addObject:place.name];
//        }
        [pickerItemArray removeAllObjects];
        [self getActiveDevices];
//        for (CSRmeshDevice *meshDevice in [[CSRDevicesManager sharedInstance] getAllAssociatedDevices]) {
//            [pickerItemArray addObject:meshDevice.name];
//        }
        if (pickerItemArray.count>0) {
             [self loadPickerView:pickerItemArray andView:sender];
        }
       
    }
    else{
        self.btnMotionOptions.hidden=NO;
        pickerview.hidden=YES;
    }
}

- (IBAction)clickBtnMotionOptions:(id)sender {
    if (pickerview.isHidden) {
        self.btnLight.hidden=YES;
        [pickerItemArray removeAllObjects];
        if ([self.selectedSensor isEqualToString:SENSOR_TYPE_MOTION]) {
           pickerItemArray=[NSMutableArray arrayWithObjects:MOTION_SENSOR_RULE_1,MOTION_SENSOR_RULE_2, nil];
        }
        else if ([self.selectedSensor isEqualToString:SENSOR_TYPE_LUMINANCE]){
            pickerItemArray=[NSMutableArray arrayWithObjects:LUMINANCE_SENSOR_RULE_1,LUMINANCE_SENSOR_RULE_2, nil];
        }
        else{
            pickerItemArray=[NSMutableArray arrayWithObjects:TEMPERATURE_SENSOR_RULE_1,TEMPERATURE_SENSOR_RULE_2, nil];
        }
        
        [self loadPickerView:pickerItemArray andView:sender];
    }
    else{
        self.btnLight.hidden=NO;
        pickerview.hidden=YES;
    }
    
}

#pragma mark-uipickerview datasource and delegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return pickerItemArray.count;
}
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.btnLight.hidden==NO) {
        if ([[pickerItemArray objectAtIndex:row] isKindOfClass:[CSRmeshDevice class]])
            return  [[pickerItemArray objectAtIndex:row] name];
        else
            return [pickerItemArray objectAtIndex:row];
    }
    else{
        return  [pickerItemArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //Write the required logic here that should happen after you select a row in Picker View.
    if (self.btnLight.hidden==NO) {
        self.btnMotionOptions.hidden=NO;
        [self.btnLight setTitle:[[pickerItemArray objectAtIndex:row] name] forState:UIControlStateNormal];
        selectedDevice=[pickerItemArray objectAtIndex:row];
    }
    else if (self.btnMotionOptions.hidden==NO){
        self.btnLight.hidden=NO;
        [self.btnMotionOptions setTitle:[pickerItemArray objectAtIndex:row] forState:UIControlStateNormal];
        
//        if ([[pickerItemArray objectAtIndex:row] containsString:@"True"] && [self.selectedSensor isEqualToString:@"Motion"]) {
//            selectedRule=@"YES";
//        }
//        else if([[pickerItemArray objectAtIndex:row] containsString:@"False"] && [self.selectedSensor isEqualToString:@"Motion"]){
//            selectedRule=@"NO";
//        }
        
        selectedRule=[pickerItemArray objectAtIndex:row];
        
    }
    [pickerView setHidden:YES];
}

#pragma mark-general functions

-(void)loadPickerView:(NSArray*)pickerItem andView:(UIView*)view{
    
    pickerview.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y - 25.0f,view.frame.size.width, 30);
    
    pickerview.showsSelectionIndicator = YES;
    pickerview.hidden = NO;
    pickerview.delegate = self;
    [self.viewContainingItems addSubview:pickerview];
}

#pragma mark-tap gesture delegate
- (IBAction)onTappGestureDetected:(UITapGestureRecognizer *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
