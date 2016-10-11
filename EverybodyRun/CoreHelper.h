//
//  CoreHelper.h
//  Salon01
//
//  Created by jian on 7/28/15.
//  Copyright (c) 2015 jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreHelper : NSObject
{
    
}
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (CoreHelper*)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObject*) getGlobalInfo;
- (void) setOnBoard: (BOOL) isShowOnboard;
- (void) setCurrentUserId: (NSNumber*) user_id;
- (void) saveSettingsInfo: (int) mapType distanceUnit: (int) distanceUnit watermarkEnabled: (BOOL) watermarkEnabled;
- (void) saveLastUpdate: (NSDate*) date;
- (void) addUser: (User*) u;
- (NSManagedObject*) getUser: (NSNumber*) user_id;
- (void) logout;

//Event.
- (void) addEvent: (Event*) e;
- (void) updateEvent: (Event*) e;
- (void) deleteEvent: (int) event_id;
- (void) deleteAllEvents;
- (NSArray*) loadEvents;
- (NSManagedObject*) getEvent: (NSNumber*) eventId;
- (NSArray*) getMyEvents: (NSNumber*) user_id;
- (NSArray*) getAttendedEvents: (NSNumber*) user_id;

//Shop
- (void) addShop: (Shop*) s;
- (NSArray*) getAllShops;
- (void) deleteAllShops;

////Attend.
//- (void) addAttendee: (Attendee*) attendee;
//- (NSManagedObject*) getAttendee: (NSNumber*) attendee_id;
//- (NSManagedObject*) getAttendeeForEvent: (NSNumber*) event_id user_id: (NSNumber*) user_id;
//- (NSArray*) getAttendeedUserList: (Event*) e;
//- (void) deleteAllAttendees;
//- (void) deleteAttendWithId: (NSNumber*) attendee_id;

@end
