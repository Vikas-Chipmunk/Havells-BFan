//
//  GatewayViewController.h
//  CSRmeshDemo
//
//  Created by Budim on 2/9/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRConstants.h"
#import "CSRDatabaseManager.h"
#import "CSRAppStateManager.h"


@interface GatewayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *AwayOutletButton;
@property (weak, nonatomic) IBOutlet UIButton *ArrivingOutletButton;
- (IBAction)AwayActionButton:(id)sender;
- (IBAction)ArrivingActionButton:(id)sender;

@end
