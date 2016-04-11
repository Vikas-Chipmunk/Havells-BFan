//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//


#import "CSRLightViewController.h"
#import "CSRmeshStyleKit.h"
#import "CSRUtilities.h"
#import "CSRConstants.h"
#import "CSRDevicesManager.h"
#import "Favourite.h"
#import "CSRDeviceEntity.h"
#import "CSRDatabaseManager.h"
#import "UIView+Toast.h"
@interface CSRLightViewController ()
{
    CGFloat intensityLevel;
    CGPoint lastPosition;
    UIColor *chosenColor;
    CSRDatabaseManager *dataBaseMng;
}

@property (weak, nonatomic) IBOutlet UIView *viewFavourites;
@end

@implementation CSRLightViewController
@synthesize deviceEntity;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    dataBaseMng = [CSRDatabaseManager sharedInstance];

    _selectedArea = [[CSRDevicesManager sharedInstance] selectedArea];
    _lightDevice = [[CSRDevicesManager sharedInstance] selectedDevice];

    
    //Adjust navigation controller appearance
    self.showNavMenuButton = NO;
    self.showNavSearchButton = NO;
    
    [super adjustNavigationControllerAppearance];
    
    //Set navigation buttons
    _backButton = [[UIBarButtonItem alloc] init];
    _backButton.image = [CSRmeshStyleKit imageOfBack_arrow];
    _backButton.action = @selector(back:);
    _backButton.target = self;
    //Add accessibility for automation
    _backButton.isAccessibilityElement = YES;
    _backButton.accessibilityLabel = @"back";
    _backButton.accessibilityTraits = UIAccessibilityTraitImage;

    
    [super addCustomBackButtonItem:_backButton];
    
    //Set initial values
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.numberOfTouchesRequired = 1;
    
    intensityLevel = 1.0;
    chosenColor = [UIColor whiteColor];
    lastPosition.x = 0;
    lastPosition.y = 0;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star"] style:UIBarButtonItemStylePlain target:self action:@selector(btnFavorite_TouchUpInside:)];
    
    [self showFavouritesOnScreen];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
//    _selectedArea = [[CSRDevicesManager sharedInstance] selectedArea];
//    _lightDevice = [[CSRDevicesManager sharedInstance] selectedDevice];
    
    //Set item titles
    if (_lightDevice) {
        self.title = _lightDevice.name;
    } else if (_selectedArea){
        self.title = _selectedArea.areaName;
    } else {
        //self.title = @"CSRmesh";
        self.title = _lightDevice.name;
    }
    
    //Get current device power status
    [_powerSwitch setOn:[_lightDevice getPower]];
    
    //Get current device color position/value
    if ([_lightDevice colorPosition] != nil) {
        
        CGPoint position = [_lightDevice.colorPosition CGPointValue];
        [self updateColorIndicatorPosition:position];
        
    }
    
    //Get current device intesinty level
    [_intensitySlider setValue:_lightDevice.getLevel animated:YES];
}

-(void)showFavouritesOnScreen
{
    NSArray *arrFav = [[deviceEntity.relationshipToFavourites allObjects] mutableCopy];
    
    int x=0;
    int buttonWidth = 70;
    int buttonHeight = 70;
    int space = 5;

    for (Favourite *obj in arrFav) {
        
        x += buttonWidth + space;
        
        UIButton *btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFav.frame = CGRectMake(x, 0, buttonWidth, buttonHeight);
        [btnFav setTitle:obj.name forState:UIControlStateNormal];
        btnFav.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:89.0/255.0 blue:64.0/255.0 alpha:1.0];
        [btnFav addTarget:self action:@selector(btnFavoriteColor_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        btnFav.tag = [arrFav indexOfObject:obj];
        btnFav.layer.cornerRadius = btnFav.frame.size.width/2;
        btnFav.layer.masksToBounds = YES;
        btnFav.titleLabel.textColor = [UIColor whiteColor];
        [self.viewFavourites addSubview:btnFav];
        
    }
    
}

-(void)btnFavoriteColor_TouchUpInside:(UIButton*)sender
{
    NSArray *arrFav = [[deviceEntity.relationshipToFavourites allObjects] mutableCopy];

    Favourite *fav = [arrFav objectAtIndex:sender.tag];
    
    float frameWidth = _colorWheel.viewForBaselineLayout.frame.size.width;
    float frameHeight = _colorWheel.viewForBaselineLayout.frame.size.height;
    
    CGPoint touch = CGPointMake([fav.x floatValue], [fav.y floatValue]);
    
    UIColor *pixel = [CSRUtilities colorFromImageAtPoint:&touch frameWidth:frameWidth frameHeight:frameHeight];
    
    CGFloat red, green, blue, alpha;
    if ([pixel getRed:&red green:&green blue:&blue alpha:&alpha] && !(red<0.4 && green<0.4 && blue<0.4)) {
        
        // Send Color to selected light
        if (_lightDevice) {
            [_lightDevice setColorWithRed:red green:green blue:blue];
        }
        
        chosenColor = pixel;
        
        // update position of inidicator
        touch.x += _colorWheel.frame.origin.x;
        touch.y += _colorWheel.frame.origin.y;
        
        [self updateColorIndicatorPosition:touch];
        
        // Update the device's copy of the color position
        [_lightDevice setColorPosition:[NSValue valueWithCGPoint:touch]];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [_powerSwitch setOn:[_lightDevice getPower]];
        
        [self.intensitySlider setValue:[fav.intensity floatValue] animated:YES];
        
    }

    
}
- (IBAction)addFav:(UIButton *)sender {
    NSArray *arrFav = [[deviceEntity.relationshipToFavourites allObjects] mutableCopy];
    if ([arrFav count]>=8) {
        [self.view makeToast:@"Custom button limit reached" duration:3 position:CSToastPositionTop];
        return;
    }
    NSString *strMsg = [NSString stringWithFormat:@"Create new Favourite."];
    if ([UIAlertController class])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:strMsg];
        [title addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:14]
                      range:NSMakeRange(0, [strMsg length])];
        [alertController setValue:title forKey:@"attributedTitle"];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *K2TextField)
         {
             K2TextField.placeholder = @"Favourite Name(Ex:Relax,Bright...)";
         }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancel];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSString *text = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
            if([text length])
                [self saveFavWithName:text];
            else
                [self.view makeToast:@"Favourite name shouldn't be empty" duration:3 position:CSToastPositionTop title:nil];
            
        }];
        [alertController addAction:ok];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag=1122;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textfield =  [alert textFieldAtIndex:0];
        textfield.placeholder = @"Favourite Name(Ex:Relax,Bright...)";
        [alert show];
        
    }
}

-(void)btnFavorite_TouchUpInside:(id)sender
{
//    NSString *strMsg = [NSString stringWithFormat:@"Create new Favourite."];
//    if ([UIAlertController class])
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
//        
//        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:strMsg];
//        [title addAttribute:NSFontAttributeName
//                      value:[UIFont systemFontOfSize:14]
//                      range:NSMakeRange(0, [strMsg length])];
//        [alertController setValue:title forKey:@"attributedTitle"];
//        
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *K2TextField)
//         {
//             K2TextField.placeholder = @"Favourite Name(Ex:Relax,Bright...)";
//         }];
//        
//        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:cancel];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//            NSString *text = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
//            if([text length])
//                [self saveFavWithName:text];
//            else
//                [self.view makeToast:@"Favourite name shouldn't be empty" duration:3 position:CSToastPositionTop title:nil];
//            
//        }];
//        [alertController addAction:ok];
//        
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//    }
//    else
//    {
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        alert.tag=1122;
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        UITextField *textfield =  [alert textFieldAtIndex:0];
//        textfield.placeholder = @"Favourite Name(Ex:Relax,Bright...)";
//        [alert show];
//        
//    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1122&&buttonIndex==1)
    {
        UITextField *textfield =  [alertView textFieldAtIndex:0];
        if([textfield.text length])
        {
            [self saveFavWithName:textfield.text];
        }
        else
        {
            [self.view makeToast:@"Favourite name shouldn't be empty" duration:3 position:CSToastPositionTop title:nil];
        }
        
    }
}

-(void)saveFavWithName:(NSString*)strFavName
{
    float xPosition = lastPosition.x;
    float yPosition = lastPosition.y;
    
    float intensity = intensityLevel;
    
    CGFloat red, green, blue, alpha;
    if ([chosenColor getRed:&red green:&green blue:&blue alpha:&alpha] && !(red<0.4 && green<0.4 && blue<0.4)) {
        
        // Send Color to selected light
    }
    
    Favourite *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Favourite" inManagedObjectContext:dataBaseMng.managedObjectContext];
    obj.x = [NSNumber numberWithFloat:xPosition];
    obj.y = [NSNumber numberWithFloat:yPosition];
    obj.intensity = [NSNumber numberWithFloat:intensity];
    
    obj.red = [NSNumber numberWithFloat:red];
    obj.green = [NSNumber numberWithFloat:green];
    obj.blue = [NSNumber numberWithFloat:blue];
    obj.alpha = [NSNumber numberWithFloat:alpha];
    obj.name = strFavName;
    
    [deviceEntity addRelationshipToFavouritesObject:obj];
    
    [dataBaseMng.managedObjectContext save:nil];
    
    [self showFavouritesOnScreen];
}

- (void)dealloc
{
    self.view = nil;
}

#pragma mark - Actions

- (IBAction)dragColor:(id)sender
{
    
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
    
        UIPanGestureRecognizer *recogniser = sender;
        CGPoint touchPoint = [recogniser locationInView:_colorWheel.viewForBaselineLayout];
        
        float frameWidth = _colorWheel.viewForBaselineLayout.frame.size.width;
        float frameHeight = _colorWheel.viewForBaselineLayout.frame.size.height;
        
        if (touchPoint.x > frameWidth) {
            
            touchPoint.x = frameWidth;
            
        } else if (touchPoint.x < 0) {
            
            touchPoint.x = 0;
            
        }
        
        if (touchPoint.y > frameHeight) {
            
            touchPoint.y = frameHeight;
            
        } else if (touchPoint.y < 0) {
            
            touchPoint.y = 0;
            
        }
        
        
        UIColor *pixel = [CSRUtilities colorFromImageAtPoint:&touchPoint frameWidth:frameWidth frameHeight:frameHeight];
        
        CGFloat red, green, blue, alpha;
        if ([pixel getRed:&red green:&green blue:&blue alpha:&alpha] && !(red<0.4 && green<0.4 && blue<0.4)) {
            
            // Send Color to selected light
            if (_lightDevice) {
                
                [_lightDevice setColorWithRed:red green:green blue:blue];
                
            }
            
            
            chosenColor = pixel;
            
            // update position of inidicator
            touchPoint.x += _colorWheel.frame.origin.x;
            touchPoint.y += _colorWheel.frame.origin.y;
            [self updateColorIndicatorPosition:touchPoint];
            
            // Update the device's copy of the color position
            [_lightDevice setColorPosition:[NSValue valueWithCGPoint:touchPoint]];
            
            // Update power button from device
            // The device can turn on the power if the colour is set
            [_powerSwitch setOn:[_lightDevice getPower]];
        }
        
    }
    
}

- (IBAction)tapColor:(id)sender
{
    UITapGestureRecognizer *recogniser = sender;
    CGPoint touchPoint = [recogniser locationInView:_colorWheel.viewForBaselineLayout];
    
    float frameWidth = _colorWheel.viewForBaselineLayout.frame.size.width;
    float frameHeight = _colorWheel.viewForBaselineLayout.frame.size.height;
    
    UIColor *pixel = [CSRUtilities colorFromImageAtPoint:&touchPoint frameWidth:frameWidth frameHeight:frameHeight];
    
    CGFloat red, green, blue, alpha;
    if ([pixel getRed:&red green:&green blue:&blue alpha:&alpha] && !(red<0.4 && green<0.4 && blue<0.4)) {
        
        // Send Color to selected light
        if (_lightDevice) {
            [_lightDevice setColorWithRed:red green:green blue:blue];
        }
        
        chosenColor = pixel;
        
        // update position of inidicator
        touchPoint.x += _colorWheel.frame.origin.x;
        touchPoint.y += _colorWheel.frame.origin.y;
        
        [self updateColorIndicatorPosition:touchPoint];
        
        // Update the device's copy of the color position
        [_lightDevice setColorPosition:[NSValue valueWithCGPoint:touchPoint]];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [_powerSwitch setOn:[_lightDevice getPower]];
    }
}

- (IBAction)coolButton:(id)sender {
//    intensitySlider.value=0;
//    intensityLevel=0;
//    if (selectedDevice) {
//        [selectedDevice setLevel:intensityLevel];
//        
//        // Update power button from device
//        // The device can turn on the power if the colour is set
//        [powerButton setOn:[selectedDevice getPower]];
//    }
    intensityLevel = 0;
    _intensitySlider.value=0;
    
    if (_lightDevice) {
        [_lightDevice setLevel:intensityLevel];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [_powerSwitch setOn:[_lightDevice getPower]];
    }

}
- (IBAction)semicoolbutton:(UIButton *)sender {
//    intensitySlider.value=.34;
//    intensityLevel=.34;
//    if (selectedDevice) {
//        [selectedDevice setLevel:intensityLevel];
//        
//        // Update power button from device
//        // The device can turn on the power if the colour is set
//        [powerButton setOn:[selectedDevice getPower]];
//    }
    intensityLevel = .34;
    _intensitySlider.value=.34;
    
    if (_lightDevice) {
        [_lightDevice setLevel:intensityLevel];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [_powerSwitch setOn:[_lightDevice getPower]];
    }

}

- (IBAction)midday:(UIButton *)sender {
//    _intensitySlider.value=.68;
//    intensityLevel=.68;
//    if (selectedDevice) {
//        [selectedDevice setLevel:intensityLevel];
//        
//        // Update power button from device
//        // The device can turn on the power if the colour is set
//        [powerButton setOn:[selectedDevice getPower]];
//    }
    intensityLevel = .68;
    _intensitySlider.value=.68;
    
    if (_lightDevice) {
        [_lightDevice setLevel:intensityLevel];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [_powerSwitch setOn:[_lightDevice getPower]];
    }

}
//============================================================================
- (IBAction)warmButton:(UIButton *)sender {
//    _intensitySlider.value=1;
//    intensityLevel=1;
//    if (selectedDevice) {
//        [selectedDevice setLevel:intensityLevel];
//        
//        // Update power button from device
//        // The device can turn on the power if the colour is set
//        [powerButton setOn:[selectedDevice getPower]];
//    }
    intensityLevel = 1;
    _intensitySlider.value=1;
    
    if (_lightDevice) {
        [_lightDevice setLevel:intensityLevel];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [_powerSwitch setOn:[_lightDevice getPower]];
    }

}


- (IBAction)intensitySliderDragged:(id)sender
{
    
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
    
        intensityLevel = _intensitySlider.value;
        
        if (_lightDevice) {
            [_lightDevice setLevel:intensityLevel];
            
            // Update power button from device
            // The device can turn on the power if the colour is set
            [_powerSwitch setOn:[_lightDevice getPower]];
        }
        
    }
    
}

- (IBAction)intensitySliderTapped:(id)sender
{
    UITapGestureRecognizer *recogniser = sender;
    CGPoint touchPoint = [recogniser locationInView:_intensitySlider.viewForBaselineLayout];
    
    intensityLevel = touchPoint.x / _intensitySlider.frame.size.width;
    
    [_intensitySlider setValue:intensityLevel animated:YES];
    
    if (_lightDevice) {
        [_lightDevice setLevel:intensityLevel];
        
        // Update power button from device
        // The device can turn on the power if the colour is set
        [_powerSwitch setOn:[_lightDevice getPower]];
    }
}

- (IBAction)powerSwitchChanged:(id)sender
{
    if (_lightDevice) {
        [_lightDevice setPower:_powerSwitch.isOn];
    }
}

#pragma mark - Color indicator update

- (void)updateColorIndicatorPosition:(CGPoint)position
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_colorIndicator setCenter:position];
    });
    
    [_colorIndicator setCenter:position];
    lastPosition = position;
}

#pragma mark - Pseudo Navigation Bar item menthods

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
