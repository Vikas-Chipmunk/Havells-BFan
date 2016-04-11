//
//  CSRFanControlTableViewCell.m
//  CSRmeshDemo
//
//  Created by Vikas M K on 12/03/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "CSRFanControlTableViewCell.h"

@implementation CSRFanControlTableViewCell

@synthesize cellIconImageView;
@synthesize tiltleForCellLabel;
@synthesize descriptionForCellLabel;
@synthesize customViewForCell;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
