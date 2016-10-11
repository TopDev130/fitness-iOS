//
//  NotificationTableViewCell.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/19/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setNotification: (Notification*) n {
    self.lbTitle.text = n.message;
}

- (IBAction) actionDelete:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteNotification:)]) {
        [self.delegate deleteNotification: (int)self.tag];
    }
}


@end
