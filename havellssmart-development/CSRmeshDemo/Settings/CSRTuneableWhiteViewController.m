//
//  CSRTuneableWhiteViewController.m
//  CSRmeshDemo
//
//  Created by Vikas M K on 07/02/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "CSRTuneableWhiteViewController.h"

#import <CSRmesh/LightModelApi.h>
#import "CSRDevicesManager.h"
#import <CSRmesh/PowerModelApi.h>

@interface CSRTuneableWhiteViewController ()
{
    CGFloat intensityLevel;
    UIColor *chosenColor;
    CGPoint lastPosition;
    LightModelApi *lightModelAPi;
}
@end

@implementation CSRTuneableWhiteViewController

@synthesize topView;
@synthesize switchOnOff;
@synthesize lblThemes;
@synthesize btnRelaxed;
@synthesize btnConcentrate;
@synthesize btnGrind;
@synthesize btnEvening;
@synthesize btnNoon;
@synthesize btnNight;
@synthesize btnBulbBackground;
@synthesize lblIntensity;
@synthesize intensitySlider;
@synthesize imgViewBulb;

- (void)viewDidLoad
{
    [self loadnewUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lightDevice = [[CSRDevicesManager sharedInstance] selectedDevice];
    
    //Get current device power status
    [switchOnOff setOn:[_lightDevice getPower]];
    
    intensityLevel = 1.0;
    chosenColor = [UIColor whiteColor];
    lastPosition.x = 0;
    lastPosition.y = 0;
    
    /*UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
     
     [intensitySlider addGestureRecognizer:tapGestureRecognizer];*/
    
    lightModelAPi=[[LightModelApi sharedInstance] self];
}

-(void)viewWillAppear:(BOOL)animated{
    [intensitySlider setValue:_lightDevice.getLevel animated:YES];
    
    [[PowerModelApi sharedInstance] getState:_lightDevice.deviceId success:^(NSNumber *deviceId , NSNumber *state){
        
        [self updatePowerState:[state boolValue]];
        
    }failure:^(NSError *error){
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadnewUI
{
    btnRelaxed.layer.cornerRadius = 10; // this value vary as per your desire
    btnRelaxed.clipsToBounds = YES;
    btnConcentrate.layer.cornerRadius = 10;
    btnConcentrate.clipsToBounds = YES;
    btnGrind.layer.cornerRadius = 10;
    btnGrind.clipsToBounds = YES;
    btnEvening.layer.cornerRadius = 10;
    btnEvening.clipsToBounds = YES;
    btnNoon.layer.cornerRadius = 10;
    btnNoon.clipsToBounds = YES;
    btnNight.layer.cornerRadius = 10;
    btnNight.clipsToBounds = YES;
    btnBulbBackground.layer.cornerRadius = btnBulbBackground.bounds.size.width/2;
}

- (IBAction)tunableWhiteSliderChanged:(UISlider*)sender
{
    [intensitySlider setValue:sender.value animated:YES];
    if (!switchOnOff.isOn)
        [switchOnOff setOn:YES];
    if (_lightDevice) {
        //[_lightDevice setLevel:intensityLevel];
        
        //        [lightModelAPi setLevel:_lightDevice.deviceId level:[NSNumber numberWithFloat:sender.value] success:^( NSNumber *deviceId , UIColor *color , NSNumber *powerState , NSNumber *colorTemperature , NSNumber *supports){
        //
        //        }failure:^(NSError *error){
        //
        //        }];
        NSLog(@"slider value changed : %@",[NSNumber numberWithFloat:sender.value]);
        NSLog(@"Device ID when intensity slider moved:%@",_lightDevice.deviceId);
        
        if (self.gateWaySwitch.isOn) {
            NSString *url_str=[NSString stringWithFormat:@"http://52.36.91.149:8080/setintensity?devID=%@%@netID=0%@data=%d",_lightDevice.deviceId,@"&",@"&",[[NSString stringWithFormat:@"%f",sender.value] intValue]];
            
            NSURL *url = [NSURL URLWithString:url_str];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPShouldHandleCookies:NO];
            [NSURLConnection connectionWithRequest:request delegate:self];
        }
        else{
           [lightModelAPi setLevel:_lightDevice.deviceId level:[NSNumber numberWithFloat:sender.value] acknowledged:NO];
        }
        // Update power button from device
        // The device can turn on the power if the colour is set
        //[switchOnOff setOn:[_lightDevice getPower]];
        //[self updatePowerState:YES];
    }
    
}

- (IBAction)hueSliderChanged:(UISlider*)sender
{
    if (!switchOnOff.isOn)
        [switchOnOff setOn:YES];
    
    CGFloat hueintensityLevel = sender.value;
    //[_lightDevice setColorWithRed:red green:green blue:blue];
    float RGBValueOfSlider = hueintensityLevel*255;
    
    float redValue = RGBValueOfSlider;
    NSLog(@"redValue value is %f",RGBValueOfSlider);
    
    //float greenValue = hueintensityLevel;
    
    //float blueValue = 255-redValue;
    NSLog(@"blueValue value is %f",redValue-255);
    
    if (_lightDevice)
    {
        //[_lightDevice setColorWithRed:redValue green:greenValue blue:blueValue];
        //[switchOnOff setOn:[_lightDevice getPower]];
        //[self updatePowerState:YES];
        
        
        
        //        [lightModelAPi setColorTemperature:_lightDevice.deviceId temperature:[NSNumber numberWithInt:hueintensityLevel] duration:[NSNumber numberWithFloat:0.005] success:^(id deviceid,id color,id powerState, id colorTemperature,id supports){
        //
        //        }failure:^(NSError *error){
        //
        //        }];
        
        [lightModelAPi setRgb:_lightDevice.deviceId red:[NSNumber numberWithFloat:hueintensityLevel] green:[NSNumber numberWithFloat:hueintensityLevel] blue:[NSNumber numberWithFloat:hueintensityLevel] level:[NSNumber numberWithFloat:hueintensityLevel] duration:0 acknowledged:0];
        
        NSLog(@"HUe slider value changed : %@",[NSNumber numberWithFloat:hueintensityLevel]);
        NSLog(@"Device ID when hue slider moved:%@",_lightDevice.deviceId);
        
    }
}

- (IBAction)btnIntensityChange:(UIButton*)sender
{
    
    CGFloat hueintensityLevel = self.hueSlider.value;
    
    if(sender.tag == 1111)
    {
        hueintensityLevel = 255; //Cool
    }
    else if(sender.tag == 2222)
    {
        hueintensityLevel = 127; //Warm
    }
    else if(sender.tag == 3333)
    {
        hueintensityLevel = 0; //Morning
    }
    else if(sender.tag == 4444)
    {
        hueintensityLevel = 0.6; //Evening
    }
    else if(sender.tag == 5555)
    {
        hueintensityLevel = 0.8; //Noon
    }
    else if(sender.tag == 6666)
    {
        hueintensityLevel = 1.0; //Night
    }
    
    [self.hueSlider setValue:hueintensityLevel animated:YES];
    
    if (_lightDevice) {
        
        [lightModelAPi setRgb:_lightDevice.deviceId red:[NSNumber numberWithFloat:hueintensityLevel] green:[NSNumber numberWithFloat:hueintensityLevel] blue:[NSNumber numberWithFloat:hueintensityLevel] level:[NSNumber numberWithFloat:hueintensityLevel] duration:0 acknowledged:0];
        
    }
    
}

- (IBAction)powerSwitchChanged:(id)sender
{
    if (_lightDevice && switchOnOff.isOn) {
        //[_lightDevice setPower:switchOnOff.isOn];
        
        //[_lightDevice setPower:YES];
        [self updatePowerState:YES];
        [switchOnOff setOn:YES];
    }
    else if(_lightDevice && !switchOnOff.isOn){
        //[_lightDevice setPower:NO];
        [self updatePowerState:NO];
    }
}

-(void)updatePowerState:(BOOL)desiredState{
    NSNumber *powerState = [NSNumber numberWithBool:desiredState];
    
    //    [[PowerModelApi sharedInstance] setPowerState:_lightDevice.deviceId
    //                                            state:powerState
    //                                          success:^(NSNumber *deviceId, NSNumber *state) {
    //
    //                                              NSLog(@"DeviceId: %@ powerState: %@", deviceId, state);
    //                                              [switchOnOff setOn:[state boolValue]];
    //
    //                                          } failure:^(NSError *error) {
    //
    //                                              NSLog(@"Error: %@", error);
    //
    //                                          }];
    
    NSLog(@"Device id when updating the power state:%@",_lightDevice.deviceId);
    NSLog(@"POWER STATE:%@",powerState);
    
    if (self.gateWaySwitch.isOn) {
        NSString *url_str;
        
        if (self.switchOnOff.isOn) {
            url_str = [NSString stringWithFormat:@"http://52.36.91.149:8080/setonoff?devID=%@%@netID=0%@data=1",_lightDevice.deviceId,@"&",@"&"];
        }
        else{
            url_str = [NSString stringWithFormat:@"http://52.36.91.149:8080/setonoff?devID=%@%@netID=0%@data=0",_lightDevice.deviceId,@"&",@"&"];
        }
        
        NSURL *url = [NSURL URLWithString:url_str];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPShouldHandleCookies:NO];
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    }
    else{
        [[PowerModelApi sharedInstance] setPowerState:_lightDevice.deviceId state:powerState acknowledged:NO];
    }
    
    [switchOnOff setOn:[powerState boolValue]];
}

- (IBAction)bulbButtonClickedAction:(id)sender {
    if (_lightDevice && switchOnOff.isOn) {
        //[_lightDevice setPower:switchOnOff.isOn];
        
        //[_lightDevice setPower:YES];
        [self updatePowerState:YES];
        [btnBulbBackground setBackgroundColor:[UIColor whiteColor]];
    }
    else if(_lightDevice && !switchOnOff.isOn){
        //[_lightDevice setPower:NO];
        [self updatePowerState:NO];
        [btnBulbBackground setBackgroundColor:[UIColor darkGrayColor]];
    }
}

#pragma mark-power model api delegate

-(void)didGetPowerState:(NSNumber *)deviceId state:(NSNumber *)state meshRequestId:(NSNumber *)meshRequestId{
    
}

#pragma mark-light model api delegate
-(void)didGetLightState:(NSNumber *)deviceId red:(NSNumber *)red green:(NSNumber *)green blue:(NSNumber *)blue level:(NSNumber *)level powerState:(NSNumber *)powerState colorTemperature:(NSNumber *)colorTemperature supports:(NSNumber *)supports meshRequestId:(NSNumber *)meshRequestId{
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)tapGatewaySwitch:(id)sender {
    
    
}
@end