//
//  ClusterAnnotation.h
//  EverybodyRun
//
//  Created by Marcin Robak on 7/10/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>
#import "QCluster.h"

@interface ClusterAnnotation : MGLPointAnnotation {
    
}
@property (nonatomic, retain) QCluster      *cluster;

@end
