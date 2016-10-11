//
//  AttendeeTableViewCell.m
//  EverybodyRun
//
//  Created by star on 2/3/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "AttendeeTableViewCell.h"

@interface AttendeeTableViewCell()
{
    IBOutlet UILabel        *lbName;
    IBOutlet UIImageView    *ivAvatar;
}

@end

@implementation AttendeeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initUI
{
    ivAvatar.userInteractionEnabled = YES;
    ivAvatar.layer.masksToBounds = YES;
    ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width/2.0;
    ivAvatar.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapAvatar)];
    gesture.numberOfTapsRequired = 1;
    [ivAvatar addGestureRecognizer: gesture];
}

- (void) updateUser: (User*) u {
    currentUser = u;
    [self initUI];
    
    lbName.text = [NSString stringWithFormat: @"%@ %@", u.first_name, u.last_name];
     if([u.profile_photo length] > 0)
    {
        [ivAvatar setImageWithURL: [AppEngine getImageURL: u.profile_photo] placeholderImage: [UIImage imageNamed: @"default_user.png"]];
    }
}

+ (float) getCellHeight {
    return 50.0;
}

- (void) tapAvatar {
    if ([self.delegate respondsToSelector:@selector(selectedUser:)]) {
        [self.delegate selectedUser: currentUser];
    }
}

@end
