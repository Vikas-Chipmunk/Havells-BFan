//
//  CSRNewLightViewController.m
//  CSRmeshDemo
//
//  Created by Rajesh Muddana on 27/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "CSRNewLightViewController.h"
#import "CSRDatabaseManager.h"
#import "CSRmeshStyleKit.h"
#import "CSRUtilities.h"
#import "CSRConstants.h"
#import "CSRDevicesManager.h"
#import "Favourite.h"
#import "CSRDeviceEntity.h"
#import "CSRDatabaseManager.h"
#import "UIView+Toast.h"

@interface CSRNewLightViewController ()

{
    CGFloat intensityLevel;
    UIColor *chosenColor;
    CGPoint lastPosition;
}

@end

@implementation CSRNewLightViewController
@synthesize scrollView,topView,switchOnOff,lblThemes,btnValentine,btnSunshine,btnCalm,btnCountrySide,btnDramatic,btnExcite,lblColor,btnColor1,btnColor2,btnColor3,btnColor4,btnColor5,btnColor6,btnColor7,btnColor8,btnColor9,btnColor10,/*btnRGBColors,*/btnSelectedColor,btnBulbBackground,lblIntensity,intensitySlider,imgViewBulb, ColorPickerView;

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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapped:)];
    
    [self.btnColor1 addGestureRecognizer:tapGestureRecognizer1];
    [self.btnColor2 addGestureRecognizer:tapGestureRecognizer2];
    [self.btnColor3 addGestureRecognizer:tapGestureRecognizer3];
    [self.btnColor4 addGestureRecognizer:tapGestureRecognizer4];
    [self.btnColor5 addGestureRecognizer:tapGestureRecognizer5];
    [self.btnColor6 addGestureRecognizer:tapGestureRecognizer6];
    [self.btnColor7 addGestureRecognizer:tapGestureRecognizer7];
    [self.btnColor8 addGestureRecognizer:tapGestureRecognizer8];
    [self.btnColor9 addGestureRecognizer:tapGestureRecognizer9];
    [self.btnColor10 addGestureRecognizer:tapGestureRecognizer10];
    
    
    [intensitySlider addGestureRecognizer:tapGestureRecognizer];
    
    [ColorPickerView setDelegate:self];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //Get current device power status
    [switchOnOff setOn:[_lightDevice getPower]];
    
    //Get current device intesinty level
    [intensitySlider setValue:_lightDevice.getLevel animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadnewUI
{
    btnValentine.layer.cornerRadius = 10; // this value vary as per your desire
    btnValentine.clipsToBounds = YES;
    btnSunshine.layer.cornerRadius = 10;
    btnSunshine.clipsToBounds = YES;
    btnCalm.layer.cornerRadius = 10;
    btnCalm.clipsToBounds = YES;
    btnCountrySide.layer.cornerRadius = 10;
    btnCountrySide.clipsToBounds = YES;
    btnDramatic.layer.cornerRadius = 10;
    btnDramatic.clipsToBounds = YES;
    btnExcite.layer.cornerRadius = 10;
    btnExcite.clipsToBounds = YES;
    btnColor1.layer.cornerRadius = btnColor1.bounds.size.width/2;
    btnColor2.layer.cornerRadius = btnColor2.bounds.size.width/2;
    btnColor3.layer.cornerRadius = btnColor3.bounds.size.width/2;
    btnColor4.layer.cornerRadius = btnColor4.bounds.size.width/2;
    btnColor5.layer.cornerRadius = btnColor5.bounds.size.width/2;
    btnColor6.layer.cornerRadius = btnColor6.bounds.size.width/2;
    btnColor7.layer.cornerRadius = btnColor7.bounds.size.width/2;
    btnColor8.layer.cornerRadius = btnColor8.bounds.size.width/2;
    btnColor9.layer.cornerRadius = btnColor9.bounds.size.width/2;
    btnColor10.layer.cornerRadius = btnColor10.bounds.size.width/2;
    //btnRGBColors.layer.cornerRadius = 10;
    //btnRGBColors.clipsToBounds = YES;
    btnSelectedColor.layer.cornerRadius = btnSelectedColor.bounds.size.width/2;
    btnBulbBackground.layer.cornerRadius = btnBulbBackground.bounds.size.width/2;
    
    self.ColorPickerView.layer.cornerRadius = 30;
    self.ColorPickerView.clipsToBounds = YES;
    
    
}

- (IBAction)intensitySliderDragged:(id)sender
{
    if (!switchOnOff.isOn)
        [switchOnOff setOn:YES];
    BOOL isDragAllowed = NO;
    
    if ([CSRMeshUserManager sharedInstance].bearerType == CSRBearerType_Bluetooth) {
        
        isDragAllowed = YES;
        
    }
    
    if (!isDragAllowed) {
        
        if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
            
            isDragAllowed = YES;
            
        } else if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
            
            isDragAllowed = YES;
            
        }
        
    }
    
    if (isDragAllowed) {
        
        intensityLevel = intensitySlider.value;
        NSLog(@"Slider value before multiplier:%f",intensityLevel);
        intensityLevel=(intensityLevel*0.7);
        NSLog(@"Slider value after 0.7 multiplier:%f",intensityLevel);
        
        if (_lightDevice) {
            [_lightDevice setLevel:intensityLevel];
            
            // Update power button from device
            // The device can turn on the power if the colour is set
            [switchOnOff setOn:[_lightDevice getPower]];
        }
        
    }
    
}

- (IBAction)intensitySliderTapped:(id)sender
{
    UITapGestureRecognizer *recogniser = sender;
    
    
    //    CGPoint touchPoint = [recogniser locationInView:intensitySlider.viewForBaselineLayout];
    //
    //    intensityLevel = touchPoint.x / intensitySlider.frame.size.width;
    //
    //    [intensitySlider setValue:intensityLevel animated:YES];
    //
    //    if (_lightDevice) {
    //        [_lightDevice setLevel:intensityLevel];
    //
    //        // Update power button from device
    //        // The device can turn on the power if the colour is set
    //        [switchOnOff setOn:[_lightDevice getPower]];
    //    }
}

-(IBAction)handleTapFrom:(id)sender{
    CGPoint touchPoint = [sender locationInView:intensitySlider.viewForBaselineLayout];
    
    intensityLevel = touchPoint.x / intensitySlider.frame.size.width;
    
    [intensitySlider setValue:intensityLevel animated:YES];
    
    if (_lightDevice) {
        [_lightDevice setLevel:intensityLevel];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [switchOnOff setOn:[_lightDevice getPower]];
    }
    
}

-(IBAction)colorTapped:(id)sender{
    UIColor *pixel;
    if ([sender view]==self.btnColor1) {
        pixel=self.btnColor1.backgroundColor;
    }
    else if ([sender view]==self.btnColor2){
        pixel=self.btnColor2.backgroundColor;
    }
    else if ([sender view]==self.btnColor3){
        pixel=self.btnColor3.backgroundColor;
    }
    else if ([sender view]==self.btnColor4){
        pixel=self.btnColor4.backgroundColor;
    }
    else if ([sender view]==self.btnColor5){
        pixel=self.btnColor5.backgroundColor;
    }
    else if ([sender view]==self.btnColor6){
        pixel=self.btnColor6.backgroundColor;
    }
    else if ([sender view]==self.btnColor7){
        pixel=self.btnColor7.backgroundColor;
    }
    else if ([sender view]==self.btnColor8){
        pixel=self.btnColor8.backgroundColor;
    }
    else if ([sender view]==self.btnColor9){
        pixel=self.btnColor9.backgroundColor;
    }
    else if ([sender view]==self.btnColor10){
        pixel=self.btnColor10.backgroundColor;
    }
    
    CGPoint touchPoint = [sender locationInView:[sender view].viewForBaselineLayout];
    
    float frameWidth = [sender view].viewForBaselineLayout.frame.size.width;
    float frameHeight = [sender view].viewForBaselineLayout.frame.size.height;
    
    //pixel = [CSRUtilities colorFromImageAtPoint:&touchPoint frameWidth:frameWidth frameHeight:frameHeight];
    
    [self.btnBulbBackground setBackgroundColor:pixel];
    
    CGFloat red, green, blue, alpha;
    if ([pixel getRed:&red green:&green blue:&blue alpha:&alpha]) {
        //&& !(red<0.4 && green<0.4 && blue<0.4)
        
        // Send Color to selected light
        if (_lightDevice) {
            [_lightDevice setColorWithRed:red green:green blue:blue];
            //[_lightDevice setColorWithRed:1.0 green:0.0 blue:0.90];
        }
        
        chosenColor = pixel;
        
        // update position of inidicator
        touchPoint.x += [sender view].viewForBaselineLayout.frame.origin.x;
        touchPoint.y += [sender view].viewForBaselineLayout.frame.origin.y;
        
        //[self updateColorIndicatorPosition:touchPoint];
        
        // Update the device's copy of the color position
        [_lightDevice setColorPosition:[NSValue valueWithCGPoint:touchPoint]];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [switchOnOff setOn:[_lightDevice getPower]];
    }
    
}

#pragma mark - Color indicator update

- (void)updateColorIndicatorPosition:(CGPoint)position
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [btnBulbBackground setCenter:position];
    });
    
    [btnBulbBackground setCenter:position];
    lastPosition = position;
}

- (IBAction)powerSwitchChanged:(id)sender
{
    if (_lightDevice) {
        [_lightDevice setPower:switchOnOff.isOn];
    }
}

- (IBAction)themesButtonActionMethods:(id)sender
{
    
    UIButton *tappedButton = (UIButton *)sender;
    
      UIColor *pixel;
    
    switch (tappedButton.tag)
    {
        case 1:
            //cool//valentine
            
            pixel=[UIColor colorWithRed:140.0/255.0 green:0.0/255.0 blue:26.0/255.0 alpha:1.0];
            
            break;
        case 2:
            //warm//sunshine
            pixel=[UIColor colorWithRed:255.0/255.0 green:167.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 3:
            //morning//calm
            pixel=[UIColor colorWithRed:173.0/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:1.0];

            break;
        case 4:
            //evening/countryside
            pixel=[UIColor colorWithRed:0.0/255.0 green:100.0/255.0 blue:0.0/255.0 alpha:1.0];

            break;
        case 5:
            //noon//dramatic
            pixel=[UIColor colorWithRed:128.0/255.0 green:0.0/255.0 blue:128.0/255.0 alpha:1.0];

            break;
        case 6:
            //custom//excite
            pixel=[UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0];

            break;
            
        default:
            break;
    }
    
    CGFloat red, green, blue, alpha;
    if ([pixel getRed:&red green:&green blue:&blue alpha:&alpha]) {
        //&& !(red<0.4 && green<0.4 && blue<0.4)
        
        // Send Color to selected light
        if (_lightDevice) {
            [_lightDevice setColorWithRed:red green:green blue:blue];
            //[_lightDevice setColorWithRed:1.0 green:0.0 blue:0.90];
        }
        
        chosenColor = pixel;
        
        //[self updateColorIndicatorPosition:touchPoint];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [switchOnOff setOn:[_lightDevice getPower]];
    }

}

#pragma mark - CRColorPicker delegate

//Action when user is choosing color
-(void)colorIsChanging:(UIColor *)color{
    CGFloat red, green, blue, alpha;
    if ([color getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        if (_lightDevice)
            [_lightDevice setColorWithRed:red green:green blue:blue];
    }
    [btnSelectedColor setBackgroundColor:color];
    [btnBulbBackground setBackgroundColor:color];
}

//Action when user finished to select a color
-(void)colorSelected:(UIColor *)color{
    CGFloat red, green, blue, alpha;
    if ([color getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        if (_lightDevice)
            [_lightDevice setColorWithRed:red green:green blue:blue];
    }
    [btnSelectedColor setBackgroundColor:color];
    [btnBulbBackground setBackgroundColor:color];
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
