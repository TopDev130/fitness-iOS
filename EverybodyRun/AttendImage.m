//
//  AttendImage.m
//  EverybodyRun
//
//  Created by star on 3/11/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "AttendImage.h"
#import "JAmazonS3ClientManager.h"
@implementation AttendImage

- (id) initWithDictionary: (NSDictionary*) dicImage
{
    self = [super init];
    if(self)
    {
        self.image_url = [NSURL URLWithString: [[JAmazonS3ClientManager defaultManager] getPathForPhoto: [dicImage valueForKey: @"image_url"]]];
        self.post_user_id = [[dicImage valueForKey: @"post_user_id"] intValue];
        self.event_id = [[dicImage valueForKey: @"event_id"] intValue];
        self.register_date = [[dicImage valueForKey: @"register_date"] intValue];
        
        self.first_name = [dicImage valueForKey: @"first_name"];
        self.last_name = [dicImage valueForKey: @"last_name"];
        self.email = [dicImage valueForKey: @"email"];
        self.profile_photo = [dicImage valueForKey: @"profile_photo"];
        
        self.isMainImage = NO;
    }
    
    return self;
}
@end
