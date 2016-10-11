//
//  Notification.h
//  EverybodyRun
//
//  Created by Marcin Robak on 6/4/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
{
    
}

@property (nonatomic, assign) int               notification_id;
@property (nonatomic, strong) NSString          *message;
@property (nonatomic, assign) int               event_id;
@property (nonatomic, assign) int               type;
@property (nonatomic, assign) int               user_id;
@property (nonatomic, assign) int               register_date;

- (id) initWithDictionary: (NSDictionary*) dicItem;
@end
