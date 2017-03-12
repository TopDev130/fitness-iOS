//
//  CreateEventViewController.h
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "ShareViewController.h"

@interface CreateEventViewController : ShareViewController
{
    
}

@property (nonatomic, assign) BOOL          isEditing;
@property (nonatomic, assign) BOOL          isView;
@property (nonatomic, retain) Event         *currentEvent;
@property (nonatomic, retain) id            parentView;
@property (nonatomic, assign) BOOL          isUpdate;

- (void) updateLocation: (NSMutableArray*) arrRoute address: (NSString*) address snap_to_road: (BOOL) snap_to_road;
@end
