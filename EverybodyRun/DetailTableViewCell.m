//
//  DetailTableViewCell.m
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateDetailEvent: (Event*) e
{
    currentEvent = e;
    
    lbLocation.text = [NSString stringWithFormat: @"Location: %@", e.address];
    lbDate.text = [NSString stringWithFormat: @"Date: %@", [e getExpireDate]];
    lbTime.text = [NSString stringWithFormat: @"Time: %@", [e getExpireTime]];
    lbType.text = [NSString stringWithFormat: @"Type: %@", [ARRAY_TYPE objectAtIndex: e.type]];
    lbLevel.text = [NSString stringWithFormat: @"Pace: %@", [e getLevelString]];
    
    if([AppEngine sharedInstance].distanceUnit == DISTANCE_KILOMETER)
    {
        lbDistance.text = [NSString stringWithFormat: @"Distance: %0.2f Km", e.distance / 1000.0];
    }
    else
    {
        lbDistance.text = [NSString stringWithFormat: @"Distance: %0.2f Mile", e.distance / 1609.34];
    }

    lbVisibility.text = [NSString stringWithFormat: @"Visibility: %@", [ARRAY_VISIBILITY objectAtIndex: e.visibility]];
}

- (IBAction) actionLocation:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectedLocation:)])
    {
        [self.delegate selectedLocation: currentEvent];
    }
}

+ (CGFloat) getHeight
{
    return 280.0;
}

@end
