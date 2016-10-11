//
//  EventAnnotation.h
//  EverybodyRun
//
//  Created by star on 2/3/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BaseEventAnnotation.h"

@interface EventAnnotation : BaseEventAnnotation
{
    
}

@property (nonatomic, retain) Event             *event;
- (id) initWithEvent: (Event*) e;
- (NSString*) getIdentiferString;

@end
