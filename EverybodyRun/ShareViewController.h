//
//  ShareViewController.h
//  EverybodyRun
//
//  Created by star on 3/11/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareViewController : BaseViewController
{
    MKMapView                               *shareMapView;
}

- (void) shareEvent: (Event*) e completedHander: (void (^)(void))completed;
- (void) postInstagrame: (UIImage*) image completedHander: (void (^)(void))completed;
@end
