//
//  Event.h
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Event : NSObject
{
    
}

@property (nonatomic, strong) NSNumber*         event_id;
@property (nonatomic, strong) NSString*         name;
@property (nonatomic, strong) NSString*         address;
@property (nonatomic, assign) double            lat;
@property (nonatomic, assign) double            lng;
@property (nonatomic, strong) NSArray*          map_points;
@property (nonatomic, assign) int               expire_date;
@property (nonatomic, assign) int               type;
@property (nonatomic, assign) float             level_min;
@property (nonatomic, assign) float             level_max;
@property (nonatomic, assign) float             distance;
@property (nonatomic, assign) int               distance_unit;
@property (nonatomic, assign) int               visibility;
@property (nonatomic, strong) NSString          *note;
@property (nonatomic, strong) NSString          *website;
@property (nonatomic, assign) BOOL              snap_to_road;
@property (nonatomic, assign) BOOL              allow_invite_request;
@property (nonatomic, strong) NSString          *main_image;
@property (nonatomic, strong) NSString          *post_user_id;
@property (nonatomic, assign) int               attendees;
@property (nonatomic, assign) int               register_date;
@property (nonatomic, assign) int               status;

@property (nonatomic, strong) NSString          *post_user_email;
@property (nonatomic, strong) NSString          *post_user_first_name;
@property (nonatomic, strong) NSString          *post_user_last_name;
@property (nonatomic, strong) NSString          *post_user_avatar;
@property (nonatomic, assign) BOOL              is_attended;
@property (nonatomic, assign) BOOL              is_asked_expire;

//Custom
@property (nonatomic, assign) BOOL              isVisible;
@property (nonatomic, assign) BOOL              isClickedDeepLink;
@property (nonatomic, strong) NSMutableArray    *arrAttendedUsers;

- (id) initWithDictionary: (NSDictionary*) dicEvent;
- (id) initWithManageObject: (NSManagedObject*) objEvent;
- (BOOL) isExpire: (NSDate*) currentDate;
- (BOOL) isEventByCurrentUser;
- (BOOL) isNearByEvent: (double) cur_lat lng: (double) cur_lng;
- (NSString*) getLevelString;
- (NSString*) getNewExpireDate;
- (NSString*) getDistanceString;
- (NSString*) getExpireDateAndTime;
- (NSString*) getExpireDate;
- (NSString*) getExpireTime;
@end
