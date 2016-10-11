//
//  CategoryTableViewCell.m
//  EverybodyRun
//
//  Created by star on 2/27/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setName: (NSString*) name count: (int) count level:(NSInteger)level
{
    lbTitle.text = name;
    lbDescription.text = [NSString stringWithFormat: @"%d event(s)", count];
    
    if (level == 0) {
        lbDescription.textColor = [UIColor blackColor];
    }
    
    if (level == 0) {
        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (level == 1) {
        self.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (level >= 2) {
        self.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
    
    CGFloat left = 11 + 20 * level;
    
    CGRect titleFrame = lbTitle.frame;
    titleFrame.origin.x = left;
    lbTitle.frame = titleFrame;
    
    CGRect detailsFrame = lbDescription.frame;
    detailsFrame.origin.x = left;
    lbDescription.frame = detailsFrame;

}

@end
