//
//  DraggableAnntationView.h
//  EverybodyRun
//
//  Created by star on 7/26/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Mapbox;

@protocol DraggableAnntationViewDelegate
@optional
- (void) changedAnnotation: (CLLocationCoordinate2D) location index: (int) index;
@end


@interface DraggableAnntationView : MGLAnnotationView {
    
}

@property (nonatomic, retain) id        delegate;
@property (nonatomic, assign) int       currentIndex;

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                                   size:(CGFloat)size
                                  index:(int)index
                               delegate:(id)delegate;
@end
