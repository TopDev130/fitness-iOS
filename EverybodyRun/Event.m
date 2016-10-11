//
//  Event.m
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id) initWithDictionary: (NSDictionary*) dicEvent
{
    self = [super init];
    if(self)
    {
        self.event_id = [dicEvent valueForKey: @"event_id"];
        self.name = [dicEvent valueForKey: @"name"];
        self.lat = [[dicEvent valueForKey: @"lat"] doubleValue];
        self.lng = [[dicEvent valueForKey: @"lng"] doubleValue];
        self.address = [dicEvent valueForKey: @"address"];
        self.allow_invite_request = [[dicEvent valueForKey: @"allow_invite_request"] boolValue];
        self.attendees = [[dicEvent valueForKey: @"attendees"] intValue];
        self.expire_date = [[dicEvent valueForKey: @"expire_date"] intValue];
        self.distance = [[dicEvent valueForKey: @"distance"] doubleValue];
        self.distance_unit = [[dicEvent valueForKey: @"distance_unit"] intValue];
        self.level_min = [[dicEvent valueForKey: @"level_min"] intValue];
        self.level_max = [[dicEvent valueForKey: @"level_max"] intValue];
        self.type = [[dicEvent valueForKey: @"type"] intValue];
        self.visibility = [[dicEvent valueForKey: @"visibility"] intValue];
        self.main_image = [dicEvent valueForKey: @"main_image"];
        self.website = [dicEvent valueForKey: @"website"];
        self.snap_to_road = [[dicEvent valueForKey: @"snap_to_road"] boolValue];
        self.note = [dicEvent valueForKey: @"note"];
        self.post_user_id = [NSString stringWithFormat: @"%d", [[dicEvent valueForKey: @"post_user_id"] intValue]];
        self.register_date = [[dicEvent valueForKey: @"register_date"] intValue];
        self.status = [[dicEvent valueForKey: @"status"] intValue];
        self.is_attended = [[dicEvent valueForKey: @"is_attended"] boolValue];
        self.is_asked_expire = [[dicEvent valueForKey: @"is_asked_expire"] boolValue];
        self.arrAttendedUsers = [[NSMutableArray alloc] init];
        
        NSString* points = [dicEvent valueForKey: @"map_points"];
        self.map_points = [points componentsSeparatedByString: @"#"];
        
        //Post User.
        if([[dicEvent allKeys] containsObject: @"email"])
        {
            self.post_user_email = [AppEngine getValidString: dicEvent[@"email"]];
        }
        if([[dicEvent allKeys] containsObject: @"first_name"])
        {
            self.post_user_first_name = [AppEngine getValidString: dicEvent[@"first_name"]];
        }
        if([[dicEvent allKeys] containsObject: @"last_name"])
        {
            self.post_user_last_name = [AppEngine getValidString: dicEvent[@"last_name"]];
        }
        if([[dicEvent allKeys] containsObject: @"profile_photo"])
        {
            self.post_user_avatar = [AppEngine getValidString: dicEvent[@"profile_photo"]];
        }
    }
    
    return self;
}

- (id) initWithManageObject: (NSManagedObject*) objEvent
{
    self = [super init];
    if(self)
    {
        self.event_id = [objEvent valueForKey: @"event_id"];
        self.name = [objEvent valueForKey: @"name"];
        self.lat = [[objEvent valueForKey: @"lat"] doubleValue];
        self.lng = [[objEvent valueForKey: @"lng"] doubleValue];
        self.address = [objEvent valueForKey: @"address"];
        self.allow_invite_request = [[objEvent valueForKey: @"allow_invite_request"] boolValue];
        self.attendees = [[objEvent valueForKey: @"attendees"] intValue];
        self.expire_date = [[objEvent valueForKey: @"expire_date"] intValue];
        self.distance = [[objEvent valueForKey: @"distance"] doubleValue];
        self.distance_unit = [[objEvent valueForKey: @"distance_unit"] intValue];
        self.level_min = [[objEvent valueForKey: @"level_min"] intValue];
        self.level_max = [[objEvent valueForKey: @"level_max"] intValue];
        self.type = [[objEvent valueForKey: @"type"] intValue];
        self.visibility = [[objEvent valueForKey: @"visibility"] intValue];
        self.main_image = [objEvent valueForKey: @"main_image"];
        self.note = [objEvent valueForKey: @"note"];
        self.website = [objEvent valueForKey: @"website"];
        self.snap_to_road = [[objEvent valueForKey: @"snap_to_road"] boolValue];
        self.post_user_id = [NSString stringWithFormat: @"%d", [[objEvent valueForKey: @"post_user_id"] intValue]];
        self.register_date = [[objEvent valueForKey: @"register_date"] intValue];
        self.status = [[objEvent valueForKey: @"status"] intValue];
        self.is_attended = [[objEvent valueForKey: @"is_attended"] boolValue];
        self.is_asked_expire = [[objEvent valueForKey: @"is_asked_expire"] boolValue];
        self.arrAttendedUsers = [[NSMutableArray alloc] init];
        
        NSString* points = [objEvent valueForKey: @"map_points"];
        self.map_points = [points componentsSeparatedByString: @"#"];
        
        //Post User.
        self.post_user_email = [AppEngine getValidString: [objEvent valueForKey: @"email"]];
        self.post_user_first_name = [AppEngine getValidString: [objEvent valueForKey: @"first_name"]];
        self.post_user_last_name = [AppEngine getValidString: [objEvent valueForKey: @"last_name"]];
        self.post_user_avatar = [AppEngine getValidString: [objEvent valueForKey: @"profile_photo"]];
    }
    
    return self;
}

- (BOOL) isExpire: (NSDate*) currentDate
{
    NSDate* expireDate = [NSDate dateWithTimeIntervalSince1970: self.expire_date];
    if( [expireDate timeIntervalSinceDate: currentDate] > 0 )
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL) isEventByCurrentUser
{
    return [self.post_user_id intValue] == [[AppEngine sharedInstance].currentUser.user_id intValue];
}

- (NSString*) getLevelString
{
    if([AppEngine sharedInstance].distanceUnit == DISTANCE_KILOMETER)
    {
        return [NSString stringWithFormat: @"Pace: %0.1fMin/Km ~ %0.1fMin/Km\n", self.level_min, self.level_max];
    }
    else
    {
        return [NSString stringWithFormat: @"Pace: %0.1fMin/Mi ~ %0.1fMin/Mi\n", self.level_min * 1.609344, self.level_max * 1.609344];
    }
}

- (NSString*) getDistanceString {
    
    NSString* distance;
    if([AppEngine sharedInstance].distanceUnit == DISTANCE_KILOMETER)
    {
        distance = [NSString stringWithFormat: @"%0.2f Km", self.distance / 1000.0];
    }
    else
    {
        distance = [NSString stringWithFormat: @"%0.2f Mile", self.distance / 1609.34];
    }
    
    return distance;
}

- (NSString*) getNewExpireDate {
    NSDate* expireDate = [NSDate dateWithTimeIntervalSince1970: self.expire_date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"EEEE | MM.yy"];
    return [formatter stringFromDate: expireDate];
}

- (NSString*) getExpireDateAndTime {
    NSDate* expireDate = [NSDate dateWithTimeIntervalSince1970: self.expire_date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd/MM/YY"];
    return [formatter stringFromDate: expireDate];
}

- (NSString*) getExpireDate
{
    NSDate* expireDate = [NSDate dateWithTimeIntervalSince1970: self.expire_date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: DATE_FORMATTER];
    return [formatter stringFromDate: expireDate];
}

- (NSString*) getExpireTime
{
    NSDate* expireDate = [NSDate dateWithTimeIntervalSince1970: self.expire_date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: TIME_FORMATTER];
    return [formatter stringFromDate: expireDate];
}

- (BOOL) isNearByEvent: (double) cur_lat lng: (double) cur_lng
{
    CLLocation* locEvent = [[CLLocation alloc] initWithLatitude: self.lat longitude: self.lng];
    CLLocation* locCurrent = [[CLLocation alloc] initWithLatitude: cur_lat longitude: cur_lng];
    
    float distance = [AppEngine getDistanceForKM: locEvent loc2: locCurrent];
    
    if(distance <= NEARBY_DISTANCE)
    {
        return YES;
    }
    
    return NO;
}

@end
