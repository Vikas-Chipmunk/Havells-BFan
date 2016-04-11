//
//  MyRuleCell.m
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 27/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#import "MyRuleCell.h"

@implementation MyRuleCell
{
    UIPickerView *mPickerView;
}

- (void)awakeFromNib {
    // Initialization code
    mPickerView=[[UIPickerView alloc] init];
    [mPickerView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sliderValueChanges:(id)sender {
    
    [self.myRuleCellDelegate gotoMyRuleView:self.mIndexPath];
}

- (IBAction)switchButtonClicked:(id)sender {
    
    if (self.viewSwitch.isOn) {
        [self.lblStatus setText:@"On"];
    }
    else{
        [self.lblStatus setText:@"Off"];
    }
    [self.myRuleCellDelegate gotoMyRuleView:self.mIndexPath];
}

- (IBAction)clickBtnTruFalse:(id)sender {
    
    [self.myRuleCellDelegate gotoMyRuleView:self.mIndexPath];
    
//    if (self.mPickerView.hidden) {
//        [self.mPickerView setHidden:NO];
//    }
//    else{
//        [self.mPickerView setHidden:YES];
//    }
    
    [self loadPickerView:nil andView:self.btnTruFalse];
}

#pragma mark-uipickerview datasource and delegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return 2;
}
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[NSMutableArray arrayWithObjects:@" True",@" False", nil] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //Write the required logic here that should happen after you select a row in Picker View.
    [self.btnTruFalse setTitle:[[NSMutableArray arrayWithObjects:@"   True",@"   False", nil] objectAtIndex:row] forState:UIControlStateNormal];
    
    [pickerView setHidden:YES];
}

-(void)loadPickerView:(NSArray*)pickerItem andView:(UIView*)view{
    
    mPickerView.frame=CGRectMake(view.frame.origin.x+30, view.frame.origin.y,view.frame.size.width, 100);
    
    mPickerView.showsSelectionIndicator = YES;
    mPickerView.hidden = NO;
    mPickerView.delegate = self;
    [self addSubview:mPickerView];
}
@end
