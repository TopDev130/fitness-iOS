//
//  LocationViewController.h
//  EverybodyRun
//
//  Created by star on 2/2/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BaseViewController.h"

@interface LocationViewController : BaseViewController
{
    
}

@property (nonatomic, assign) int               locationType;
@property (nonatomic, strong) NSMutableArray    *arrRoute;
@property (nonatomic, strong) id                previousViewController;
@end
