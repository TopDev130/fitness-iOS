//
//  SettingsTableViewCell.m
//  EverybodyRun
//
//  Created by star on 3/10/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) actionValueChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(valueChanged:index:)])
    {
        [self.delegate valueChanged: (int)self.seType.selectedSegmentIndex index: self.index];
    }
}

@end
