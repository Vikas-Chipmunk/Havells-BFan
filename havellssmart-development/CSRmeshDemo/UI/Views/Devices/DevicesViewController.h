//
//  DevicesViewController.h
//  CSRmeshDemo
//
//  Created by SudheerPalchuri on 06/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRConstants.h"
#import "Places.h"
#import "CSRAreaEntity.h"

@interface DevicesViewController : UIViewController
@property(nonatomic,strong)Places *placeSelected;
@property(nonatomic,strong) CSRAreaEntity *areaEntity;
@end
