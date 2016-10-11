//
//  MemberOnlyEvent.h
//  EverybodyRun
//
//  Created by star on 4/18/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberOnlyEvent : NSObject
{
    
}

@property (nonatomic, assign) int           event_id;
@property (nonatomic, retain) NSString      *title;
@property (nonatomic, retain) NSString      *address;
@property (nonatomic, assign) double        lat;
@property (nonatomic, assign) double        lng;
@property (nonatomic, retain) NSString      *event_description;
@property (nonatomic, retain) NSString      *url;
@property (nonatomic, retain) NSString      *email;
@property (nonatomic, retain) NSString      *img;
@property (nonatomic, assign) int           category_id;
@property (nonatomic, retain) NSString      *category_key;
@property (nonatomic, retain) NSString      *category_title;
@property (nonatomic, retain) NSString      *tel;

- (id) initWithDictionary: (NSDictionary*) dicItem;
@end
