//
//  AttendImage.h
//  EverybodyRun
//
//  Created by star on 3/11/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendImage : NSObject
{
    
}

@property (nonatomic, strong) NSURL         *image_url;
@property (nonatomic, assign) int           post_user_id;
@property (nonatomic, assign) int           event_id;
@property (nonatomic, assign) int           register_date;
@property (nonatomic, strong) NSString      *first_name;
@property (nonatomic, strong) NSString      *last_name;
@property (nonatomic, strong) NSString      *email;
@property (nonatomic, strong) NSString      *profile_photo;
@property (nonatomic, assign) BOOL          isMainImage;

- (id) initWithDictionary: (NSDictionary*) dicImage;
@end
