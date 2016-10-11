//
//  BlogLocationTableViewCell.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BlogLocationTableViewCell.h"

@implementation BlogLocationTableViewCell
@synthesize lbContent;
@synthesize lbTitle;
@synthesize ivPhoto;
@synthesize viTitle;

- (void)awakeFromNib {
    
    UIFont* fontTitle = [UIFont fontWithName: FONT_REGULAR size: 14.0];
    
    // Initialization code
    lbTitle.font = fontTitle;
    lbTitle.textColor = COLOR_MAIN_TEXT;
    
    lbContent.font = fontTitle;
    lbContent.italicFont = fontTitle;
    lbContent.boldFont = fontTitle;
    lbContent.boldItalicFont = fontTitle;
    lbContent.textColor = COLOR_SUB_TEXT;
    
    lbFloatingTitle = [[MarqueeLabel alloc] initWithFrame: viTitle.bounds];
    lbFloatingTitle.marqueeType = MLContinuous;
    lbFloatingTitle.textColor = [UIColor whiteColor];
    lbFloatingTitle.font = [UIFont fontWithName: FONT_BOLD_ITALIC size: 30.0];
    lbFloatingTitle.scrollDuration = 15.0f;
    lbFloatingTitle.fadeLength = 10.0f;
    lbFloatingTitle.trailingBuffer = 30.0f;
    [viTitle addSubview: lbFloatingTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBlog: (Blog*) b {
    currentBlog = b;
    [lbFloatingTitle restartLabel];
    lbTitle.html = b.title;
    lbFloatingTitle.text = b.title;
    
    lbContent.html = b.content;
    
    if (b.imageURL != nil) {
        [ivPhoto setImageWithURL: [NSURL URLWithString: b.imageURL]];
    }
}

- (IBAction) actionReadMore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(readMoreBlog:)]) {
        [self.delegate readMoreBlog: currentBlog];
    }
}

@end
