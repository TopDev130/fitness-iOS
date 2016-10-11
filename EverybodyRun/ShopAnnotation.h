//
//  ShopAnnotation.h
//  EverybodyRun
//
//  Created by star on 2/22/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BaseEventAnnotation.h"

@interface ShopAnnotation : BaseEventAnnotation
{
    
}

@property (nonatomic, retain) Shop *shop;
- (id) initWithShop: (Shop*) s;
- (NSString*) getIdentifier;
@end


