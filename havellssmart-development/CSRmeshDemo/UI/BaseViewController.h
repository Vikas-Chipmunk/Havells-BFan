//
//  BaseViewController1.h
//  Nacht
//
//  Created by Bimal Sharma on 31/08/15.
//  Copyright (c) 2015 Bimal Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
@interface BaseViewController : UIViewController


@property (strong, nonatomic) UIButton *btnBack;

@property (strong,nonatomic) UIButton *btnSearch;

-(void)backToPrevious;

-(UIViewController*)getViewControllerForIdentifier:(NSString*)identifier;

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;

-(NSString*)getUserPref:(NSString*)key;

-(void)saveUserPref:(NSString*)pref andKey:(NSString*)key;

-(void)showAlert:(NSString *)title message:(NSString*)message  Delegate:(id)sender;

-(void)showAlertWithMessage:(NSString*)msg;
@end
