#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>

@interface BasicMapAnnotation : MGLPointAnnotation
{
	NSString                *_mKey;
}

@property (nonatomic, retain) NSString          *mKey;
@property (nonatomic, assign) int               mIndex;
@property (nonatomic, retain) NSNumber          *mDistance;
@property (nonatomic, assign) BOOL              hidden;
@property (nonatomic, copy) NSString            *title;
@property (nonatomic, copy) NSString            *subtitle;
@property (nonatomic) CLLocationDegrees         latitude;
@property (nonatomic) CLLocationDegrees         longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
