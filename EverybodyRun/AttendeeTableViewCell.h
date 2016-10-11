//
//  AttendeeTableViewCell.h
//  EverybodyRun
//
//  Created by star on 2/3/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttendeeTableViewCellDelegate
@optional
- (void) selectedUser: (User*) e;
@end

@interface AttendeeTableViewCell : UITableViewCell {
    User*       currentUser;
}

@property (nonatomic, retain) id    delegate;

- (void) updateUser: (User*) u;
+ (float) getCellHeight;
@end
