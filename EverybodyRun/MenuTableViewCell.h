//
//  MenuTableViewCell.h
//  EverybodyRun
//
//  Created by star on 3/10/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, weak) IBOutlet UILabel            *lbTitle;
@property (weak, nonatomic) IBOutlet UIView *unReadView;
@property (weak, nonatomic) IBOutlet UILabel *lbNotificationNum;

- (void) setMenuItem: (NSString*) name;
+ (CGFloat) getHeight;
@end
