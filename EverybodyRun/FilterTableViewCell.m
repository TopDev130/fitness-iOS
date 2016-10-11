//
//  FilterTableViewCell.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/23/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell
@synthesize lbTitle;
@synthesize ivIcon;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setFilter: (NSDictionary*) dicItem isSelected: (BOOL) isSelected
{
    NSString* icon = dicItem[@"icon"];
//    NSString* selected_icon = dicItem[@"sel_icon"];
    NSString* title = dicItem[@"title"];
    
    lbTitle.text = title;
    if([icon length] > 0)
    {
        ivIcon.hidden = NO;
        if(isSelected)
        {
//            ivIcon.image = [UIImage imageNamed: selected_icon];
            ivIcon.image = [UIImage imageNamed: icon];
        }
        else
        {
            ivIcon.image = [UIImage imageNamed: icon];
        }
    }
    else
    {
        ivIcon.hidden = YES;
    }
    
    if(isSelected)
    {
        lbTitle.textColor = [UIColor colorWithRed: 0 green: 199.0/255.0 blue: 0 alpha: 1.0];
        lbTitle.font = [UIFont fontWithName: FONT_BOLD size: 16.0];
    }
    else
    {
        lbTitle.textColor = [UIColor colorWithRed: 146.0/255.0 green: 148.0/255.0 blue:151.0/255.0 alpha: 1.0];
        lbTitle.font = [UIFont fontWithName: FONT_REGULAR size: 16.0];
    }
}

@end
