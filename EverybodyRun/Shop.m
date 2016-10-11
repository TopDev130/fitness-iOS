//
//  Shop.m
//  EverybodyRun
//
//  Created by star on 2/22/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "Shop.h"

@implementation Shop

- (id) initWithDictionary: (NSDictionary*) dicShop
{
    self = [super init];
    if(self)
    {
        self.shop_id = [NSNumber numberWithInt: [[dicShop valueForKey: @"id"] intValue]];
        self.name = [AppEngine getValidString: [dicShop valueForKey: @"name"]];
        self.address = [AppEngine getValidString: [dicShop valueForKey: @"address"]];
        self.address2 = [AppEngine getValidString: [dicShop valueForKey: @"address2"]];
        self.city = [AppEngine getValidString: [dicShop valueForKey: @"city"]];
        self.state = [AppEngine getValidString: [dicShop valueForKey: @"state"]];
        self.zip = [AppEngine getValidString: [dicShop valueForKey: @"zip"]];
        self.country = [AppEngine getValidString: [dicShop valueForKey: @"country"]];
        self.country_iso = [AppEngine getValidString: [dicShop valueForKey: @"country_iso"]];
        self.lat = [NSNumber numberWithDouble: [[dicShop valueForKey: @"lat"] doubleValue]];
        self.lng = [NSNumber numberWithDouble: [[dicShop valueForKey: @"lng"] doubleValue]];
        self.shop_description = [AppEngine getValidString: [dicShop valueForKey: @"description"]];
        self.phone = [AppEngine getValidString: [dicShop valueForKey: @"phone"]];
        self.fax = [AppEngine getValidString: [dicShop valueForKey: @"fax"]];
        self.url = [AppEngine getValidString: [dicShop valueForKey: @"url"]];
        self.email = [AppEngine getValidString: [dicShop valueForKey: @"email"]];
        self.hours = [AppEngine getValidString: [dicShop valueForKey: @"hours"]];
        self.is_select = [NSNumber numberWithBool: [[dicShop valueForKey: @"is_select"] boolValue]];
        self.img = [AppEngine getValidString: [dicShop valueForKey: @"img"]];
    }
    return self;
}

- (id) initWithManageObject: (NSManagedObject*) objShop
{
    self = [super init];
    if(self)
    {
        self.shop_id = [objShop valueForKey: @"shop_id"];
        self.name = [objShop valueForKey: @"name"];
        self.address = [objShop valueForKey: @"address"];
        self.address2 = [objShop valueForKey: @"address2"];
        self.city = [objShop valueForKey: @"city"];
        self.state = [objShop valueForKey: @"state"];
        self.zip = [objShop valueForKey: @"zip"];
        self.country = [objShop valueForKey: @"country"];
        self.country_iso = [objShop valueForKey: @"country_iso"];
        self.lat = [objShop valueForKey: @"lat"];
        self.lng = [objShop valueForKey: @"lng"];
        self.shop_description = [objShop valueForKey: @"shop_description"];
        self.phone = [objShop valueForKey: @"phone"];
        self.fax = [objShop valueForKey: @"fax"];
        self.url = [objShop valueForKey: @"url"];
        self.email = [objShop valueForKey: @"email"];
        self.hours = [objShop valueForKey: @"hours"];
        self.is_select = [objShop valueForKey: @"is_select"];
        self.img = [AppEngine getValidString: [objShop valueForKey: @"img"]];
    }
    return self;
}

@end
