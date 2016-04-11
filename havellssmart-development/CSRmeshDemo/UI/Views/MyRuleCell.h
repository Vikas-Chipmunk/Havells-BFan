//
//  MyRuleCell.h
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 27/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyRuleCellDelegate <NSObject>

@optional
-(void)gotoMyRuleView:(NSIndexPath*)indexPath;
@end


@interface MyRuleCell : UITableViewCell<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icnBulb;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UISlider *viewSlider;
@property (weak, nonatomic) IBOutlet UISwitch *viewSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnTruFalse;

@property (weak, nonatomic) IBOutlet UIImageView *imgDropDown;
@property (weak, nonatomic) IBOutlet UIView *viewParent;

@property (weak,nonatomic) NSIndexPath *mIndexPath;
- (IBAction)sliderValueChanges:(id)sender;

- (IBAction)switchButtonClicked:(id)sender;

- (IBAction)clickBtnTruFalse:(id)sender;

@property(weak,nonatomic) id<MyRuleCellDelegate> myRuleCellDelegate;
@end
