//
//  BlogLocationTableViewCell.h
//  EverybodyRun
//
//  Created by Marcin Robak on 5/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextLabel.h"
#import "MarqueeLabel.h"

@protocol BlogLocationTableViewCellDelegate
@optional
- (void) readMoreBlog: (Blog*) b;
@end

@interface BlogLocationTableViewCell : UITableViewCell
{
    Blog                        *currentBlog;
    MarqueeLabel                *lbFloatingTitle;
}

@property (nonatomic, weak) IBOutlet UIView         *viTitle;
@property (nonatomic, weak) IBOutlet UIImageView    *ivPhoto;
@property (nonatomic, weak) IBOutlet CoreTextLabel  *lbTitle;
@property (nonatomic, weak) IBOutlet CoreTextLabel  *lbContent;
@property (nonatomic, retain) id                    delegate;

- (void) setBlog: (Blog*) b;

@end
