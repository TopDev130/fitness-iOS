//
//  Attendee.h
//  EverybodyRun
//
//  Created by star on 2/13/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attendee : NSObject
{
    
}

@property (nonatomic, strong) NSNumber*         attendee_id;
@property (nonatomic, strong) NSNumber*         event_id;
@property (nonatomic, strong) NSNumber*         user_id;
@property (nonatomic, strong) NSNumber*         register_date;

- (id) initWithDictionary: (NSDictionary*) dicAttendee;
- (id) initWithManageObject: (NSManagedObject*) objAttendee;

@end
