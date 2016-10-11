//
//  BlogListTableViewCell.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BlogListTableViewCell.h"

@implementation BlogListTableViewCell
@synthesize lbTitle;
- (void)awakeFromNib {
    
    // Initialization code
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(actionReadMore:)];
    lbTitle.userInteractionEnabled = YES;
    [lbTitle addGestureRecognizer: tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBlog: (Blog*) b {
    currentBlog = b;
    lbTitle.text = b.title;
}

- (IBAction) actionReadMore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(readMoreBlog:)]) {
        [self.delegate readMoreBlog: currentBlog];
    }
}

@end
