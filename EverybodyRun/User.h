//
//  User.h
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User : NSObject
{
    
}

@property (nonatomic, strong) NSNumber          *user_id;
@property (nonatomic, strong) NSString          *first_name;
@property (nonatomic, strong) NSString          *last_name;
@property (nonatomic, strong) NSString          *email;
@property (nonatomic, strong) NSString          *profile_photo;
@property (nonatomic, strong) NSNumber          *status;
@property (nonatomic, strong) NSNumber          *last_login;
@property (nonatomic, strong) NSNumber          *register_date;
@property (nonatomic, strong) NSNumber          *lat;
@property (nonatomic, strong) NSNumber          *lng;
@property (nonatomic, strong) NSString          *uuid;
@property (nonatomic, strong) NSNumber          *birthday;
@property (nonatomic, strong) NSNumber          *gender;
@property (nonatomic, strong) NSString          *location;

- (id) initWithDictionary: (NSDictionary*) dicUser;
- (id) initWithManageObject: (NSManagedObject*) objUser;
- (NSDate*) getBirthdate;

- (NSString*) getName;
- (NSString*) getAge;
- (NSString*) getGender;
@end
