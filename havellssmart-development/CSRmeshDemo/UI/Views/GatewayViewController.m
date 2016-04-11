//
//  GatewayViewController.m
//  CSRmeshDemo
//
//  Created by Budim on 2/9/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "GatewayViewController.h"
#import "AppDelegate.h"
#import "UIViewController+CSRMenuSlidingViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"


@implementation GatewayViewController{
    AppDelegate *appDelegate;
    AFHTTPSessionManager *manager;
    NSURL *baseURL;
    NSDictionary *parameters;
}



-(void)viewDidLoad{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.AwayOutletButton.layer.cornerRadius = self.AwayOutletButton.bounds.size.width/2;
    self.ArrivingOutletButton.layer.cornerRadius =self.ArrivingOutletButton.bounds.size.width/2;
    self.AwayOutletButton.enabled = NO;
    self.ArrivingOutletButton.enabled = NO;
    [self getAssociatedDevices];
    
    
    baseURL = [NSURL URLWithString:@"100.100.100/"];
    // parameters = @[{@"format": @"json"},{@"messgae":@""}];
    
    
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
}

- (IBAction)AwayActionButton:(id)sender {
    NSLog(@"Set all Devices OFF");
    
    NSString *url_str = @"http://52.36.91.149:8080/setalloff";
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (IBAction)ArrivingActionButton:(id)sender {
    NSLog(@"Set all Devices ON");
    NSLog(@"Set all Devices OFF");
    
    NSString *url_str = @"http://52.36.91.149:8080/setallon";
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did Receive Response %@", response);

}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);

}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Did Finish");
    // Do something with responseData
}

- (IBAction)MenuBtnAction:(id)sender {
    
    if(self.slidingViewController.currentTopViewPosition == MenuSlidingViewControllerTopViewPositionCentered){
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    }
    else{
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}


-(void)getAssociatedDevices{
    
    NSMutableArray *associatedDevices = [[NSMutableArray alloc]init];
    if(0){
//        associatedDevices =appDelegate.dummyDeviceList;
//        associatedDevices = (NSMutableArray*)[associatedDevices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAssociated == 1"]];
        
    }else{
        
        associatedDevices = [[[CSRAppStateManager sharedInstance].selectedPlace.devices allObjects] mutableCopy];
        
        //Filter associated Devices to send to server
        associatedDevices = (NSMutableArray*)[associatedDevices filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isAssociatedToAPlace == 1"]];
        
//        //Sort devices alphabetically
//        if (associatedDevices != nil && [associatedDevices count] != 0) {
//            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
//            [associatedDevices sortUsingDescriptors:[NSArray arrayWithObject:sort]];
//        }
    }
    
    NSLog(@"Send Details to Server");
    if(associatedDevices.count){
        [self sendAssociatedDevicestoServer:associatedDevices];
        self.ArrivingOutletButton.enabled = YES;
        self.AwayOutletButton.enabled = YES;
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Prism" message:@"There is no device(s) associated in the home" delegate:nil cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        
        [alert show];
    }
}

-(void)sendAssociatedDevicestoServer:(NSMutableArray*)array{
    //method for sending all associated devices to the server
    if(0){
        parameters = @{@"devices":array};
        [manager POST:@"sendDeviceList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            self.title = @"HTTP POST";
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }
    
}
@end
