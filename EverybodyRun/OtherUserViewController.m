//
//  OtherUserViewController.m
//  EverybodyRun
//
//  Created by star on 6/8/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "OtherUserViewController.h"

@interface OtherUserViewController ()
{
    
}

@property (nonatomic, weak) IBOutlet UIView         *viAvatar;
@property (nonatomic, weak) IBOutlet UIImageView    *ivAvatar;
@property (nonatomic, weak) IBOutlet UILabel        *lbName;
@property (nonatomic, weak) IBOutlet UIView         *viAge;
@property (nonatomic, weak) IBOutlet UILabel        *lbAge;
@property (nonatomic, weak) IBOutlet UIView         *viGender;
@property (nonatomic, weak) IBOutlet UILabel        *lbGender;
@end

@implementation OtherUserViewController
@synthesize viAvatar;
@synthesize ivAvatar;
@synthesize lbName;
@synthesize viAge;
@synthesize lbAge;
@synthesize viGender;
@synthesize lbGender;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMember {
    [super initMember];
    
    viAvatar.layer.cornerRadius = viAvatar.frame.size.width / 2.0;
    ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width / 2.0;
    
    viAge.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viGender.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    //Fill Info.
    NSString* name = [NSString stringWithFormat: @"%@ %@", self.userInfo.first_name, self.userInfo.last_name];
    NSString* age = [self.userInfo getAge];
    NSString* gender = [self.userInfo getGender];
    
    [ivAvatar setImageWithURL: [AppEngine getImageURL: self.userInfo.profile_photo] placeholderImage: [UIImage imageNamed: @"default_user.png"]];
    lbName.text = name;
    lbAge.text = [NSString stringWithFormat: @"Age: %@", age];
    lbGender.text = [NSString stringWithFormat: @"Sex: %@", gender];
}

@end
