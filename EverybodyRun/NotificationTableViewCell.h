//
//  NotificationTableViewCell.h
//  EverybodyRun
//
//  Created by Marcin Robak on 5/19/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationTableViewCellDelegate
@optional
- (void) deleteNotification: (int) index;
@end

@interface NotificationTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, weak) IBOutlet UILabel            *lbTitle;
@property (nonatomic, retain) id                        delegate;

- (void) setNotification: (NSString*) notification;
@end
