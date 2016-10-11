//
//  AppEngine.h
//  EverybodyRun
//
//  Created by star on 1/31/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppEngine : NSObject
{
    
}

@property (nonatomic, retain) User      *currentUser;

@property (nonatomic, assign) BOOL      locationServiceEnabled;
@property (nonatomic, assign) float     currentLatitude;
@property (nonatomic, assign) float     currentLongitude;
@property (nonatomic, retain) NSDate    *filterDate;

//Settings.
@property (nonatomic, assign) int       mapType;
@property (nonatomic, assign) int       distanceUnit;
@property (nonatomic, assign) BOOL      watermarkEnabled;

@property (nonatomic, retain) NSDate    *last_update;

@property (nonatomic, strong) NSString  *currentDeviceToken;

+ (AppEngine*) sharedInstance;
+ (BOOL) emailValidate:(NSString *)strEmail;
+ (NSString*) getValidString: (NSString*) value;
+ (UIAlertController*) showMessage: (NSString*) message title: (NSString*) title;
+ (UIAlertController*) showAlertWithText:(NSString*)message;
+ (UIAlertController*) showErrorWithText:(NSString*)message;
+ (NSString *)md5: (NSString*) string;
+ (NSString*) getUUID;
+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+ (NSURL*) getImageURL: (NSString*) imageURL;
+ (NSString*) getTagFromName: (NSString*) name;
+ (NSString*) getSearchTagFromName: (NSString*) name;
+ (NSString*) getFirstName: (NSString*) name;
+ (NSString*) getLastName: (NSString*) name;
+ (NSString*) getImageName;
+ (NSString*) getOnlyPhoneNumbers: (NSString*) phoneString;

+ (NSMutableArray*) sortAnnotations: (NSArray*) arrPins;
+ (CLLocationCoordinate2D) calculateCenterPoint: (NSArray*) arrPins;
+ (double) angleBetween: (CLLocationCoordinate2D) point1 andPoint: (CLLocationCoordinate2D) point2;
+ (float) getDistance: (CLLocation*) loc1 loc2: (CLLocation*) loc2;
+ (float) getDistanceForKM: (CLLocation*) loc1 loc2: (CLLocation*) loc2;

+ (void) addEventToCalendar: (Event*) e;
+ (BOOL) validateUrl: (NSString *) candidate;
+ (UIImage *) imageWithView:(UIView *)view;
+(UIImage*) createImageFromView:(UIView*)newt withSize:(CGSize)rensize;
@end
