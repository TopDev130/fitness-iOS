//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

@import MapKit;
@class QCluster;

@interface ClusterAnnotationView : UIView
{
    
}
@property(nonatomic, strong) QCluster* cluster;
+(NSString*)reuseId;
-(instancetype)initWithCluster:(QCluster*)cluster;

- (UIImage *)imageByRenderingView;
@end