//
//  NetworkClient.m
//  EverybodyRun
//
//  Created by star on 2/11/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "NetworkClient.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkClient

+ (NetworkClient*)sharedClient
{
    static NetworkClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *url = [NSURL URLWithString: kAPIBaseURLString];
        client = [[NetworkClient alloc] initWithBaseURL: url];
        
//        AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
//        [client setRequestSerializer:jsonRequestSerializer];
        
        //Response;
        AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
        client.responseSerializer = responseSerializer;
    });
    
    return client;
}

- (void) signRequest:(NSMutableDictionary*) parameters
{
    NSString* currentDateUTC = [NSString stringWithFormat: @"%f", [NSDate timeIntervalSinceReferenceDate]];
    NSString* stringForBake = [NSString stringWithFormat: @"%@%@", SECRET_KEY, currentDateUTC];
    
//    if(JUser.me.isAuthorized())
//    {
//        stringForBake = stringForBake + JUser.me.mSessToken
//        parameters.setObject(JUser.me.mUserId, forKey: "user_id")
//        parameters.setObject(JUser.me.mSessToken, forKey: "sess_token")
//    }
    
    NSString *signature = [AppEngine md5: stringForBake];
    [parameters setObject: signature forKey: @"signature"];
    [parameters setObject: currentDateUTC forKey: @"requesttime"];
}

- (void) GETRequest: (NSString *)URLString
         parameters: (nullable id)parameters
            success:(nullable void (^)(id responseObject))success
            failure:(nullable void (^)(NSError *error))failure
{
//    [self signRequest: parameters];
    [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void) PostRequest: (NSString *)URLString
         parameters: (nullable id)parameters
            success:(nullable void (^)(id responseObject))success
            failure:(nullable void (^)(NSError *error))failure
{
//    [self signRequest: parameters];
    
    [self POST: URLString
    parameters: parameters
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           success(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           failure(error);
       }];
}

- (void) signWithEmail: (NSString*) email
             firstName: (NSString*) firstName
              lastName: (NSString*) lastName
              birthday: (NSDate*) birthday
                gender: (int) gender
              password: (NSString*) password
                avatar: (NSString*) avatar
               success: (void (^)(id responseObject))success
               failure: (void (^)(NSError *error))failure
{
    int interval = [birthday timeIntervalSince1970];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       email, @"email",
                                       firstName, @"first_name",
                                       lastName, @"last_name",
                                       [NSNumber numberWithInt: interval], @"birthday",
                                       [NSNumber numberWithInt: gender], @"gender",
                                       password, @"password",
                                       [AppEngine getUUID], @"uuid",
                                       [AppEngine getValidString: avatar], @"avatar",
                                       [AppEngine getValidString: [AppEngine sharedInstance].currentDeviceToken], @"device_token",
                                       nil];
    
    [self PostRequest: @"user_api/register.php"
           parameters: parameters
              success:^(id responseObject) {
                 
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) uploadAvatar: (UIImage*) imgAvatar
              success: (void (^)(NSDictionary *responseObject))success
              failure: (void (^)(NSError *error))failure
{
    [self POST: @"user_api/upload_avatar.php"
    parameters: nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    if(imgAvatar)
    {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(imgAvatar, 1.0)
                                    name:@"photo"
                                fileName:@"image.jpg"
                                mimeType:@"image/jpeg"];
    }
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

    success(responseObject);
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(error);
}];
    
}

- (void) loginWithEmail: (NSString*) email
               password: (NSString*) password
                success: (void (^)(NSDictionary *responseObject))success
                failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       email, @"email",
                                       password, @"password",
                                       [AppEngine sharedInstance].currentDeviceToken, @"device_token",
                                       nil];

    
    [self PostRequest: @"user_api/login.php"
           parameters: parameters
              success:^(id responseObject) {
                 
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) loginWithFB: (NSString*) fbid
                name: (NSString*) name
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure
{
    NSString* firstName = [AppEngine getFirstName: name];
    NSString* lastName = [AppEngine getLastName: name];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       fbid, @"fb_id",
                                       firstName, @"first_name",
                                       lastName, @"last_name",
                                       [AppEngine getUUID], @"uuid",
                                       [AppEngine sharedInstance].currentDeviceToken, @"device_token",                                       
                                       nil];
    
    
    [self PostRequest: @"user_api/login_facebook.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) forgotPassword: (NSString*) email
                success: (void (^)(NSDictionary *responseObject))success
                failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       email, @"email",
                                       nil];
    
    
    [self PostRequest: @"user_api/forgotpassword.php"
           parameters: parameters
              success:^(id responseObject) {
                  success(responseObject);
              } failure:^(NSError *error) {
                  failure(error);
              }];
}

- (void) updateUserLocation: (User*) user
                    success: (void (^)(void))success
                    failure: (void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user.user_id, @"user_id",
                                       nil];

    [parameters setValue: user.lat forKey: @"lat"];
    [parameters setValue: user.lng forKey: @"lng"];
    
    if(user.location != nil) {
        [parameters setValue: user.location forKey: @"location"];
    }
    
    [self PostRequest: @"user_api/update_profile.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  NSDictionary* dicUser = responseObject[@"data"][@"user"];
                  if(dicUser != nil) {
                      success();
                  }
                  else {
                      failure(nil);
                  }
                  
              } failure:^(NSError *error) {
                  failure(error);
              }];

}

- (void) updateUser: (NSNumber*) user_id
          firstName: (NSString*) firstName
           lastName: (NSString*) lastName
              email: (NSString*) email
           birthday: (NSDate*) birthday
             gender: (int) gender
             avatar: (NSString*) avatar
            success: (void (^)(User *u))success
            failure: (void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user_id, @"user_id",
                                       nil];
    
    if(firstName != nil) {
        [parameters setValue: firstName forKey: @"first_name"];
    }

    if(lastName != nil) {
        [parameters setValue: lastName forKey: @"last_name"];
    }

    if(email != nil) {
        [parameters setValue: email forKey: @"email"];
    }

    if(birthday != nil) {
        [parameters setValue: [NSNumber numberWithInt: [birthday timeIntervalSince1970]] forKey: @"birthday"];
    }
    
    if(gender > 0) {
        [parameters setValue: [NSNumber numberWithInt: gender] forKey: @"gender"];
    }
    
    if(avatar != nil) {
        [parameters setValue: avatar forKey: @"profile_photo"];
    }
    
    [self PostRequest: @"user_api/update_profile.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  NSDictionary* dicUser = responseObject[@"data"][@"user"];
                  if(dicUser != nil) {
                      User* u = [[User alloc] initWithDictionary: dicUser];
                      success(u);
                  }
                  else {
                      failure(nil);
                  }
                  
              } failure:^(NSError *error) {
                  failure(error);
              }];
}


#pragma mark - Event.

- (void) uploadEventImage: (UIImage*) imgEvent
                  success: (void (^)(NSDictionary *responseObject))success
                  failure: (void (^)(NSError *error))failure
{
    [self POST: @"event_api/upload_photo.php"
    parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if(imgEvent)
        {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(imgEvent, 1.0)
                                        name:@"photo"
                                    fileName:@"image.jpg"
                                    mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
    {
        success(responseObject);
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           failure(error);
       }];
}


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
             failure: (void (^)(NSError *error))failure
{
    NSString* mapPointString = [map_points componentsJoinedByString: @"#"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       name, @"name",
                                       address, @"address",
                                       [NSNumber numberWithDouble: lat], @"lat",
                                       [NSNumber numberWithDouble: lng], @"lng",
                                       mapPointString, @"map_points",
                                       [NSNumber numberWithInt: expire_date], @"expire_date",
                                       [NSNumber numberWithInt: type], @"type",
                                       [NSNumber numberWithInt: level_min], @"level_min",
                                       [NSNumber numberWithInt: level_max], @"level_max",
                                       [NSNumber numberWithFloat: distance], @"distance",
                                       [NSNumber numberWithInt: distance_unit], @"distance_unit",
                                       [NSNumber numberWithInt: visibility], @"visibility",
                                       note, @"note",
                                       website, @"website",
                                       [NSNumber numberWithInt: snap_to_road], @"snap_to_road",
                                       [NSNumber numberWithInt: allow_invite_request], @"allow_invite_request",
                                       [NSNumber numberWithInt: [post_user_id intValue]], @"post_user_id",                                       
                                       main_image, @"main_image",
                                       nil];
    
    
    [self PostRequest: @"event_api/post_event.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) getEventsByDistance: (float) lat
                         lng: (float) lng
                     user_id: (NSNumber*) user_id
                     success: (void (^)(NSDictionary *responseObject))success
                     failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithFloat: lat], @"lat",
                                       [NSNumber numberWithFloat: lng], @"lng",
                                       nil];
    
    if(user_id != nil) {
        [parameters setObject:user_id forKey: @"user_id"];
    }
    
    [self PostRequest: @"event_api/get_events.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) getSingleEvent: (int) event_id
                user_id: (NSNumber*) user_id
                success: (void (^)(NSDictionary *dicEvent))success
                failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt: event_id], @"event_id",
                                       user_id, @"user_id",
                                       nil];
    
    [self PostRequest: @"event_api/get_single_event.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  BOOL successStatus = [[responseObject valueForKey: @"success"] boolValue];
                  if(successStatus)
                  {
                      NSDictionary* dicEvent = [responseObject valueForKey: @"event"];
                      success(dicEvent);
                  }
                  else
                  {
                      failure(nil);
                  }
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) getMyEvents: (NSNumber*) user_id
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user_id, @"user_id",
                                       nil];
    [self PostRequest: @"event_api/get_my_events.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) updateEvent: (Event*) e
             user_id: (NSNumber*) user_id
              reason: (NSString*) reason
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure
{
    NSString* mapPointString = [e.map_points componentsJoinedByString: @"#"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user_id, @"user_id",
                                       reason, @"reason",
                                       e.event_id, @"event_id",
                                       e.name, @"name",
                                       e.address, @"address",
                                       [NSNumber numberWithFloat: e.lat], @"lat",
                                       [NSNumber numberWithFloat: e.lng], @"lng",
                                       mapPointString, @"map_points",
                                       [NSNumber numberWithInt: e.expire_date], @"expire_date",
                                       [NSNumber numberWithInt: e.type], @"type",
                                       [NSNumber numberWithInt: e.level_min], @"level_min",
                                       [NSNumber numberWithInt: e.level_max], @"level_max",                                       
                                       [NSNumber numberWithFloat: e.distance], @"distance",
                                       [NSNumber numberWithInt: e.distance_unit], @"distance_unit",
                                       [NSNumber numberWithInt: e.visibility], @"visibility",
                                       e.note, @"note",
                                       [NSNumber numberWithInt: e.allow_invite_request], @"allow_invite_request",
                                       e.main_image, @"main_image",
                                       nil];
    
    
    [self PostRequest: @"event_api/update_event.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) updatedAskedExpire: (Event*) e
                    success: (void (^)(NSDictionary *responseObject))success
                    failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithBool: e.is_asked_expire], @"is_asked_expire",
                                       e.event_id, @"event_id",
                                       nil];
    
    
    [self PostRequest: @"event_api/update_asked_expire.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) deleteEvent: (Event*) e
             user_id: (NSNumber*) user_id
              reason: (NSString*) reason
             success: (void (^)(NSDictionary *responseObject))success
             failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user_id, @"user_id",
                                       e.event_id, @"event_id",
                                       e.name, @"event_name",
                                       reason, @"reason",
                                       nil];
    
    
    [self PostRequest: @"event_api/delete_event.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

#pragma mark Attend.

- (void) attendeeEvent: (Event*) e
          post_user_id: (NSNumber*) post_user_id
               success: (void (^)(NSDictionary *responseObject))success
               failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       e.event_id, @"event_id",
                                       post_user_id, @"user_id",
                                       nil];
    
    
    [self PostRequest: @"attendee_api/post_attendee.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) getAttendeeForEvent: (Event*) e
                     user_id: (NSNumber*) user_id
                     success: (void (^)(NSDictionary *responseObject))success
                     failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       e.event_id, @"event_id",
                                       user_id, @"user_id",
                                       nil];
    
    [self PostRequest: @"attendee_api/get_attend.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) getAttendedUserList: (Event*) e
                     success: (void (^)(NSDictionary *responseObject))success
                     failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       e.event_id, @"event_id",
                                       e.post_user_id, @"post_user_id",
                                       nil];
    
    [self PostRequest: @"attendee_api/get_attended_userlist.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) getMyAttendees: (NSNumber*) user_id
                success: (void (^)(NSDictionary *responseObject))success
                failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user_id, @"user_id",
                                       nil];
    
    [self PostRequest: @"attendee_api/get_my_attend.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) deleteAttend: (Event*) e
              user_id: (NSNumber*) user_id
              success: (void (^)(NSDictionary *responseObject))success
              failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user_id, @"user_id",
                                       e.event_id, @"event_id",
                                       nil];
    
    [self PostRequest: @"attendee_api/delete_attend.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

#pragma mark - Attend Images.

- (void) getAttendImages: (Event*) e
                 success: (void (^)(NSDictionary *responseObject))success
                 failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       e.event_id, @"event_id",
                                       nil];
    
    [self PostRequest: @"attend_images/get_attend_images.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  success(responseObject);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) uploadAttendImage: (NSString*) imageURL
                   user_id: (NSNumber*) user_id
                     event: (Event*) e
                   success: (void (^)(NSDictionary *responseObject))success
                   failure: (void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      imageURL, @"image_url",
                                      e.event_id, @"event_id",
                                      user_id, @"user_id",
                                      nil];

    [self PostRequest: @"attend_images/post_attend_image.php"
          parameters: parameters
             success:^(id responseObject) {
                 
                 success(responseObject);
                 
             } failure:^(NSError *error) {
                 
                 failure(error);
             }];
}

#pragma mark - Shop.
- (void) getAllShops: (void (^)(NSArray *results))success
             failure: (void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"https://cieleathletics.com/wp-json/ciele/v1/stores/list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([responseObject valueForKey: @"stores"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(error);
    }];
}

#pragma mark - Blogs.

- (void) getBlogList: (void (^)(NSArray* items))success
             failure: (void (^)(NSString *errorMessage))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager GET:@"https://cieleathletics.com/wp-json/wp/v2/posts" parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray* result = [[NSMutableArray alloc] init];
        
        NSArray* arrResults = responseObject;
        if(arrResults != nil && [arrResults isKindOfClass: [NSArray class]] && [arrResults count] > 0)
        {
            for (NSDictionary* dicItem in arrResults) {
                Blog* b = [[Blog alloc] initWithDictionary: dicItem];
                [result addObject: b];
            }
            success(result);
        }
        else
        {
            failure(@"empty blogs.");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(error.description);
     }];
}

- (void) getBlogs: (float) lat
              lng: (float) lng
          success: (void (^)(Blog* b))success
          failure: (void (^)(NSString *errorMessage))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: lat], @"lat",
                              [NSNumber numberWithFloat: lng], @"lng",
                              nil];
    
    [manager GET:@"https://cieleathletics.com/wp-json/ciele/v1/events" parameters: params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray* arrResults = responseObject;
        if(arrResults != nil && [arrResults isKindOfClass: [NSArray class]] && [arrResults count] > 0)
        {
            NSDictionary* dicBlog = [arrResults firstObject];
            Blog* b = [[Blog alloc] initWithDictionary: dicBlog];
            success(b);
        }
        else
        {
            failure(@"empty blogs.");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(error.description);
     }];
}

- (void) getBlogImage: (NSString*) mediaURL
              success: (void (^)(NSString* url))success
              failure: (void (^)(NSString *errorMessage))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET: mediaURL parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary* guid = responseObject[@"guid"];
        NSString* rendered = guid[@"rendered"];
        success(rendered);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(error.description);
     }];
}

#pragma mark - Member Only Events.
- (void) getMemberOnlyEvents: (void (^)(NSArray* array))success
                     failure: (void (^)(NSString *errorMessage))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET: kMemberEventURL parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray* locations = responseObject[@"locations"];
         if(locations != nil && [locations isKindOfClass: [NSArray class]])
         {
             NSMutableArray* arrResults = [NSMutableArray array];
             for(NSDictionary* dicItem in locations)
             {
                 MemberOnlyEvent* e = [[MemberOnlyEvent alloc] initWithDictionary: dicItem];
                 [arrResults addObject: e];
             }
             
             success(arrResults);
         }
         else
         {
             success(nil);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(error.description);
     }];
}

#pragma mark - Notifications

- (void) getNotifications: (NSNumber*) user_id
                  success: (void (^)(NSArray *array))success
                  failure: (void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       user_id, @"user_id",
                                       nil];
    
    [self PostRequest: @"notification_api/get_notifications.php"
           parameters: parameters
              success:^(id responseObject) {
                  
                  NSMutableArray* result = [[NSMutableArray alloc] init];
                  NSArray* notifications = responseObject[@"data"][@"notifications"];
                  if(notifications) {
                      for(NSDictionary* item in notifications) {
                          Notification* n = [[Notification alloc] initWithDictionary: item];
                          [result addObject: n];
                      }
                  }
                  
                  success(result);
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) deleteNotification: (int) notification_id
                    success: (void (^)(void))success
                    failure: (void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt: notification_id], @"id",
                                       nil];
    
    [self PostRequest: @"notification_api/delete_notification.php"
           parameters: parameters
              success:^(id responseObject) {
                  success();
                  
              } failure:^(NSError *error) {
                  
                  failure(error);
              }];
}

- (void) cancelAllRequest
{
    [self.operationQueue cancelAllOperations];
}

@end
