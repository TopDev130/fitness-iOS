//
//  MemberOnlyEventAnnotation.m
//  EverybodyRun
//
//  Created by star on 4/18/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "MemberOnlyEventAnnotation.h"

@implementation MemberOnlyEventAnnotation

- (id) initWithEvent: (MemberOnlyEvent*) e
{
    self = [super init];
    if (self) {
        self.event = e;
        self.coordinate = [[CLLocation alloc] initWithLatitude: e.lat longitude: e.lng].coordinate;
        self.title = @"";
    }
    return self;
}

- (UIImage*) getIconForAnnotation {
    switch (self.event.category_id) {
        //Food
        case FILTER_FOOD:
            return [UIImage imageNamed: @"food_icon"];
            break;
            
        //Beverage
        case FILTER_BEVERAGE:
            return [UIImage imageNamed: @"beverage_icon"];
            break;
            
        //Health
        case FILTER_HEALTH:
            return  [UIImage imageNamed: @"health_icon"];
            break;
            
        //Clubs
        case FILTER_CLUBS:
            return [UIImage imageNamed: @"club_icon"];
            break;
            
        //Coaches
        case FILTER_COACHES:
            return [UIImage imageNamed: @"coaches_icon"];
            break;
            
        //Happenings
        case FILTER_HAPPENINGS:
            return [UIImage imageNamed: @"happiness_icon"];
            break;
            
        default:
            break;
    }
    
    return [UIImage imageNamed:@"food_icon"];
}

- (UIImage*) getDoubleIconForAnnotation {
    
    switch (self.event.category_id) {
        //Food
        case FILTER_FOOD:
            return [UIImage imageNamed: @"food_double_icon"];
            break;
            
        //Beverage
        case FILTER_BEVERAGE:
            return [UIImage imageNamed: @"beverage_double_icon"];
            break;
            
        //Health
        case FILTER_HEALTH:
            return  [UIImage imageNamed: @"health_double_icon"];
            break;
            
        //Clubs
        case FILTER_CLUBS:
            return [UIImage imageNamed: @"club_double_icon"];
            break;
            
        //Coaches
        case FILTER_COACHES:
            return [UIImage imageNamed: @"coaches_double_icon"];
            break;
            
        //Happenings
        case FILTER_HAPPENINGS:
            return [UIImage imageNamed: @"happiness_double_icon"];
            break;
            
        default:
            break;
    }
    
    return [UIImage imageNamed:@"run_icon"];
}

- (NSString*) getIdentifier {
    
    if(self.isSelected) {
        switch (self.event.category_id) {
                //Food
            case FILTER_FOOD:
                return @"food_double_icon";
                break;
                
                //Beverage
            case FILTER_BEVERAGE:
                return @"beverage_double_icon";
                break;
                
                //Health
            case FILTER_HEALTH:
                return  @"health_double_icon";
                break;
                
                //Clubs
            case FILTER_CLUBS:
                return @"club_double_icon";
                break;
                
                //Coaches
            case FILTER_COACHES:
                return @"coaches_double_icon";
                break;
                
                //Happenings
            case FILTER_HAPPENINGS:
                return @"happiness_double_icon";
                break;
                
            default:
                break;
        }
    }
    else {
        switch (self.event.category_id) {
                //Food
            case FILTER_FOOD:
                return @"food_icon";
                break;
                
                //Beverage
            case FILTER_BEVERAGE:
                return @"beverage_icon";
                break;
                
                //Health
            case FILTER_HEALTH:
                return  @"health_icon";
                break;
                
                //Clubs
            case FILTER_CLUBS:
                return @"club_icon";
                break;
                
                //Coaches
            case FILTER_COACHES:
                return @"coaches_icon";
                break;
                
                //Happenings
            case FILTER_HAPPENINGS:
                return @"happiness_icon";
                break;
                
            default:
                break;
        }
    }
    
    return @"food_icon";
}

@end
