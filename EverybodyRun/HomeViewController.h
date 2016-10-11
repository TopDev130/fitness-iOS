//
//  HomeViewController.h
//  EverybodyRun
//
//  Created by star on 1/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "ShareViewController.h"

@interface HomeViewController : ShareViewController
{
    
}

- (void) selectEvent: (Event*) e;
- (void) showEventInCenter: (Event*) e;
- (void) loadEventsFromServer;

- (void) updateEvent: (Event*) e;
- (void) removeEvent: (int) event_id;
- (void) refreshMapView;
- (void) applicationIsActive;

@end
