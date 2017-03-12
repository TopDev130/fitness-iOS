//
//  BaseViewController.m
//  EverybodyRun
//
//  Created by star on 1/31/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BaseViewController.h"
#import <MFSideMenu/MFSideMenuContainerViewController.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initMember];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMember
{
    if ([AppEngine sharedInstance].currentUser != nil) {
        [[NetworkClient sharedClient] getNotifications: [AppEngine sharedInstance].currentUser.user_id success:^(NSArray *array) {
            [AppEngine sharedInstance].currentUser.unread_notification_num = (int)[array count];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"unReadEventNotification" object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) gotoMainView: (BOOL) animate
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id homeView = [storyboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
    id leftView = [storyboard instantiateViewControllerWithIdentifier: @"MenuViewController"];
    id rightView = [storyboard instantiateViewControllerWithIdentifier: @"BlogListViewController"];
    
    
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:homeView
                                                    leftMenuViewController: leftView
                                                    rightMenuViewController: rightView];
    
    container.leftMenuWidth = self.view.frame.size.width - MENU_INDENT;
    container.rightMenuWidth = self.view.frame.size.width - MENU_INDENT;
    [self.navigationController pushViewController: container animated: animate];
}

- (NSString*) getShareMessage: (Event*) e
{
//    NSString* result = @"";
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Name: %@\n", e.name]];
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Location: %@\n", e.address]];
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Date: %@\n", [e getExpireDate]]];
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Time: %@\n", [e getExpireTime]]];
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Type: %@\n", [ARRAY_TYPE objectAtIndex: e.type]]];
//    
//    if([AppEngine sharedInstance].distanceUnit == DISTANCE_KILOMETER)
//    {
//        result = [result stringByAppendingString: [e getLevelString]];
//    }
//    else
//    {
//        result = [result stringByAppendingString: [e getLevelString]];
//    }
//    
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Distance: %0.2f %@\n", e.distance, [ARRAY_DISTANCE_UNIT objectAtIndex: e.distance_unit]]];
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Visibility: %@", [ARRAY_VISIBILITY objectAtIndex: e.visibility]]];
//    
//    return result;
    return @"I'm inviting you to an event created using the #everybodyrun app, click for details:";
}

- (NSString*) getShareTwitterMessage: (Event*) e
{
//    NSString* result = @"";
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Name: %@\n", e.name]];
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Date: %@\n", [e getExpireDate]]];
//    result = [result stringByAppendingString: [NSString stringWithFormat: @"Time: %@\n", [e getExpireTime]]];
//    return result;
    return @"I'm inviting you to an event I created using the #everybodyrun app, click for details:";
}

@end
