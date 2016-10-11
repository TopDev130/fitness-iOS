//
//  CoreHelper.m
//  Salon01
//
//  Created by jian on 7/28/15.
//  Copyright (c) 2015 jian. All rights reserved.
//

#import "CoreHelper.h"
#import <CoreData/CoreData.h>

@implementation CoreHelper
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//====================================================================================================
+ (CoreHelper*)sharedInstance
{
    static CoreHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreHelper alloc] init];
    });
    return sharedInstance;
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

//====================================================================================================
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.

//====================================================================================================
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.

//====================================================================================================
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GlobalMission.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

//====================================================================================================
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//====================================================================================================
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark Global.

//====================================================================================================
- (void) logout
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Global"
                                        inManagedObjectContext:context]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        
    }
    else
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"Global" inManagedObjectContext:context];
    }
    
    [object setValue: @"" forKey:@"current_user_id"];
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (void) saveSettingsInfo: (int) mapType distanceUnit: (int) distanceUnit watermarkEnabled: (BOOL) watermarkEnabled
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Global"
                                        inManagedObjectContext:context]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0) {
        object = [results firstObject];
    } else {
        object = [NSEntityDescription insertNewObjectForEntityForName: @"Global" inManagedObjectContext: context];
    }
    
    [object setValue: [NSNumber numberWithInt: mapType] forKey:@"map_type"];
    [object setValue: [NSNumber numberWithInt: distanceUnit] forKey:@"distance_unit"];
    [object setValue: [NSNumber numberWithBool: watermarkEnabled] forKey:@"watermark_enabled"];
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }

}

//====================================================================================================
- (void) saveLastUpdate:(NSDate *)date
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Global"
                                        inManagedObjectContext:context]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        [object setValue: date forKey:@"last_update"];
        
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else
        {
            
        }
    }
}

- (void) setOnBoard:(BOOL)isShowOnboard {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Global"
                                        inManagedObjectContext:context]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        
    }
    else
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"Global" inManagedObjectContext:context];
    }
    
    [object setValue: [NSNumber numberWithBool: isShowOnboard] forKey:@"is_show_onboard"];
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}
//====================================================================================================
- (void) setCurrentUserId: (NSNumber*) user_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Global"
                                        inManagedObjectContext:context]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        
    }
    else
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"Global" inManagedObjectContext:context];
    }
    
    [object setValue: user_id forKey:@"current_user_id"];
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (NSManagedObject*) getGlobalInfo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Global"
                                        inManagedObjectContext:context]];
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    
    if([results count] > 0)
    {
        return [results firstObject];
    }
    
    return nil;
}

#pragma mark User.

//====================================================================================================
- (void) addUser: (User*) u
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"User"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", u.user_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        
    }
    else
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    }
    
    [object setValue: u.user_id forKey:@"user_id"];
    [object setValue: u.first_name forKey:@"first_name"];
    [object setValue: u.last_name forKey:@"last_name"];
    [object setValue: u.email forKey:@"email"];
    [object setValue: u.profile_photo forKey:@"profile_photo"];
    [object setValue: [NSNumber numberWithInt: [u.status intValue]] forKey:@"status"];
    [object setValue: [NSNumber numberWithInt: [u.last_login intValue]] forKey:@"last_login"];
    [object setValue: [NSNumber numberWithInt: [u.register_date intValue]] forKey:@"register_date"];
    [object setValue: [NSNumber numberWithDouble: [u.lat doubleValue]] forKey:@"lat"];
    [object setValue: [NSNumber numberWithDouble: [u.lng doubleValue]] forKey:@"lng"];
    [object setValue: u.uuid forKey:@"uuid"];
    [object setValue: [NSNumber numberWithInt: [u.birthday intValue]] forKey:@"birthday"];
    [object setValue: [NSNumber numberWithInt: [u.gender intValue]] forKey:@"gender"];
    [object setValue: u.location forKey: @"location"];
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (NSManagedObject*) getUser: (NSNumber*) user_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"User"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", user_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    
    if([results count] > 0)
    {
        return [results firstObject];
    }
    
    return nil;
}

#pragma mark - Event.

//====================================================================================================
- (void) addEvent:(Event *)e
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"event_id == %@", e.event_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        
    }
    else
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    }
    
    [object setValue: e.event_id forKey:@"event_id"];
    [object setValue: e.name forKey:@"name"];
    [object setValue: e.address forKey:@"address"];
    [object setValue: [NSNumber numberWithFloat: e.lat] forKey:@"lat"];
    [object setValue: [NSNumber numberWithFloat: e.lng] forKey:@"lng"];
    [object setValue: [e.map_points componentsJoinedByString: @"#"] forKey:@"map_points"];
    [object setValue: [NSNumber numberWithInt: e.expire_date] forKey:@"expire_date"];
    [object setValue: [NSNumber numberWithInt: e.type] forKey:@"type"];
    [object setValue: [NSNumber numberWithInt: e.level_min] forKey:@"level_min"];
    [object setValue: [NSNumber numberWithInt: e.level_max] forKey:@"level_max"];
    [object setValue: [NSNumber numberWithFloat: e.distance] forKey:@"distance"];
    [object setValue: [NSNumber numberWithFloat: e.distance_unit] forKey:@"distance_unit"];
    [object setValue: [NSNumber numberWithInt: e.visibility] forKey:@"visibility"];
    [object setValue: e.note forKey:@"note"];
    [object setValue: [NSNumber numberWithBool: e.allow_invite_request] forKey:@"allow_invite_request"];
    [object setValue: e.main_image forKey:@"main_image"];
    [object setValue: e.post_user_id forKey:@"post_user_id"];
    [object setValue: [NSNumber numberWithInt: e.attendees] forKey:@"attendees"];
    [object setValue: [NSNumber numberWithInt: e.register_date] forKey:@"register_date"];
    [object setValue: [NSNumber numberWithBool: e.is_attended] forKey: @"is_attended"];
    [object setValue: [NSNumber numberWithBool: e.snap_to_road] forKey: @"snap_to_road"];
    [object setValue: e.website forKey: @"website"];
    [object setValue: [NSNumber numberWithBool: e.is_asked_expire] forKey: @"is_asked_expire"];
    
    //Post User.
    [object setValue: e.post_user_email forKey: @"email"];
    [object setValue: e.post_user_first_name forKey: @"first_name"];
    [object setValue: e.post_user_last_name forKey: @"last_name"];
    [object setValue: e.post_user_avatar forKey: @"profile_photo"];
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (void) updateEvent: (Event*) e
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"event_id == %@", e.event_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        [object setValue: e.event_id forKey:@"event_id"];
        [object setValue: e.name forKey:@"name"];
        [object setValue: e.address forKey:@"address"];
        [object setValue: [NSNumber numberWithFloat: e.lat] forKey:@"lat"];
        [object setValue: [NSNumber numberWithFloat: e.lng] forKey:@"lng"];
        [object setValue: [e.map_points componentsJoinedByString: @"#"] forKey:@"map_points"];
        [object setValue: [NSNumber numberWithInt: e.expire_date] forKey:@"expire_date"];
        [object setValue: [NSNumber numberWithInt: e.type] forKey:@"type"];
        [object setValue: [NSNumber numberWithInt: e.level_min] forKey:@"level_min"];
        [object setValue: [NSNumber numberWithInt: e.level_max] forKey:@"level_max"];
        [object setValue: [NSNumber numberWithFloat: e.distance] forKey:@"distance"];
        [object setValue: [NSNumber numberWithFloat: e.distance_unit] forKey:@"distance_unit"];
        [object setValue: [NSNumber numberWithInt: e.visibility] forKey:@"visibility"];
        [object setValue: e.note forKey:@"note"];
        [object setValue: [NSNumber numberWithBool: e.allow_invite_request] forKey:@"allow_invite_request"];
        [object setValue: e.main_image forKey:@"main_image"];
        [object setValue: e.post_user_id forKey:@"post_user_id"];
        [object setValue: [NSNumber numberWithInt: e.attendees] forKey:@"attendees"];
        [object setValue: [NSNumber numberWithInt: e.register_date] forKey:@"register_date"];
        [object setValue: [NSNumber numberWithBool: e.is_attended] forKey: @"is_attended"];
        [object setValue: [NSNumber numberWithBool: e.snap_to_road] forKey: @"snap_to_road"];
        [object setValue: e.website forKey: @"website"];
        [object setValue: [NSNumber numberWithBool: e.is_asked_expire] forKey: @"is_asked_expire"];
        
        //Post User.
        [object setValue: e.post_user_email forKey: @"email"];
        [object setValue: e.post_user_first_name forKey: @"first_name"];
        [object setValue: e.post_user_last_name forKey: @"last_name"];
        [object setValue: e.post_user_avatar forKey: @"profile_photo"];
    }

    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (NSArray*) loadEvents
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:context]];
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    return results;
}

//====================================================================================================
- (NSArray*) getMyEvents: (NSNumber*) user_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"post_user_id == %@", user_id]];
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    return results;
}

//====================================================================================================
- (NSArray*) getAttendedEvents: (NSNumber*) user_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Attendee"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", user_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    
    if(results == nil)
    {
        return nil;
    }
    
    NSMutableArray* arrEventList = [[NSMutableArray alloc] init];
    for(NSManagedObject* obj in results)
    {
        [arrEventList addObject: [obj valueForKey: @"event_id"]];
    }
    
    NSFetchRequest * fetchEventRequest = [[NSFetchRequest alloc] init];
    [fetchEventRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:context]];
    [fetchEventRequest setPredicate:[NSPredicate predicateWithFormat:@"event_id IN %@", arrEventList]];
    NSArray* resultEvent = [context executeFetchRequest: fetchEventRequest error: &error];
    
    return resultEvent;
}


//====================================================================================================
- (void) deleteEvent: (int) event_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject* obj = [self getEvent: [NSNumber numberWithInt: event_id]];
    
    if(obj != nil)
    {
        [context deleteObject: obj];
    }

    // Save the object to persistent store
    NSError * error;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (void) deleteAllEvents
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:context]];
    
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    
    if(results != nil)
    {
        for(NSManagedObject* obj in results)
        {
            [context deleteObject: obj];
        }
    }
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (NSManagedObject*) getEvent:(NSNumber *)eventId
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"event_id == %@", eventId]];

    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    if(results != nil && [results count] > 0)
    {
        return [results firstObject];
    }
    
    return nil;
}

//====================================================================================================
- (void) addAttendee: (Attendee*) attendee
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Attendee"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"attendee_id == %@", attendee.attendee_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        
    }
    else
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"Attendee" inManagedObjectContext:context];
    }
    
    [object setValue: attendee.attendee_id forKey:@"attendee_id"];
    [object setValue: attendee.event_id forKey:@"event_id"];
    [object setValue: attendee.user_id forKey:@"user_id"];
    [object setValue: attendee.register_date forKey:@"register_date"];
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (NSManagedObject*) getAttendee: (NSNumber*) attendee_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Attendee"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"attendee_id == %@", attendee_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    if(results != nil && [results count] > 0)
    {
        return [results firstObject];
    }
    
    return nil;

}

//====================================================================================================
- (NSManagedObject*) getAttendeeForEvent: (NSNumber*) event_id user_id: (NSNumber*) user_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Attendee"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"event_id == %@ and user_id == %@", event_id, user_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    if(results != nil && [results count] > 0)
    {
        return [results firstObject];
    }
    
    return nil;
}

//====================================================================================================
- (NSArray*) getAttendeedUserList: (Event*) e
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Attendee"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"event_id == %@", e.event_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    
    NSMutableArray* arrUserList = [[NSMutableArray alloc] init];
    if(results != nil)
    {
        for(NSManagedObject* obj in results)
        {
            NSString* user_id = [obj valueForKey: @"user_id"];
            [arrUserList addObject: user_id];
        }
    }
    
    if([arrUserList count] == 0) return nil;
    NSFetchRequest * fetchUserRequest = [[NSFetchRequest alloc] init];
    [fetchUserRequest setEntity:[NSEntityDescription entityForName:@"User"
                                        inManagedObjectContext:context]];
    [fetchUserRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id IN %@", arrUserList]];
    
    NSArray* userResults = [context executeFetchRequest: fetchUserRequest error: &error];
    return userResults;
}

//====================================================================================================
- (void) deleteAllAttendees
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Attendee"
                                        inManagedObjectContext:context]];
    
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    if(results != nil)
    {
        for(NSManagedObject* obj in results)
        {
            [context deleteObject: obj];
        }
    }
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (void) deleteAttendWithId: (NSNumber*) attendee_id
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject* obj = [self getAttendee: attendee_id];
    if(obj != nil)
    {
        [context deleteObject: obj];
    }
    
    // Save the object to persistent store
    NSError * error;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

#pragma mark - Shop.

//====================================================================================================
- (void) addShop: (Shop*) s
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Shop"
                                        inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"shop_id == %@", s.shop_id]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    NSManagedObject* object;
    if ([results count] > 0)
    {
        object = [results firstObject];
        
    }
    else
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"Shop" inManagedObjectContext:context];
    }
    
    [object setValue: s.shop_id forKey:@"shop_id"];
    [object setValue: s.name forKey:@"name"];
    [object setValue: s.address forKey:@"address"];
    [object setValue: s.address2 forKey:@"address2"];
    [object setValue: s.city forKey:@"city"];
    [object setValue: s.state forKey:@"state"];
    [object setValue: s.zip forKey:@"zip"];
    [object setValue: s.country forKey:@"country"];
    [object setValue: s.country_iso forKey:@"country_iso"];
    [object setValue: s.lat forKey:@"lat"];
    [object setValue: s.lng forKey:@"lng"];
    [object setValue: s.shop_description forKey:@"shop_description"];
    [object setValue: s.phone forKey:@"phone"];
    [object setValue: s.fax forKey:@"fax"];
    [object setValue: s.url forKey:@"url"];
    [object setValue: s.email forKey:@"email"];
    [object setValue: s.hours forKey:@"hours"];
    [object setValue: s.is_select forKey: @"is_select"];
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
- (NSArray*) getAllShops
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Shop"
                                        inManagedObjectContext:context]];
    
    // if get a entity, that means exists, so fetch it.
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    
    return results;
}

//====================================================================================================
- (void) deleteAllShops
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Shop"
                                        inManagedObjectContext:context]];
    
    NSError * error;
    NSArray* results = [context executeFetchRequest: fetchRequest error: &error];
    if(results != nil)
    {
        for(NSManagedObject* obj in results)
        {
            [context deleteObject: obj];
        }
    }
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        
    }
}

//====================================================================================================
@end
