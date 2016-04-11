//
//  BaseViewController1.m
//  Nacht
//
//  Created by Bimal Sharma on 31/08/15.
//  Copyright (c) 2015 Bimal Sharma. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize btnBack,btnSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertWithMessage:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:msg delegate:nil cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    
    [alert show];
}

-(void)showAlert:(NSString *)title message:(NSString*)message  Delegate:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:sender
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok",nil];
    [alertView show];
    
}



- (BOOL)validateEmail: (NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)backToPrevious
{
      [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToPreviousPresenting
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Date Format
-(NSDate *)convertDateFromString:(NSString *)strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    
    NSDate *date1= [formatter dateFromString:strDate];
    return date1;
}

-(NSDate *)convertDateFromString:(NSString *)strDate OutputFormat:(NSString *)outPutFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:outPutFormat];
    
    NSDate *date1= [formatter dateFromString:strDate];
    return date1;
}
#pragma mark - Date Format
-(NSString *)convertStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *date1= [formatter stringFromDate:date];
    return date1;
}


#pragma mark - Date Format
//*****
-(NSString *)convertStringFromDate:(NSDate *)date OutputFormat:(NSString *)outPutFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:outPutFormat];
    
    NSString *date1= [formatter stringFromDate:date];
    return date1;
}

#pragma mark-validation
-(BOOL)isValidDate:(NSDate*)selectedDate{
    NSDate *startDate=[NSDate date];
    if([startDate compare: selectedDate] == NSOrderedDescending || [startDate compare: selectedDate] == NSOrderedSame) // if start is later in time than end
    {
        // do something
        return NO;
    }
    else if([startDate compare: selectedDate] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

-(BOOL)isStringContainNumber :(NSString*)input{
    //This is the input string that is either an email or phone number
    
    //This is the string that is going to be compared to the input string
    NSString *testString = [NSString string];
    
    NSScanner *scanner = [NSScanner scannerWithString:input];
    
    //This is the character set containing all digits. It is used to filter the input string
    NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    
    //This goes through the input string and puts all the
    //characters that are digits into the new string
    [scanner scanCharactersFromSet:skips intoString:&testString];
    
    //If the string containing all the numbers has the same length as the input...
    if([input length] == [testString length]) {
        return YES;
        //...then the input contains only numbers and is a phone number, not an email
    }
    
    return NO;
}


- (NSString *) GetUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    NSLog(@"   ---- strDateTime = %@",strDateTime);
    return strDateTime;
}

- (NSMutableAttributedString *)getAttributedString:(NSString*)text andRange1:(NSRange)range1 andRange2:(NSRange)range2{
    NSLog(@"TEXT LENGHT:%lu",(unsigned long)text.length);
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range1];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range2];
    return string;
}



-(NSString *)roundToNearestValue:(double)number
{
    NSNumber *aNumber = [NSNumber numberWithDouble:number];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setUsesGroupingSeparator:NO];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    NSString *string = [numberFormatter stringFromNumber:aNumber];
    return string;
}

-(UIViewController*)getViewControllerForIdentifier:(NSString*)identifier{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *mviewController =[storyboard instantiateViewControllerWithIdentifier:identifier];
    return mviewController;
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

-(void)saveUserPref:(NSString*)pref andKey:(NSString*)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setValue:pref forKey:key];
    [userDefaults synchronize];
}

-(NSString*)getUserPref:(NSString*)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    return [userDefaults valueForKey:key];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
