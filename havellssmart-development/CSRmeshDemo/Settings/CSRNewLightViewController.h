//
//  CSRNewLightViewController.h
//  CSRmeshDemo
//
//  Created by Rajesh Muddana on 27/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRmeshDevice.h"
#import "CSRDeviceEntity.h"
#import "CRColorPicker.h"

@interface CSRNewLightViewController : UIViewController<CRColorPickerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISwitch *switchOnOff;
@property (weak, nonatomic) IBOutlet UILabel *lblThemes;
@property (weak, nonatomic) IBOutlet UIButton *btnValentine;
@property (weak, nonatomic) IBOutlet UIButton *btnSunshine;
@property (weak, nonatomic) IBOutlet UIButton *btnCalm;
@property (weak, nonatomic) IBOutlet UIButton *btnCountrySide;
@property (weak, nonatomic) IBOutlet UIButton *btnDramatic;
@property (weak, nonatomic) IBOutlet UIButton *btnExcite;
@property (weak, nonatomic) IBOutlet UILabel *lblColor;
@property (weak, nonatomic) IBOutlet UIButton *btnColor1;
@property (weak, nonatomic) IBOutlet UIButton *btnColor2;
@property (weak, nonatomic) IBOutlet UIButton *btnColor3;
@property (weak, nonatomic) IBOutlet UIButton *btnColor4;
@property (weak, nonatomic) IBOutlet UIButton *btnColor5;
@property (weak, nonatomic) IBOutlet UIButton *btnColor6;
@property (weak, nonatomic) IBOutlet UIButton *btnColor7;
@property (weak, nonatomic) IBOutlet UIButton *btnColor8;
@property (weak, nonatomic) IBOutlet UIButton *btnColor9;
@property (weak, nonatomic) IBOutlet UIButton *btnColor10;
//@property (weak, nonatomic) IBOutlet UIButton *btnRGBColors;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectedColor;
@property (weak, nonatomic) IBOutlet UIButton *btnBulbBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblIntensity;
@property (weak, nonatomic) IBOutlet UISlider *intensitySlider;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBulb;
@property (weak, nonatomic) IBOutlet CRColorPicker *ColorPickerView;

@property (nonatomic) CSRmeshDevice *lightDevice;
@property (nonatomic,strong) CSRDeviceEntity *deviceEntity;

- (IBAction)themesButtonActionMethods:(id)sender;











@end
