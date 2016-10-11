//
//  Shop.h
//  EverybodyRun
//
//  Created by star on 2/22/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
{
    
}

@property (nonatomic, strong) NSNumber*         shop_id;
@property (nonatomic, strong) NSString*         name;
@property (nonatomic, strong) NSString*         address;
@property (nonatomic, strong) NSString*         address2;
@property (nonatomic, strong) NSString*         city;
@property (nonatomic, strong) NSString*         state;
@property (nonatomic, strong) NSString*         zip;
@property (nonatomic, strong) NSString*         country;
@property (nonatomic, strong) NSString*         country_iso;
@property (nonatomic, strong) NSNumber*         lat;
@property (nonatomic, strong) NSNumber*         lng;
@property (nonatomic, strong) NSString*         shop_description;
@property (nonatomic, strong) NSString*         phone;
@property (nonatomic, strong) NSString*         fax;
@property (nonatomic, strong) NSString*         url;
@property (nonatomic, strong) NSString*         email;
@property (nonatomic, strong) NSString*         hours;
@property (nonatomic, strong) NSNumber*         is_select;
@property (nonatomic, strong) NSString*         img;

- (id) initWithDictionary: (NSDictionary*) dicShop;
- (id) initWithManageObject: (NSManagedObject*) objShop;

@end
