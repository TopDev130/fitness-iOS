//
//  User.m
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithDictionary: (NSDictionary*) dicUser
{
    self = [super init];
    if(self)
    {
        self.user_id = [dicUser valueForKey: @"user_id"];
        self.first_name = [dicUser valueForKey: @"first_name"];
        self.last_name = [dicUser valueForKey: @"last_name"];
        self.email = [dicUser valueForKey: @"email"];
        self.profile_photo = [dicUser valueForKey: @"profile_photo"];
        self.status = [dicUser valueForKey: @"status"];
        self.last_login = [dicUser valueForKey: @"last_login"];
        self.register_date = [dicUser valueForKey: @"register_date"];
        self.lat = [dicUser valueForKey: @"lat"];
        self.lng = [dicUser valueForKey: @"lng"];
        self.uuid = [dicUser valueForKey: @"uuid"];
        self.birthday = dicUser[@"birthday"];
        self.gender = dicUser[@"gender"];
        self.location = dicUser[@"location"];
    }
    
    return self;
}

- (id) initWithManageObject: (NSManagedObject*) objUser
{
    self = [super init];
    if(self)
    {
        self.user_id = [objUser valueForKey: @"user_id"];
        self.first_name = [objUser valueForKey: @"first_name"];
        self.last_name = [objUser valueForKey: @"last_name"];
        self.email = [objUser valueForKey: @"email"];
        self.profile_photo = [objUser valueForKey: @"profile_photo"];
        self.status = [objUser valueForKey: @"status"];
        self.last_login = [objUser valueForKey: @"last_login"];
        self.register_date = [objUser valueForKey: @"register_date"];
        self.lat = [objUser valueForKey: @"lat"];
        self.lng = [objUser valueForKey: @"lng"];
        self.uuid = [objUser valueForKey: @"uuid"];
        self.birthday = [objUser valueForKey: @"birthday"];
        self.gender = [objUser valueForKey: @"gender"];
        self.location = [objUser valueForKey: @"location"];
    }
    
    return self;
}

- (NSDate*) getBirthdate {
    if([self.birthday intValue] <= 0) return nil;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: [self.birthday intValue]];
    return date;
}

- (NSString*) getName {
    return [NSString stringWithFormat: @"%@ %@", self.first_name, self.last_name];
}


- (NSString*) getAge {
    NSDate* now = [NSDate date];
    NSDate* birthday = [self getBirthdate];
    
    if(birthday) {
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:birthday
                                           toDate:now
                                           options:0];
        NSInteger age = [ageComponents year];
        if(age <= 0) return @"";
        return [NSString stringWithFormat: @"%d", (int)age];
    }
    
    return @"";
}

- (NSString*) getGender {
    return [ARRAY_GENDER objectAtIndex: [self.gender intValue]];
}

@end
