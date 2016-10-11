//
//  BaseViewController.h
//  EverybodyRun
//
//  Created by star on 1/31/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    
}

- (void) initMember;
- (IBAction) actionBack:(id)sender;
- (void) gotoMainView: (BOOL) animate;
- (NSString*) getShareMessage: (Event*) e;
- (NSString*) getShareTwitterMessage: (Event*) e;
@end
