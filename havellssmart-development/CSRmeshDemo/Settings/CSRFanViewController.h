//
//  CSRFanViewController.h
//  CSRmeshDemo
//
//  Created by Vikas M K on 23/02/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRmeshDevice.h"
#import "CSRDeviceEntity.h"
#import "EFCircularSlider.h"

@interface CSRFanViewController : UIViewController<DelegateForFanSpeedButtonTap, UITableViewDataSource, UITableViewDelegate>
{
    EFCircularSlider* minuteSlider;
    EFCircularSlider* hourSlider;
    UISwitch *fanPowerOnSwitch;
    UISwitch *lightPowerOnSwitch;
    UILabel *customLabel;
    BOOL isFanPowerOn;
}

@property (weak, nonatomic) IBOutlet UITableView *fanControlTableView;
@property (weak, nonatomic) IBOutlet UIView *fanControllView;
@property (weak, nonatomic) IBOutlet UIView *fanControllBaggroundView;
@property (weak, nonatomic) IBOutlet UIImageView *innerNobeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *outterSpeedImageview;
@property (nonatomic) CSRmeshDevice *lightDevice;
@property (nonatomic,strong) CSRDeviceEntity *deviceEntity;

@property (nonatomic,strong) NSMutableDictionary *timerValueDict;

@end
