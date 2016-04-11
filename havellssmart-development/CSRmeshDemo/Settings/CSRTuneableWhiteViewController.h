//
//  CSRTuneableWhiteViewController.h
//  CSRmeshDemo
//
//  Created by Vikas M K on 07/02/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRmeshDevice.h"
#import "CSRDeviceEntity.h"

@interface CSRTuneableWhiteViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISwitch *switchOnOff;
@property (weak, nonatomic) IBOutlet UILabel *lblThemes;
@property (weak, nonatomic) IBOutlet UIButton *btnRelaxed;
@property (weak, nonatomic) IBOutlet UIButton *btnConcentrate;
@property (weak, nonatomic) IBOutlet UIButton *btnGrind;
@property (weak, nonatomic) IBOutlet UIButton *btnEvening;
@property (weak, nonatomic) IBOutlet UIButton *btnNoon;
@property (weak, nonatomic) IBOutlet UIButton *btnNight;
@property (weak, nonatomic) IBOutlet UIButton *btnBulbBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblIntensity;
@property (weak, nonatomic) IBOutlet UISlider *intensitySlider;
@property (weak, nonatomic) IBOutlet UISlider *hueSlider;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBulb;

@property (nonatomic) CSRmeshDevice *lightDevice;
@property (nonatomic,strong) CSRDeviceEntity *deviceEntity;

@property (weak, nonatomic) IBOutlet UISwitch *gateWaySwitch;
- (IBAction)tapGatewaySwitch:(id)sender;
@end