//
//  CSRFanControlTableViewCell.h
//  CSRmeshDemo
//
//  Created by Vikas M K on 12/03/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSRFanControlTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tiltleForCellLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionForCellLabel;
@property (weak, nonatomic) IBOutlet UIView *customViewForCell;
@end
