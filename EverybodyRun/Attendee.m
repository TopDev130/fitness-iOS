//
//  Attendee.m
//  EverybodyRun
//
//  Created by star on 2/13/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "Attendee.h"

@implementation Attendee

- (id) initWithDictionary: (NSDictionary*) dicAttendee
{
    self = [super init];
    if(self)
    {
        self.attendee_id = [dicAttendee valueForKey: @"attendee_id"];
        self.event_id = [dicAttendee valueForKey: @"event_id"];
        self.user_id = [dicAttendee valueForKey: @"user_id"];
        self.register_date = [dicAttendee valueForKey: @"register_date"];
    }
    return self;
}

- (id) initWithManageObject: (NSManagedObject*) objAttendee
{
    self = [super init];
    if(self)
    {
        self.attendee_id = [objAttendee valueForKey: @"attendee_id"];
        self.event_id = [objAttendee valueForKey: @"event_id"];
        self.user_id = [objAttendee valueForKey: @"user_id"];
        self.register_date = [objAttendee valueForKey: @"register_date"];
    }
    return self;
}

@end
