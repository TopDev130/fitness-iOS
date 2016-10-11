//
//  NetworkClient.h
//  EverybodyRun
//
//  Created by star on 2/11/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface NetworkClient : AFHTTPSessionManager
{
    
}

+ (NetworkClient*) sharedClient;
- (void) cancelAllRequest;

- (void) signWithEmail: (NSString*) email
             firstName: (NSString*) firstName
              lastName: (NSString*) lastName
              birthday: (NSDate*) birthday
                gender: (int) gender
              password: (NSString*) password
                avatar: (NSString*) avatar
               success: (void (^)(id responseObject))success
               failure: (void (^)(NSError *error))failure;

- (void) uploadAvatar: (UIImage*) imgAvatar
              success: (void (^)(NSDictionary *responseObject))success
              failure: (void (^)(NSError *error))failure;

- (void) loginWithEmail: (NSString*) email
               password: (NSString*) password
                success: (void (^)(NSDictionary *responseObject))success
                failure: (void (^)(NSError *error))failure;

- (void) loginWithFB: (NSString*) fbid
                name: (NSString*) name
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure;

- (void) forgotPassword: (NSString*) email
                success: (void (^)(NSDictionary *responseObject))success
                failure: (void (^)(NSError *error))failure;

- (void) updateUser: (NSNumber*) user_id
          firstName: (NSString*) firstName
           lastName: (NSString*) lastName
              email: (NSString*) email
           birthday: (NSDate*) birthday
             gender: (int) gender
             avatar: (NSString*) avatar
            success: (void (^)(User *u))success
            failure: (void (^)(NSError *error))failure;


- (void) updateUserLocation: (User*) user
                    success: (void (^)(void))success
                    failure: (void (^)(NSError *error))failure;


//Event.
- (void) uploadEventImage: (UIImage*) imgEvent
                  success: (void (^)(NSDictionary *responseObject))success
                  failure: (void (^)(NSError *error))failure;


- (void) createEvent: (NSString*) name
             address: (NSString*) address
                 lat: (double) lat
                 lng: (double) lng
          map_points: (NSArray*) map_points
         expire_date: (int) expire_date
                type: (int) type
           level_min: (int) level_min
           level_max: (int) level_max
            distance: (float) distance
       distance_unit: (int) distance_unit
          visibility: (int) visibility
                note: (NSString*) note
             website: (NSString*) website
        snap_to_road: (BOOL) snap_to_road
allow_invite_request: (BOOL) allow_invite_request
          main_image: (NSString*) main_image
        post_user_id: (NSNumber*) post_user_id
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure;

- (void) getEventsByDistance: (float) lat
                         lng: (float) lng
                     user_id: (NSNumber*) user_id
                     success: (void (^)(NSDictionary *responseObject))success
                     failure: (void (^)(NSError *error))failure;


- (void) getMyEvents: (NSNumber*) user_id
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure;

- (void) getSingleEvent: (int) event_id
                user_id: (NSNumber*) user_id
                success: (void (^)(NSDictionary *dicEvent))success
                failure: (void (^)(NSError *error))failure;


- (void) updateEvent: (Event*) e
             user_id: (NSNumber*) user_id
              reason: (NSString*) reason
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure;


- (void) updatedAskedExpire: (Event*) e
                    success: (void (^)(NSDictionary *responseObject))success
                    failure: (void (^)(NSError *error))failure;


- (void) deleteEvent: (Event*) e
             user_id: (NSNumber*) user_id
              reason: (NSString*) reason
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure;

//Attend
- (void) attendeeEvent: (Event*) e
          post_user_id: (NSNumber*) post_user_id
               success: (void (^)(NSDictionary *responseObject))success
               failure: (void (^)(NSError *error))failure;

- (void) getAttendeeForEvent: (Event*) e
                     user_id: (NSNumber*) user_id
                     success: (void (^)(NSDictionary *responseObject))success
                     failure: (void (^)(NSError *error))failure;

- (void) getAttendedUserList: (Event*) e
                     success: (void (^)(NSDictionary *responseObject))success
                     failure: (void (^)(NSError *error))failure;

- (void) getMyAttendees: (NSNumber*) user_id
                success: (void (^)(NSDictionary *responseObject))success
                failure: (void (^)(NSError *error))failure;

- (void) deleteAttend: (Event*) e
              user_id: (NSNumber*) user_id
              success: (void (^)(NSDictionary *responseObject))success
              failure: (void (^)(NSError *error))failure;

//Attend Images.
- (void) getAttendImages: (Event*) e
                 success: (void (^)(NSDictionary *responseObject))success
                 failure: (void (^)(NSError *error))failure;

- (void) uploadAttendImage: (NSString*) imageURL
                   user_id: (NSNumber*) user_id
                     event: (Event*) e
                   success: (void (^)(NSDictionary *responseObject))success
                   failure: (void (^)(NSError *error))failure;


//Shop
- (void) getAllShops: (void (^)(NSArray *results))success
             failure: (void (^)(NSError *error))failure;

//Blogs.
- (void) getBlogList: (void (^)(NSArray* items))success
             failure: (void (^)(NSString *errorMessage))failure;

- (void) getBlogs: (float) lat
              lng: (float) lng
          success: (void (^)(Blog* b))success
          failure: (void (^)(NSString *errorMessage))failure;

- (void) getBlogImage: (NSString*) mediaURL
              success: (void (^)(NSString* url))success
              failure: (void (^)(NSString *errorMessage))failure;

//Member Only Events.
- (void) getMemberOnlyEvents: (void (^)(NSArray* array))success
                     failure: (void (^)(NSString *errorMessage))failure;


//Notification.
- (void) getNotifications: (NSNumber*) user_id
                  success: (void (^)(NSArray *array))success
                  failure: (void (^)(NSError *error))failure;

- (void) deleteNotification: (int) notification_id
                    success: (void (^)(void))success
                    failure: (void (^)(NSError *error))failure;


@end
