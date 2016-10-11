//
//  FilterTableViewCell.h
//  EverybodyRun
//
//  Created by Marcin Robak on 5/23/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, weak) IBOutlet UIImageView            *ivIcon;
@property (nonatomic, weak) IBOutlet UILabel                *lbTitle;

- (void) setFilter: (NSDictionary*) dicItem isSelected: (BOOL) isSelected;
@end
