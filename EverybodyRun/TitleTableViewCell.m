//
//  TitileTableViewCell.m
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "TitleTableViewCell.h"

@implementation TitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateEvent: (Event*) e
{
    self.event = e;
    lbTitle.text = e.name;
    lbAttendees.text = [NSString stringWithFormat: @"%d", e.attendees + 1];
    
    if([e isExpire: [AppEngine sharedInstance].filterDate])
    {
        lbTitle.textColor = [UIColor yellowColor];
    }
    else
    {
        lbTitle.textColor = [UIColor whiteColor];
    }
}

- (IBAction) actionAttendees:(id)sender
{
    if ([self.dataDelegate respondsToSelector:@selector(selectedAttendees:)]) {
        [self.dataDelegate selectedAttendees: self.event];
    }
}
@end
