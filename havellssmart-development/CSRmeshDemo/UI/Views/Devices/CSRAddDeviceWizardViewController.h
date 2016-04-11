//
// Copyright 2015 Qualcomm Technologies International, Ltd.
//


#import "CSRMainViewController.h"
#import "CSRDeviceEntity.h"
#import "CSRmeshDevice.h"

@interface CSRAddDeviceWizardViewController : CSRMainViewController <UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) CSRDeviceEntity *deviceEntity;
@property (nonatomic) CSRmeshDevice *selectedDevice;

@property (weak, nonatomic) IBOutlet UIView *devicesListView;

//DevicesList
@property (weak, nonatomic) IBOutlet UITableView *devicesTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *devicesNextButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *associateDeviceButton;

@property (nonatomic) UIBarButtonItem *backButton;

//Need to make scan results global to use it for Segue and Database Operations
//@property (nonatomic, strong) NSString *uuidStringFromQRScan;
//@property (nonatomic, strong) NSString *acStringFromQRScan;


@end
