//
//  BaseEventAnnotation.h
//  EverybodyRun
//
//  Created by star on 6/14/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>

@interface BaseEventAnnotation : MGLPointAnnotation
{
    
}

@property (nonatomic) CLLocationCoordinate2D    coordinate;
@property (nonatomic, copy) NSString            *title;
@property (nonatomic, copy) NSString            *subtitle;
@property (nonatomic, assign) BOOL              isSelected;

- (UIImage*) getIconForAnnotation;
- (UIImage*) getDoubleIconForAnnotation;
@end
