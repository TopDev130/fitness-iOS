//
//  BlogListTableViewCell.h
//  EverybodyRun
//
//  Created by Marcin Robak on 5/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BlogListTableViewCellDelegate
@optional
- (void) readMoreBlog: (Blog*) b;
@end

@interface BlogListTableViewCell : UITableViewCell {
    Blog*       currentBlog;
    
}
@property (nonatomic, retain) id                            delegate;
@property (nonatomic, weak) IBOutlet UILabel                *lbTitle;
- (void) setBlog: (Blog*) b;
@end
