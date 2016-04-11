//
//  AddRulesViewController.h
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 29/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CSRmeshDevice.h"
@protocol AddRulesViewDelegate <NSObject>

@optional
-(void)gotoMyRulesView:(CSRmeshDevice *)meshDevice andRule:(NSString*)rule;
@end

@interface AddRulesViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *viewContainingItems;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnLight;
@property (weak, nonatomic) IBOutlet UIButton *btnMotionOptions;

@property (weak,nonatomic) NSString *selectedSensor;


- (IBAction)clickBtnCancel:(id)sender;
- (IBAction)clickBtnOk:(id)sender;
- (IBAction)clickBtnLight:(id)sender;
- (IBAction)clickBtnMotionOptions:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblViewLightOptions;

@property (weak, nonatomic) IBOutlet UITableView *tblViewMotionOptions;


@property(weak,nonatomic) id<AddRulesViewDelegate> addRuleViewDelegate;

- (IBAction)onTappGestureDetected:(UITapGestureRecognizer *)sender;

@end
