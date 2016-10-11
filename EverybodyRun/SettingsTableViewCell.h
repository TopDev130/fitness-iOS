//
//  SettingsTableViewCell.h
//  EverybodyRun
//
//  Created by star on 3/10/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsTableViewCellDelegate

@optional
- (void) valueChanged: (int) value index: (int) index;
@end

@interface SettingsTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, weak) IBOutlet UILabel                *lbTitle;
@property (nonatomic, weak) IBOutlet UISegmentedControl     *seType;
@property (nonatomic, assign) int                           index;
@property (nonatomic, retain) id                            delegate;

@end
