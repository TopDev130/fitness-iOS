//
//  EventListViewController.h
//  EverybodyRun
//
//  Created by Marcin Robak on 5/20/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BaseViewController.h"

@interface EventListViewController : BaseViewController
{
    
}

@property (nonatomic, strong) NSMutableArray            *arrAllEvents;
@property (nonatomic, strong) NSMutableArray            *arrAttendingEvents;
@property (nonatomic, strong) NSMutableArray            *arrOrganizingEvents;
@property (nonatomic, assign) CLLocationCoordinate2D    currentLocation;

@property (nonatomic, strong) id                        homeViewController;

- (void) addNewMyEvent: (Event*) newEvent;
- (void) updateEvent: (Event*) e;
- (void) removeEvent: (int) event_id;


@end
