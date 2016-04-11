//
//  CSRTimerControlViewController.h
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 13/03/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSRTimerControlViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewTimer;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewFanSpeed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSetTimer;
- (IBAction)clickBtnSetTimer:(id)sender;
@end
