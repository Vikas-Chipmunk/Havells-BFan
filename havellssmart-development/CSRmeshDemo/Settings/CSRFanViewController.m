//
//  CSRFanViewController.m
//  CSRmeshDemo
//
//  Created by Vikas M K on 23/02/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "CSRFanViewController.h"
#import <CSRmesh/PowerModelApi.h>
#import "CSRDevicesManager.h"
#import <CSRmesh/LightModelApi.h>
#import <CSRmesh/ActuatorModelApi.h>
#import "CSRFanControlTableViewCell.h"

@interface CSRFanViewController ()

@end

@implementation CSRFanViewController

@synthesize lightDevice;
@synthesize deviceEntity;
@synthesize fanControllView;
@synthesize innerNobeImageView;
@synthesize outterSpeedImageview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lightDevice = [[CSRDevicesManager sharedInstance] selectedDevice];
    
    CGRect minuteSliderFrame = CGRectMake(-25, -25, 330, 330);
    minuteSlider = [[EFCircularSlider alloc] initWithFrame:minuteSliderFrame];
    minuteSlider.unfilledColor = [UIColor clearColor];
    minuteSlider.filledColor = [UIColor clearColor];
    [minuteSlider setInnerMarkingLabels:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"OFF"]];
    minuteSlider.labelFont = [UIFont systemFontOfSize:18.0f];
    minuteSlider.lineWidth = 8;
    minuteSlider.minimumValue = 0;
    minuteSlider.maximumValue = 60;
    minuteSlider.snapToLabels = NO;
    minuteSlider.labelColor = [UIColor whiteColor];
    minuteSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    minuteSlider.handleColor = minuteSlider.filledColor;
    minuteSlider.delegate = self;
    
    [fanControllView addSubview:minuteSlider];
    
    CGRect hourSliderFrame = CGRectMake(30, 30, 220, 220);
    hourSlider = [[EFCircularSlider alloc] initWithFrame:hourSliderFrame];
    hourSlider.unfilledColor = [UIColor clearColor];
    hourSlider.filledColor = [UIColor clearColor];
    [hourSlider setInnerMarkingLabels:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"OFF"]];
    hourSlider.labelFont = [UIFont systemFontOfSize:0.0f];
    hourSlider.lineWidth = 12;
    hourSlider.snapToLabels = YES;
    hourSlider.minimumValue = 0;
    hourSlider.maximumValue = 12;
    hourSlider.labelColor = [UIColor clearColor];
    hourSlider.handleType = CircularSliderHandleTypeBigCircle;
    hourSlider.handleColor = [UIColor colorWithRed:96/255.0f green:96/255.0f blue:96/255.0f alpha:1.0f];
    hourSlider.delegate = self;
    [fanControllView addSubview:hourSlider];
    
    self.fanControlTableView.allowsSelection=YES;
    
    //[self getFanSpeedValuesFromAPI];
    
    /*if (lightPowerOnSwitch.isOn)
        [innerNobeImageView setImage:[UIImage imageNamed:@"InnerCircle_glow"]];
    else
        [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];*/
    
    [[LightModelApi sharedInstance] getState:lightDevice.deviceId success:^(NSNumber *deviceId, UIColor *color, NSNumber *powerState, NSNumber *colorTemperature, NSNumber *supports) {
        
        if (powerState == [NSNumber numberWithInt:0])
        {
            [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
            [lightPowerOnSwitch setOn:NO animated:YES];
        }
        else
        {
            [innerNobeImageView setImage:[UIImage imageNamed:@"InnerCircle_glow"]];
            [lightPowerOnSwitch setOn:YES animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [[PowerModelApi sharedInstance] getState:lightDevice.deviceId success:^(NSNumber *deviceId, NSNumber *state) {
        
        if (state == [NSNumber numberWithInt:0])
        {
            isFanPowerOn = NO;
            UIView *grayScreen = [[UIView alloc] initWithFrame:minuteSlider.frame];
            [grayScreen setTag:999];
            [grayScreen setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
            [fanControllView addSubview:grayScreen];
            
            [fanControllView setUserInteractionEnabled:NO];
            [fanPowerOnSwitch setOn:NO animated:YES];
        }
        else
        {
            isFanPowerOn = YES;
            for (UIView *view in fanControllView.subviews)
                if ([view isKindOfClass:[UIView class]] && view.tag == 999)
                    [view removeFromSuperview];
            [fanControllView setUserInteractionEnabled:YES];
            [fanPowerOnSwitch setOn:YES animated:YES];
            [self getFanSpeedValuesFromAPI];
            [self.fanControlTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    [[MeshServiceApi sharedInstance] setRetryCount:@0];
    
    /*if (fanPowerOnSwitch.isOn)
    {
        for (UIView *view in fanControllView.subviews)
            if ([view isKindOfClass:[UIView class]] && view.tag == 999)
                [view removeFromSuperview];
        [fanControllView setUserInteractionEnabled:YES];
    }
    else
    {
        UIView *grayScreen = [[UIView alloc] initWithFrame:minuteSlider.frame];
        [grayScreen setTag:999];
        [grayScreen setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        [fanControllView addSubview:grayScreen];
        
        [fanControllView setUserInteractionEnabled:NO];
    }*/
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.timerValueDict.count==2) {
        [self.fanControlTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Circular Slider Delegate -

- (void)getButtonClickedIndexValue:(float)updateedValue andClickedIndex:(int)index
{

    [hourSlider setCurrentValue:updateedValue];
    [hourSlider setNeedsDisplay];
    
    /*if (index!= 8)
        [fanPowerOnSwitch setOn:YES];
    else
        [fanPowerOnSwitch setOn:NO];*/
    [self callActuatorModelWithValue:index];
}

- (void)getButtonClickedIndexOnSliderValueClickedIndex:(int)index
{
    [self callActuatorModelWithValue:index];
}

#pragma mark - Private Methods -

- (void)getFanSpeedValuesFromAPI
{
    if (fanPowerOnSwitch.isOn)
    {
        [[ActuatorModelApi sharedInstance] getValue:lightDevice.deviceId actuatorType:[NSNumber numberWithInt:51] success:^(NSNumber *deviceId, NSNumber *actuatorType, NSNumber *actuatorValue) {
            
            float fanSpeedLevel = 1.33;
            float fanUIPercentage = 0;
            NSString *imageName = @"outerCircle-Off";
            if ([actuatorValue intValue] == 248)
            {
                imageName = @"outerCircle-8";
                fanSpeedLevel = fanSpeedLevel * 8;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else if ([actuatorValue intValue] == 249)
            {
                imageName = @"outerCircle-7";
                fanSpeedLevel = fanSpeedLevel * 7;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else if ([actuatorValue intValue] == 250)
            {
                imageName = @"outerCircle-6";
                fanSpeedLevel = fanSpeedLevel * 6;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else if ([actuatorValue intValue] == 251)
            {
                imageName = @"outerCircle-5";
                fanSpeedLevel = fanSpeedLevel * 5;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else if ([actuatorValue intValue] == 252)
            {
                imageName = @"outerCircle-4";
                fanSpeedLevel = fanSpeedLevel * 4;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else if ([actuatorValue intValue] == 253)
            {
                imageName = @"outerCircle-3";
                fanSpeedLevel = fanSpeedLevel * 3;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else if ([actuatorValue intValue] == 254)
            {
                imageName = @"outerCircle-2";
                fanSpeedLevel = fanSpeedLevel * 2;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else if ([actuatorValue intValue] == 255)
            {
                imageName = @"outerCircle-1";
                fanSpeedLevel = fanSpeedLevel * 1;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            else
            {
                imageName = @"outerCircle-Off";
                fanSpeedLevel = fanSpeedLevel * 0;
                fanUIPercentage = roundf (fanSpeedLevel * 100) / 100.0;
            }
            [outterSpeedImageview setImage:[UIImage imageNamed:imageName]];
            [self updateUIWithPercentage:fanUIPercentage];
            
        } failure:^(NSError *error) {
            [outterSpeedImageview setImage:[UIImage imageNamed:@"outerCircle-Off"]];
            [self updateUIWithPercentage:0];
        }];
    }
}

- (void)updateUIWithPercentage :(float)updateedValue
{
    [hourSlider setCurrentValue:updateedValue];
    [hourSlider setNeedsDisplay];
}

- (void)callActuatorModelWithValue:(int)actuatorValue
{
    NSString *hexaValueOfFanSpeed = @"0x00";
    NSString *imageName = @"outerCircle-Off";
    switch (actuatorValue)
    {
        case 8:
        {
            imageName = @"outerCircle-Off";
            hexaValueOfFanSpeed = @"0x00";
            [fanPowerOnSwitch setOn:NO animated:YES];
            [lightPowerOnSwitch setOn:NO animated:YES];
            
            isFanPowerOn = NO;
            UIView *grayScreen = [[UIView alloc] initWithFrame:minuteSlider.frame];
            [grayScreen setTag:999];
            [grayScreen setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
            [fanControllView addSubview:grayScreen];
            [fanControllView setUserInteractionEnabled:NO];
            [self.fanControlTableView reloadData];
            
            break;
        }
            
        case 0:
        {
            imageName = @"outerCircle-1";
            hexaValueOfFanSpeed = @"0xff";
            break;
        }
            
        case 1:
        {
            imageName = @"outerCircle-2";
            hexaValueOfFanSpeed = @"0xfe";
            break;
        }
            
        case 2:
        {
            imageName = @"outerCircle-3";
            hexaValueOfFanSpeed = @"0xfd";
            break;
        }
            
        case 3:
        {
            imageName = @"outerCircle-4";
            hexaValueOfFanSpeed = @"0xfc";
            break;
        }
            
        case 4:
        {
            imageName = @"outerCircle-5";
            hexaValueOfFanSpeed = @"0xfb";
            break;
        }
            
        case 5:
        {
            imageName = @"outerCircle-6";
            hexaValueOfFanSpeed = @"0xfa";
            break;
        }
            
        case 6:
        {
            imageName = @"outerCircle-7";
            hexaValueOfFanSpeed = @"0xf9";
            break;
        }
            
        case 7:
        {
            imageName = @"outerCircle-8";
            hexaValueOfFanSpeed = @"0xf8";
            break;
        }
    }
    
    [outterSpeedImageview setImage:[UIImage imageNamed:imageName]];
    
    if (!fanPowerOnSwitch.isOn && actuatorValue != 8)
        [fanPowerOnSwitch setOn:YES animated:YES];
    
    //if (!lightPowerOnSwitch.isOn)
        //[lightPowerOnSwitch setOn:YES];
    
    unsigned int tempInt;
    NSScanner *scanner = [NSScanner scannerWithString:hexaValueOfFanSpeed];
    [scanner scanHexInt:&tempInt];
    NSNumber *fanSpeedControllNumber = [NSNumber numberWithInt:tempInt];
    
    [[ActuatorModelApi sharedInstance] setValue:lightDevice.deviceId actuatorType:[NSNumber numberWithInt:51] actuatorValue:fanSpeedControllNumber acknowledge:NO];
}

#pragma mark - TABLEVIEW DATASOURCE & DELEGATES -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *facControlCellIdentifier = @"facControlCellIdentifier";
    CSRFanControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:facControlCellIdentifier];

    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        [cell.cellIconImageView setImage:[UIImage imageNamed:@"Icn_Fan-1"]];
        [cell.tiltleForCellLabel setText:@"Power"];
        [cell.descriptionForCellLabel setText:@""];
        [fanPowerOnSwitch removeFromSuperview];
        
        fanPowerOnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((cell.frame.size.width) - 120 , cell.customViewForCell.frame.size.height /2 , cell.customViewForCell.frame.size.width, 31)];
        [fanPowerOnSwitch addTarget:self action:@selector(fanPowerSwitch:) forControlEvents:UIControlEventValueChanged];
        fanPowerOnSwitch.enabled = YES;
        
        if (isFanPowerOn)
            [fanPowerOnSwitch setOn:YES animated:YES];
        else
            [fanPowerOnSwitch setOn:NO animated:YES];
        
        [cell.contentView addSubview:fanPowerOnSwitch];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 1)
    {
        [cell.cellIconImageView setImage:[UIImage imageNamed:@"Icn_light"]];
        [cell.tiltleForCellLabel setText:@"Light"];
        [cell.descriptionForCellLabel setText:@""];
        [lightPowerOnSwitch removeFromSuperview];
        
        lightPowerOnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((cell.frame.size.width) - 120 , cell.customViewForCell.frame.size.height /2 , cell.customViewForCell.frame.size.width, 31)];
        [lightPowerOnSwitch addTarget:self action:@selector(lightPowerSwitch:) forControlEvents:UIControlEventValueChanged];
        lightPowerOnSwitch.enabled = YES;
        
        if (isFanPowerOn)
            [lightPowerOnSwitch setOn:YES animated:YES];
        else
            [lightPowerOnSwitch setOn:NO animated:YES];
        
        [cell.contentView addSubview:lightPowerOnSwitch];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (fanPowerOnSwitch.isOn)
        {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setUserInteractionEnabled:YES];
        }
        else
        {
            [cell setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
            [cell setUserInteractionEnabled:NO];
        }
    }
    else if (indexPath.row == 2)
    {
        [cell.cellIconImageView setImage:[UIImage imageNamed:@"icn_timer"]];
        [cell.tiltleForCellLabel setText:@"Fan Timer"];
        if ([self.timerValueDict valueForKey:@"TIMER"]!=nil && [self.timerValueDict valueForKey:@"SPEED"]!=nil)
        {
            [customLabel removeFromSuperview];
            if (![[self.timerValueDict valueForKey:@"SPEED"] isEqualToString:@"OFF"])
            {
                NSString *timerValue = [self formatString:[self.timerValueDict valueForKey:@"TIMER"]];
                
                [cell.descriptionForCellLabel setText:[NSString stringWithFormat:@"At %@ Fan Speed changes to", timerValue]];
                
                customLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.customViewForCell.frame.origin.x , cell.customViewForCell.frame.origin.y + 10, cell.customViewForCell.frame.size.width, cell.customViewForCell.frame.size.height)];
                [customLabel setBackgroundColor:[UIColor clearColor]];
                [customLabel setTextColor:[UIColor whiteColor]];
                [customLabel setText:[self.timerValueDict valueForKey:@"SPEED"]];
                
                [cell.contentView addSubview:customLabel];
            }
            else
            {
                NSString *timerValue = [self formatString:[self.timerValueDict valueForKey:@"TIMER"]];
                
                [cell.descriptionForCellLabel setText:[NSString stringWithFormat:@"At %@ Fan will be ", timerValue]];
                
                customLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.customViewForCell.frame.origin.x , cell.customViewForCell.frame.origin.y + 10, cell.customViewForCell.frame.size.width, cell.customViewForCell.frame.size.height)];
                [customLabel setBackgroundColor:[UIColor clearColor]];
                [customLabel setTextColor:[UIColor whiteColor]];
                [customLabel setText:[self.timerValueDict valueForKey:@"SPEED"]];
                
                [cell.contentView addSubview:customLabel];
            }
        }
        else
            [cell.descriptionForCellLabel setText:@""];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (fanPowerOnSwitch.isOn)
        {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setUserInteractionEnabled:YES];
        }
        else
        {
            [cell setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
            [cell setUserInteractionEnabled:NO];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //[[PowerModelApi sharedInstance] setPowerState:lightDevice.deviceId state:[NSNumber numberWithBool:fanPowerOnSwitch.isOn] acknowledged:NO];
        if (fanPowerOnSwitch.isOn)
        {
            isFanPowerOn = NO;
            [fanPowerOnSwitch setOn:NO animated:YES];
            [lightPowerOnSwitch setOn:NO animated:YES];
            [self updateUIWithPercentage:0.0];
            [outterSpeedImageview setImage:[UIImage imageNamed:@"outerCircle-Off"]];
            [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
            [[PowerModelApi sharedInstance] setPowerState:lightDevice.deviceId state:[NSNumber numberWithBool:NO] acknowledged:NO];
            
            UIView *grayScreen = [[UIView alloc] initWithFrame:minuteSlider.frame];
            [grayScreen setTag:999];
            [grayScreen setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
            [fanControllView addSubview:grayScreen];
            
            [fanControllView setUserInteractionEnabled:NO];
        }
        else
        {
            isFanPowerOn = YES;
            [fanPowerOnSwitch setOn:YES animated:YES];
            //[lightPowerOnSwitch setOn:YES animated:YES];
            [self getFanSpeedValuesFromAPI];
            [[PowerModelApi sharedInstance] setPowerState:lightDevice.deviceId state:[NSNumber numberWithBool:YES] acknowledged:NO];
            
            for (UIView *view in fanControllView.subviews)
                if ([view isKindOfClass:[UIView class]] && view.tag == 999)
                    [view removeFromSuperview];
            [fanControllView setUserInteractionEnabled:YES];
            
            [[LightModelApi sharedInstance] getState:lightDevice.deviceId success:^(NSNumber *deviceId, UIColor *color, NSNumber *powerState, NSNumber *colorTemperature, NSNumber *supports) {
                
                if (powerState == [NSNumber numberWithInt:0])
                {
                    [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
                    [lightPowerOnSwitch setOn:NO animated:YES];
                }
                else
                {
                    [innerNobeImageView setImage:[UIImage imageNamed:@"InnerCircle_glow"]];
                    [lightPowerOnSwitch setOn:YES animated:YES];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
        
        [self.fanControlTableView reloadData];
    }
    else if (indexPath.row == 1)
    {
        /*if (lightPowerOnSwitch.isOn)
            [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
        else
            [innerNobeImageView setImage:[UIImage imageNamed:@"InnerCircle_glow"]];*/
        
        NSString *lightControllOnOFF;
        if (lightPowerOnSwitch.isOn)
        {
            [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
            [lightPowerOnSwitch setOn:NO animated:YES];
            lightControllOnOFF = @"0x80";
        }
        else
        {
            [innerNobeImageView setImage:[UIImage imageNamed:@"InnerCircle_glow"]];
            [lightPowerOnSwitch setOn:YES animated:YES];
            lightControllOnOFF = @"0x81";
        }
        
        unsigned int tempInt;
        NSScanner *scanner = [NSScanner scannerWithString:lightControllOnOFF];
        [scanner scanHexInt:&tempInt];
        NSNumber *lightControllNumber = [NSNumber numberWithInt:tempInt];
        [[LightModelApi sharedInstance] setLevel:lightDevice.deviceId level:lightControllNumber acknowledged:NO];
    }
    else if (indexPath.row == 2)
    {
        [self gotoTimerControlScreen];
        
    }
}

#pragma mark - UISwitch Control Methods -

- (void)fanPowerSwitch:(UISwitch *)fanContolSwitch
{
    if (fanPowerOnSwitch.isOn)
    {
        isFanPowerOn = YES;
        //[lightPowerOnSwitch setOn:YES animated:YES];
        [[LightModelApi sharedInstance] getState:lightDevice.deviceId success:^(NSNumber *deviceId, UIColor *color, NSNumber *powerState, NSNumber *colorTemperature, NSNumber *supports) {
            
            if (powerState == [NSNumber numberWithInt:0])
            {
                [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
                [lightPowerOnSwitch setOn:NO animated:YES];
            }
            else
            {
                [innerNobeImageView setImage:[UIImage imageNamed:@"InnerCircle_glow"]];
                [lightPowerOnSwitch setOn:YES animated:YES];
            }
        } failure:^(NSError *error) {
            
        }];
        [self getFanSpeedValuesFromAPI];
        
        for (UIView *view in fanControllView.subviews)
            if ([view isKindOfClass:[UIView class]] && view.tag == 999)
                [view removeFromSuperview];
        [fanControllView setUserInteractionEnabled:YES];
    }
    else
    {
        isFanPowerOn = NO;
        [self updateUIWithPercentage:0.0];
        [outterSpeedImageview setImage:[UIImage imageNamed:@"outerCircle-Off"]];
        [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
        [lightPowerOnSwitch setOn:NO animated:YES];
        
        UIView *grayScreen = [[UIView alloc] initWithFrame:minuteSlider.frame];
        [grayScreen setTag:999];
        [grayScreen setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        [fanControllView addSubview:grayScreen];
        
        [fanControllView setUserInteractionEnabled:NO];
    }
    [[PowerModelApi sharedInstance] setPowerState:lightDevice.deviceId state:[NSNumber numberWithBool:fanPowerOnSwitch.isOn] acknowledged:NO];
    
    [self.fanControlTableView reloadData];
}

- (void)lightPowerSwitch:(UISwitch *)fanContolSwitch
{
    if (lightPowerOnSwitch.isOn)
        [innerNobeImageView setImage:[UIImage imageNamed:@"InnerCircle_glow"]];
    else
        [innerNobeImageView setImage:[UIImage imageNamed:@"speedControlInnerCircle"]];
    
    NSString *lightControllOnOFF;
    if (lightPowerOnSwitch.isOn)
        lightControllOnOFF = @"0x81";
    else
        lightControllOnOFF = @"0x80";
    
    unsigned int tempInt;
    NSScanner *scanner = [NSScanner scannerWithString:lightControllOnOFF];
    [scanner scanHexInt:&tempInt];
    NSNumber *lightControllNumber = [NSNumber numberWithInt:tempInt];
    [[LightModelApi sharedInstance] setLevel:lightDevice.deviceId level:lightControllNumber acknowledged:NO];
}


#pragma mark-navigation

-(void)gotoTimerControlScreen{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *mviewController =[storyboard instantiateViewControllerWithIdentifier:@"CSRTimerControlViewController"];
    
    [self.navigationController pushViewController:mviewController animated:YES];
}

#pragma mark-general

-(NSString *)formatString:(NSString *)timerValue{
    //0 Hours 30 mins
    timerValue=[timerValue stringByReplacingOccurrencesOfString:@"Hours " withString:@":"];
    timerValue=[timerValue stringByReplacingOccurrencesOfString:@" mins" withString:@""];
    
    return timerValue;
}

@end
