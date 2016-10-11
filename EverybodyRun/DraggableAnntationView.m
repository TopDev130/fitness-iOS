//
//  DraggableAnntationView.m
//  EverybodyRun
//
//  Created by star on 7/26/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "DraggableAnntationView.h"



@implementation DraggableAnntationView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                                   size:(CGFloat)size
                                  index:(int)index
                               delegate:(id)delegate{
    self = [self initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.delegate = delegate;
        self.currentIndex = index;
        
        self.draggable = true;
        self.scalesWithViewingDistance = false;
        self.frame = CGRectMake(0, 0, size, size);
        if (index == 1) {
            self.backgroundColor = [UIColor greenColor];
        }
        else {
            self.backgroundColor = [UIColor redColor];
        }        
        
        self.layer.cornerRadius = size / 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.1;
    }
    return self;
}

- (void)setDragState:(MGLAnnotationViewDragState)dragState animated:(BOOL)animated {
    [super setDragState:dragState animated:animated];
    
    switch (dragState) {
        case MGLAnnotationViewDragStateStarting:
            printf("Starting");
            [self startDragging];
            break;
            
        case MGLAnnotationViewDragStateDragging:
            printf(".");
            break;
            
        case MGLAnnotationViewDragStateEnding:
        case MGLAnnotationViewDragStateCanceling:
            printf("Ending\n");
            [self endDragging];
            
            break;
            
        case MGLAnnotationViewDragStateNone:
            return;
    }
}

// When the user interacts with an annotation, animate opacity and scale changes.
- (void)startDragging {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
        self.layer.opacity = 0.8;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    } completion:nil];
}

- (void)endDragging {
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
        self.layer.opacity = 1;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(changedAnnotation:index:)]) {
        [self.delegate changedAnnotation: self.annotation.coordinate index: self.currentIndex];
    }
}

@end
