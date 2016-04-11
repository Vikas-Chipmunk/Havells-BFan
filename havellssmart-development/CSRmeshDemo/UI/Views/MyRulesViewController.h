//
//  MyRulesViewController.h
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 27/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRMainViewController.h"
#import "CSRMeshDevice.h"
@interface MyRulesViewController : CSRMainViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnCentre;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
- (IBAction)clickBtnLeft:(id)sender;
- (IBAction)clickBtnCentre:(id)sender;
- (IBAction)clickBtnRight:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveRule;
- (IBAction)clickBtnRemoveRule:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRule;
- (IBAction)clickBtnAddRule:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewMotionCentre;
@property (weak, nonatomic) IBOutlet UITableView *tblViewMyRules;

@property (weak,nonatomic) CSRmeshDevice *csrMeshDevice;

@end
