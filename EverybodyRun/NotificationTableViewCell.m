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

- (void)layoutSubviews {
    [super layoutSubviews];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.0f];
    
//    CGRect accessoryFrame = self.accessoryView.frame;
//    accessoryFrame.size.width = 50;
//    self.accessoryView.frame = accessoryFrame;
    
//    for (UIView *subView in self.subviews) {
//        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
//            UIView *removeButtonView = (UIView *)[subView.subviews objectAtIndex:0];
//            CGRect f = removeButtonView.frame;
////            f.size.width = 10;
//            removeButtonView.frame = f;
//            
//            CGRect sf = subView.frame;
//            sf.origin.x = sf.origin.x + 50;
//            sf.size.width = sf.size.width - 50;
//            subView.frame = sf;
//
//        }
//    }
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
