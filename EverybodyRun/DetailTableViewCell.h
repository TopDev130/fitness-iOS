//
//  DetailTableViewCell.h
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailTableViewCellDelegate
@optional
- (void) selectedLocation: (Event*) e;
@end

@interface DetailTableViewCell : UITableViewCell
{
    __weak IBOutlet UILabel *lbLocation;
    __weak IBOutlet UILabel *lbDate;
    __weak IBOutlet UILabel *lbTime;
    __weak IBOutlet UILabel *lbType;
    __weak IBOutlet UILabel *lbLevel;
    __weak IBOutlet UILabel *lbDistance;
    __weak IBOutlet UILabel *lbVisibility;
    
    Event                   *currentEvent;
}

@property (nonatomic, retain) id        delegate;

- (void) updateDetailEvent: (Event*) e;
+ (CGFloat) getHeight;
@end
