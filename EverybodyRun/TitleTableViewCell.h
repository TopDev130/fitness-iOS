//
//  TitileTableViewCell.h
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>

@protocol TitleTableViewCellDelegate
@optional
- (void) selectedEvent: (Event*) e indexPath: (NSIndexPath*) indexPath;
- (void) selectedAttendees: (Event*) e;
@end

@interface TitleTableViewCell : SWTableViewCell
{
    __weak IBOutlet UILabel         *lbTitle;
    __weak IBOutlet UIImageView     *ivIndicator;
    __weak IBOutlet UILabel         *lbAttendees;
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) id    dataDelegate;

- (void) updateEvent: (Event*) e;
@end
