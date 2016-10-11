//
//  EventAnnotation.m
//  EverybodyRun
//
//  Created by star on 2/3/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "EventAnnotation.h"

@implementation EventAnnotation


- (id) initWithEvent: (Event*) e {
    self = [super init];
    if (self) {
        self.event = e;
        self.coordinate = [[CLLocation alloc] initWithLatitude: e.lat longitude: e.lng].coordinate;
        self.title = @"";
    }
    return self;
}

- (UIImage*) getIconForAnnotation {
    if(self.event.visibility == VISIBILITY_OPEN)
    {
        return [UIImage imageNamed:@"open_event"];
    }
    else if(self.event.visibility == VISIBILITY_CLOSED)
    {
        return [UIImage imageNamed:@"close_event"];
    }
    return nil;
}

- (UIImage*) getDoubleIconForAnnotation {
    if(self.event.visibility == VISIBILITY_OPEN)
    {
        return [UIImage imageNamed:@"open_event_double"];
    }
    else if(self.event.visibility == VISIBILITY_CLOSED)
    {
        return [UIImage imageNamed:@"close_event_double"];
    }
    return nil;
}

- (NSString*) getIdentiferString{
    if(self.isSelected) {
        if(self.event.visibility == VISIBILITY_OPEN)
        {
            return @"open_event_double";
        }
        else if(self.event.visibility == VISIBILITY_CLOSED)
        {
            return @"close_event_double";
        }

    } else
    {
        if(self.event.visibility == VISIBILITY_OPEN)
        {
            return @"open_event";
        }
        else if(self.event.visibility == VISIBILITY_CLOSED)
        {
            return @"close_event";
        }
    }
    
    return nil;
}
@end
