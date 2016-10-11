//
//  MemberOnlyEvent.m
//  EverybodyRun
//
//  Created by star on 4/18/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "MemberOnlyEvent.h"

@implementation MemberOnlyEvent

- (id) initWithDictionary: (NSDictionary*) dicItem
{
    if(self = [super init])
    {
        self.event_id = [dicItem[@"id"] intValue];
        self.title = dicItem[@"title"];
        self.address = dicItem[@"address"];
        
        //Lat
        if([dicItem[@"lat"] isKindOfClass: [NSNull class]])
        {
            self.lat = 0;
        }
        else
        {
            self.lat = [dicItem[@"lat"] doubleValue];
        }

        //Lng
        if([dicItem[@"lng"] isKindOfClass: [NSNull class]])
        {
            self.lng = 0;
        }
        else
        {
            self.lng = [dicItem[@"lng"] doubleValue];
        }

        self.event_description = dicItem[@"description"];
        self.url = dicItem[@"url"];
        self.email = dicItem[@"email"];
        self.img = dicItem[@"img"];
        self.tel = dicItem[@"tel"];
        
        //Category.
        NSDictionary* category = dicItem[@"category"];
        self.category_id = [category[@"id"] intValue];
        self.category_key = category[@"key"];
        self.category_title = category[@"title"];
        
        if([[self.category_key lowercaseString] isEqualToString: @"food"]) {
            self.category_id = FILTER_FOOD;
        }
        else if([[self.category_key lowercaseString] isEqualToString: @"beverage"]) {
            self.category_id = FILTER_BEVERAGE;
        }
        else if([[self.category_key lowercaseString] isEqualToString: @"health"]) {
            self.category_id = FILTER_HEALTH;
        }
        else if([[self.category_key lowercaseString] isEqualToString: @"coaches"]) {
            self.category_id = FILTER_COACHES;
        }
        else if([[self.category_key lowercaseString] isEqualToString: @"happenings"]) {
            self.category_id = FILTER_HAPPENINGS;
        }
        else if([[self.category_key lowercaseString] isEqualToString: @"clubs"]) {
            self.category_id = FILTER_CLUBS;
        }
    }
    
    return self;
}
@end
