//
//  MenuTableViewCell.m
//  EverybodyRun
//
//  Created by star on 3/10/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell
@synthesize lbTitle;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMenuItem: (NSString*) name
{
    self.backgroundColor = [UIColor clearColor];
    lbTitle.text = name;
}

+ (CGFloat) getHeight
{
    return 50.0;
}
@end
