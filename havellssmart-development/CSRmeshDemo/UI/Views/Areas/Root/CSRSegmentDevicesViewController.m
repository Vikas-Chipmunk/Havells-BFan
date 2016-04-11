//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//

#import "CSRSegmentDevicesViewController.h"
#import "CSRmeshStyleKit.h"
#import "CSRAppStateManager.h"
#import "CSRmeshDevice.h"
#import "CSRDeviceEntity.h"
#import "CSRAreaEntity.h"
#import "CSRDevicesManager.h"
#import "CSRmeshDevice.h"
#import "CSRDevicesManager.h"
#import "CSRUtilities.h"

@interface CSRSegmentDevicesViewController ()

@end

@implementation CSRSegmentDevicesViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    CSRmeshArea *area = [[CSRDevicesManager sharedInstance] getAreaFromId:_areaEntity.areaID];
    if (area) {
        [[CSRDevicesManager sharedInstance] setSelectedDevice:area.areaDevice];
        [[CSRDevicesManager sharedInstance] setSelectedArea:area];
        
    }
    
    self.segmentSwitch.apportionsSegmentWidthsByContent = YES;
    
    _devicesMutableArray = [NSMutableArray new];
    
    [self refreshDevices:nil];
   
    
}

- (void) viewWillAppear:(BOOL)animated
{
    //Set navigation buttons
    _backButton.image = [CSRmeshStyleKit imageOfBack_arrow];
    _backButton.action = @selector(backForSelf:);
    _backButton.target = self;
    
}

- (void)refreshDevices:(id)sender
{
    if (_areaEntity) {
    [_devicesMutableArray removeAllObjects];
    
    __block NSMutableDictionary *dict = [NSMutableDictionary new];
    _devicesMutableArray = [[_areaEntity.devices allObjects] mutableCopy];
    
    [_devicesMutableArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        CSRDeviceEntity *deviceEntity = (CSRDeviceEntity*)obj;
        if ([deviceEntity.appearance isEqual:@(CSRApperanceNameLight)]) {
            [dict setValue:@"LightViewController" forKey:@"light"];
        }
        if ([deviceEntity.appearance isEqualToNumber:@(CSRApperanceNameSensor)]) {
            [dict setValue:@"TemperatureViewController" forKey:@"heater"];
        }
        if ([deviceEntity.appearance isEqualToNumber:@(CSRApperanceNameSwitch)]) {
            [dict setValue:@"LockViewController" forKey:@"switch"];
        }
        
    }];
        NSLog(@"dict :%@", dict);
        
        NSUInteger segmentIndex = 0;
    [self.segmentSwitch removeAllSegments];
        if (dict[@"light"]) {
            [self.segmentSwitch insertSegmentWithTitle:@"Light" atIndex:segmentIndex animated:NO];
            segmentIndex++;
        }
        if (dict[@"sensor"]) {
            [self.segmentSwitch insertSegmentWithTitle:@"Sensor" atIndex:segmentIndex animated:NO];
            segmentIndex++;
        }
        if (dict[@"heater"]) {
            [self.segmentSwitch insertSegmentWithTitle:@"Heater" atIndex:segmentIndex animated:NO];
            segmentIndex++;
        }
        if (dict[@"switch"]) {
            [self.segmentSwitch insertSegmentWithTitle:@"Switch" atIndex:segmentIndex animated:NO];
            segmentIndex++;
        }
        if ([dict count] == 1) {
            self.segmentSwitch.hidden = YES;
        }
    }
    
    if (_areaEntity) {
        self.title = _areaEntity.areaName;
        [self.segmentSwitch setSelectedSegmentIndex:0];
        [self segmentSwitchAction:self.segmentSwitch];
        
    }
    

    
    
}

- (IBAction)segmentSwitchAction:(UISegmentedControl*)sender
{
    if ([[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] isEqualToString:@"Light"]) {
        
        [self instantiateView:@"LightViewController"];
        
    } else if ([[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] isEqualToString:@"Heater"]) {
        
        [self instantiateView:@"TemperatureViewController"];
        
    } else if ([[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] isEqualToString:@"Switch"]) {
        
        [self instantiateView:@"LockViewController"];
        
    }
    
}

- (void) instantiateView:(NSString*)viewName
{
    _lightViewController.view = nil;
    _temperatureViewController.view = nil;
    _lockViewController.view = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc1= (UIViewController*)[storyboard instantiateViewControllerWithIdentifier:viewName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self addChildViewController:vc1];
        vc1.view.frame = CGRectMake(0, 0, _controlView.frame.size.width, _controlView.frame.size.height);
        [_controlView addSubview:vc1.view];
        [vc1 didMoveToParentViewController:self];
    });
}

- (IBAction)backForSelf:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
