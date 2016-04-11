//
//  ViewController.m
//  HavellsSmart
//
//  Created by SudheerPalchuri on 04/01/16.
//  Copyright © 2016 Chipmonk. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtFldUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtFldPassword;
@property (weak, nonatomic) IBOutlet UISwitch *switchKeepMeLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *viewUsername;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLogo;
- (IBAction)btnLogin_TouchUpInside:(id)sender;
- (IBAction)btnRegistration_TouchUpInside:(id)sender;
- (IBAction)btnForgotPassword_TouchUpInside:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self designingUI];
    [self registerForKeyboardNotifications];
    
    UIView *viewLaunch = (UIView*)[appDelegate.window viewWithTag:143225];
    [viewLaunch removeFromSuperview];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}


-(void)designingUI
{
    //self.navigationController.navigationBar.barTintColor = KNavigationColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.btnLogin.layer.cornerRadius = 10;
    self.btnLogin.clipsToBounds = YES;
    
    self.viewUsername.layer.cornerRadius = 10;
    self.viewUsername.clipsToBounds = YES;
    
    self.viewPassword.layer.cornerRadius = 10;
    self.viewPassword.clipsToBounds = YES;

    self.imgViewLogo.layer.cornerRadius = self.imgViewLogo.frame.size.width/2;
    self.imgViewLogo.clipsToBounds = YES;
}

- (IBAction)btnLogin_TouchUpInside:(id)sender
{
    [self.txtFldUsername resignFirstResponder];
    [self.txtFldPassword resignFirstResponder];
    
    BOOL isUsernameValid = [self validateEmailWithString:self.txtFldUsername.text];
    
    if([self.txtFldUsername.text length]==0 && [self.txtFldPassword.text length]==0)
    {
        [self.view makeToast:@"Please enter your Sign in details" duration:3 position:CSToastPositionTop title:nil];
        return;
    }
    else  if([self.txtFldUsername.text length]==0 || !isUsernameValid)
    {
        [self.view makeToast:@"Please enter a valid username" duration:3 position:CSToastPositionTop title:nil];
        return;
    }
    else if ([self.txtFldPassword.text length]==0)
    {
        [self.view makeToast:@"Please enter your password" duration:3 position:CSToastPositionTop title:nil];
        return;
    }
    else if(!([self.txtFldUsername.text isEqualToString:@"havells@gmail.com"] && [self.txtFldPassword.text isEqualToString:@"havells"]))
    {
        [self.view makeToast:@"Email and Password is not valid" duration:3 position:CSToastPositionTop title:nil];
        return;
    }
    
    if([self.txtFldUsername.text length]&&[self.txtFldPassword.text length])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isLoggedin"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //[self performSegueWithIdentifier:@"pushtoTabBarMenu" sender:self];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//        UIView *view = (UIView*)[appDelegate.window viewWithTag:112233];
//        [view removeFromSuperview];

    }
    
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark KeyBoard Methods
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height + 10;
//    if(appDelegate.intScreenHeight<=480)
//    {
//        contentInset.bottom = keyboardRect.size.height + 60;
//    }
    self.scrollView.contentInset = contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UITextField *txtFld = [self.view viewWithTag:nextTag];
    if (txtFld!=nil) {
        // Found next responder, so set it.
        [txtFld becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
