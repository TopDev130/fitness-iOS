//
//  MemberOnlyEventAnnotation.h
//  EverybodyRun
//
//  Created by star on 4/18/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BaseEventAnnotation.h"

@interface MemberOnlyEventAnnotation : BaseEventAnnotation
{
    
}

@property (nonatomic, retain) MemberOnlyEvent *event;
- (id) initWithEvent: (MemberOnlyEvent*) e;
- (NSString*) getIdentifier;
@end
