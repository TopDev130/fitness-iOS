//
//  Notification.m
//  EverybodyRun
//
//  Created by Marcin Robak on 6/4/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (id) initWithDictionary: (NSDictionary*) dicItem {
    
    if(self = [super init]){
        self.notification_id = [dicItem[@"id"] intValue];
        self.message = dicItem[@"message"];
        self.event_id = [dicItem[@"event_id"] intValue];
        self.type = [dicItem[@"type"] intValue];
        self.user_id = [dicItem[@"user_id"] intValue];
        self.register_date = [dicItem[@"register_date"] intValue];
    }
    return self;
}
@end
