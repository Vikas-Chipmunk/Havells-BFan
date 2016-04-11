//
//  CSRTimerControlViewController.m
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 13/03/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "CSRTimerControlViewController.h"
#import "Constant.h"
#import "CSRFanViewController.h"
#import <CSRmesh/ActuatorModelApi.h>
#import "CSRmeshDevice.h"
#import "CSRDevicesManager.h"

@interface CSRTimerControlViewController ()

{
    NSArray *timerArray;
    NSArray *fanSpeedArray;
    NSMutableDictionary *timerValueDict;
    CSRmeshDevice *lightDevice;
}

@end

@implementation CSRTimerControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lightDevice = [[CSRDevicesManager sharedInstance] selectedDevice];
    
    fanSpeedArray=[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"OFF", nil];
    
    
    
    timerArray=[NSArray arrayWithObjects:@"0 Hours 30 mins",@"1 Hours 00 mins",@"1 Hours 30 mins",@"2 Hours 00 mins",@"2 Hours 30 mins",@"3 Hours 00 mins",@"3 Hours 30 mins",@"4 Hours 00 mins",@"4 Hours 30 mins",@"5 Hours 00 mins",@"5 Hours 30 mins",@"6 Hours 00 mins",@"6 Hours 30 mins",@"7 Hours 00 mins",@"7 Hours 30 mins",@"8 Hours 00 mins", nil];//@"8 Hours 30 mins",@"9 Hours 00 mins",@"9 Hours 30 mins",@"10 Hours 00 mins",@"10 Hours 30 mins",@"11 Hours 00 mins",@"11 Hours 30 mins",@"12 Hours 00 mins",@"12 Hours 30 mins",@"13 Hours 00 mins",@"13 Hours 30 mins",@"14 Hours 00 mins",@"14 Hours 30 mins",@"15 Hours 00 mins",@"15 Hours 30 mins",@"16 Hours 00 mins",@"16 Hours 30 mins",@"17 Hours 00 mins",@"17 Hours 30 mins",@"18 Hours 00 mins",@"18 Hours 30 mins",@"19 Hours 00 mins",@"19 Hours 30 mins",@"20 Hours 00 mins",@"20 Hours 30 mins",@"21 Hours 00 mins",@"22 Hours 30 mins",@"23 Hours 00 mins",@"23 Hours 30 mins", nil];
    
    timerValueDict=[[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-uipickerview datasource and delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    
    if (pickerView==self.pickerViewFanSpeed) {
        return fanSpeedArray.count;
    }
    else{
    return timerArray.count;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString;
    
    if (pickerView==self.pickerViewFanSpeed && fanSpeedArray.count>0) {
       
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Fan Speed     %@",[fanSpeedArray objectAtIndex:row]] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    else{
        
        return [[NSAttributedString alloc] initWithString:[timerArray objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (pickerView==self.pickerViewFanSpeed) {
        [timerValueDict setValue:[fanSpeedArray objectAtIndex:row] forKey:@"SPEED"];
    }
    else{
        [timerValueDict setValue:[timerArray objectAtIndex:row] forKey:@"TIMER"];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickBtnSetTimer:(id)sender {
    
    if (timerValueDict.count<2) {
        [self showAlertWithMessage:@"Please select timer value and fan speed."];
    }
    else{
        
        [self getActuatorValue];
        /*[[ActuatorModelApi sharedInstance] setValue:lightDevice.deviceId actuatorType:[NSNumber numberWithInt:51] actuatorValue:[NSNumber numberWithInt:0] success:^(NSNumber *deviceId, NSNumber *actuatorType, NSNumber *actuatorValue) {
            
            NSArray *arraysOfViewController = [self.navigationController viewControllers];
            
            for (UIViewController *viewController in arraysOfViewController)
            {
                if ([viewController isKindOfClass:[CSRFanViewController class]])
                {
                    [(CSRFanViewController*)viewController setTimerValueDict:timerValueDict];
                    [self.navigationController popToViewController:viewController animated:YES];
                    break;
                }
            }
            
        } failure:^(NSError *error) {
            [self showAlertWithMessage:@"Not in a range, so please try once again"];
        }];*/
        /*NSArray *arraysOfViewController = [self.navigationController viewControllers];
        
        for (UIViewController *viewController in arraysOfViewController)
        {
            if ([viewController isKindOfClass:[CSRFanViewController class]])
            {
                [(CSRFanViewController*)viewController setTimerValueDict:timerValueDict];
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }*/
    }
    
}

-(void)showAlertWithMessage:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:msg delegate:nil cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    
    [alert show];
}

- (void)getActuatorValue
{
    NSString *selectedTimerValue = [timerValueDict valueForKey:@"TIMER"];
       
    NSString *timerValue = [selectedTimerValue stringByReplacingOccurrencesOfString:@" Hours " withString:@":"];
    timerValue = [timerValue stringByReplacingOccurrencesOfString:@" mins" withString:@""];
        
    NSString *hexValueForTimer;// = @"0xbe";
        
    if (![[timerValueDict valueForKey:@"SPEED"]isEqualToString:@"OFF"])
    {
        NSString *hexValueForOnTimer;
        
        if ([timerValue isEqualToString:@"1:00"])
            hexValueForOnTimer = @"bd";
        else if ([timerValue isEqualToString:@"1:30"])
            hexValueForOnTimer = @"bc";
        else if ([timerValue isEqualToString:@"2:00"])
            hexValueForOnTimer = @"bb";
        else if ([timerValue isEqualToString:@"2:30"])
            hexValueForOnTimer = @"ba";
        else if ([timerValue isEqualToString:@"3:00"])
            hexValueForOnTimer = @"b9";
        else if ([timerValue isEqualToString:@"3:30"])
            hexValueForOnTimer = @"b8";
        else if ([timerValue isEqualToString:@"4:00"])
            hexValueForOnTimer = @"b7";
        else if ([timerValue isEqualToString:@"4:30"])
            hexValueForOnTimer = @"b6";
        else if ([timerValue isEqualToString:@"5:00"])
            hexValueForOnTimer = @"b5";
        else if ([timerValue isEqualToString:@"5:30"])
            hexValueForOnTimer = @"b4";
        else if ([timerValue isEqualToString:@"6:00"])
            hexValueForOnTimer = @"b3";
        else if ([timerValue isEqualToString:@"6:30"])
            hexValueForOnTimer = @"b2";
        else if ([timerValue isEqualToString:@"7:00"])
            hexValueForOnTimer = @"b1";
        else if ([timerValue isEqualToString:@"7:30"])
            hexValueForOnTimer = @"b0";
        else if ([timerValue isEqualToString:@"8:00"])
            hexValueForOnTimer = @"af";
        else
            hexValueForOnTimer = @"be";//0:30 hrs
        
        NSString *hexValueForFanSpeed = @"00";
        if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 1)
            hexValueForFanSpeed = @"ff";
        else if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 2)
            hexValueForFanSpeed = @"fe";
        else if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 3)
            hexValueForFanSpeed = @"fd";
        else if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 4)
            hexValueForFanSpeed = @"fc";
        else if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 5)
            hexValueForFanSpeed = @"fb";
        else if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 6)
            hexValueForFanSpeed = @"fa";
        else if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 7)
            hexValueForFanSpeed = @"f9";
        else if ([[timerValueDict valueForKey:@"SPEED"] intValue] == 8)
            hexValueForFanSpeed = @"f8";
        
        hexValueForTimer = [NSString stringWithFormat:@"0x%@%@", hexValueForFanSpeed, hexValueForOnTimer];
    }
    else
    {
        NSString *hexValueForOffTimer;
        
        if ([timerValue isEqualToString:@"1:00"])
            hexValueForOffTimer = @"cd";
        else if ([timerValue isEqualToString:@"1:30"])
            hexValueForOffTimer = @"cc";
        else if ([timerValue isEqualToString:@"2:00"])
            hexValueForOffTimer = @"cb";
        else if ([timerValue isEqualToString:@"2:30"])
            hexValueForOffTimer = @"ca";
        else if ([timerValue isEqualToString:@"3:00"])
            hexValueForOffTimer = @"c9";
        else if ([timerValue isEqualToString:@"3:30"])
            hexValueForOffTimer = @"c8";
        else if ([timerValue isEqualToString:@"4:00"])
            hexValueForOffTimer = @"c7";
        else if ([timerValue isEqualToString:@"4:30"])
            hexValueForOffTimer = @"c6";
        else if ([timerValue isEqualToString:@"5:00"])
            hexValueForOffTimer = @"c5";
        else if ([timerValue isEqualToString:@"5:30"])
            hexValueForOffTimer = @"c4";
        else if ([timerValue isEqualToString:@"6:00"])
            hexValueForOffTimer = @"c3";
        else if ([timerValue isEqualToString:@"6:30"])
            hexValueForOffTimer = @"c2";
        else if ([timerValue isEqualToString:@"7:00"])
            hexValueForOffTimer = @"c1";
        else if ([timerValue isEqualToString:@"7:30"])
            hexValueForOffTimer = @"c0";
        else if ([timerValue isEqualToString:@"8:00"])
            hexValueForOffTimer = @"bf";
        else
            hexValueForOffTimer = @"ce";//0:30 hrs
        
        hexValueForTimer = [NSString stringWithFormat:@"0x00%@", hexValueForOffTimer];
    }
    
    unsigned int tempInt;
    NSScanner *scanner = [NSScanner scannerWithString:hexValueForTimer];
    [scanner scanHexInt:&tempInt];
    NSNumber *fanSpeedControllNumberBasedOnTimerValue = [NSNumber numberWithInt:tempInt];
    NSLog(@"Decimal Value = %@", fanSpeedControllNumberBasedOnTimerValue);
    
    [[ActuatorModelApi sharedInstance] setValue:lightDevice.deviceId actuatorType:[NSNumber numberWithInt:51] actuatorValue:fanSpeedControllNumberBasedOnTimerValue success:^(NSNumber *deviceId, NSNumber *actuatorType, NSNumber *actuatorValue) {
        
        NSArray *arraysOfViewController = [self.navigationController viewControllers];
        
        for (UIViewController *viewController in arraysOfViewController)
        {
            if ([viewController isKindOfClass:[CSRFanViewController class]])
            {
                [(CSRFanViewController*)viewController setTimerValueDict:timerValueDict];
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
        
    } failure:^(NSError *error) {
        [self showAlertWithMessage:@"Bridge is not in range, so please try once again"];
    }];
}

@end
