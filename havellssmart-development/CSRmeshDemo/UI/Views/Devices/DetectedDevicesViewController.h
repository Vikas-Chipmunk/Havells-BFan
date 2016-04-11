//
//  DetectedDevicesViewController.h
//  CSRmeshDemo
//
//  Created by SudheerPalchuri on 06/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Places.h"
#import "CSRAreaEntity.h"

@interface DetectedDevicesViewController : UIViewController
@property(nonatomic,strong)Places *placeSelected;
@property(nonatomic,strong) CSRAreaEntity *areaEntity;

@property (nonatomic, retain) NSMutableArray *theDefaultArray;
@property (nonatomic, retain) NSMutableArray *theNewArray;
@property (nonatomic, retain) NSMutableArray *theAddArray;
@property (nonatomic, retain) NSMutableArray *theDeleteArray;

@property (nonatomic, retain) NSMutableArray *listOfLocalDevices;
@end
