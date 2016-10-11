//
//  ShopAnnotation.m
//  EverybodyRun
//
//  Created by star on 2/22/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "ShopAnnotation.h"

@implementation ShopAnnotation


- (id) initWithShop:(Shop *)s
{
    self = [super init];
    if (self) {
        self.shop = s;
        self.coordinate = [[CLLocation alloc] initWithLatitude: [s.lat doubleValue] longitude: [s.lng doubleValue]].coordinate;
        self.title = @"";
    }
    return self;
}

- (UIImage*) getIconForAnnotation {
    if([self.shop.is_select boolValue]) {
        return [UIImage imageNamed:@"retailer_selected_icon"];
    }
    else {
        return [UIImage imageNamed:@"retailer_icon"];
    }
}

- (UIImage*) getDoubleIconForAnnotation {
    if([self.shop.is_select boolValue]) {
        return [UIImage imageNamed: @"retailer_selected_icon_double"];
    }
    else {
        return [UIImage imageNamed: @"retailer_icon_double"];
    }
}

- (NSString*) getIdentifier {
    if(self.isSelected) {
        if([self.shop.is_select boolValue]) {
            return @"retailer_selected_icon_double";
        }
        else {
            return @"retailer_icon_double";
        }
    }
    else {
        if([self.shop.is_select boolValue]) {
            return @"retailer_selected_icon";
        }
        else {
            return @"retailer_icon";
        }
    }
}

@end
