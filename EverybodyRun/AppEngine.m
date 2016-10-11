//
//  AppEngine.m
//  EverybodyRun
//
//  Created by star on 1/31/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "AppEngine.h"
#import <CommonCrypto/CommonDigest.h>
#import "BasicMapAnnotation.h"
#import <EventKit/EventKit.h>
#import "Branch.h"

@implementation AppEngine

//====================================================================================================
+ (AppEngine*)sharedInstance
{
    static AppEngine *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppEngine alloc] init];
    });
    
    return sharedInstance;
}

//====================================================================================================
+ (BOOL)emailValidate:(NSString *)strEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}

//====================================================================================================
+ (UIAlertController*) showMessage: (NSString*) message title: (NSString*) title
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil message: message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction: okAction];
    return alert;
}

//====================================================================================================
+ (UIAlertController*)showAlertWithText:(NSString*) message
{
    return [AppEngine showMessage: message title: @"Warnning"];
}

//====================================================================================================
+ (UIAlertController*)showErrorWithText:(NSString*) message
{
    return [AppEngine showMessage: message title: @"Error"];
}

//====================================================================================================
+ (NSString*) getValidString: (NSString*) value
{
    if(value == nil || [value isKindOfClass: [NSNull class]])
    {
        return @"";
    }
    return value;
}

+ (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

+ (NSString*) getUUID
{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

+ (NSString *)md5: (NSString*) string
{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (NSURL*) getImageURL: (NSString*) imageURL
{
    return [NSURL URLWithString: [NSString stringWithFormat: @"%@%@", kMediaBaseURL, imageURL]];
}


+ (NSString*) getSearchTagFromName: (NSString*) name
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9]*$" options:0 error:NULL];
    NSString *modifiedString = [regex stringByReplacingMatchesInString: name options:0 range:NSMakeRange(0, [name length]) withTemplate:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    return [NSString stringWithFormat: @"%@%@", SEARCH_TAG_PREFIX, modifiedString];
}

+ (NSString*) getTagFromName: (NSString*) name
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9]*$" options:0 error:NULL];
    NSString *modifiedString = [regex stringByReplacingMatchesInString: name options:0 range:NSMakeRange(0, [name length]) withTemplate:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    return [NSString stringWithFormat: @"%@%@", TAG_PREFIX, modifiedString];
}

+ (NSString*) getImageName
{
    NSDate *date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyyMMddHHmmssSSS"];
    NSString* name = [NSString stringWithFormat: @"donorsee%@", [formatter stringFromDate: date]];
    return name;
}

+ (NSString*) getFirstName: (NSString*) name
{
    if(name == nil || [name length] == 0) return @"";
    NSArray* array = [name componentsSeparatedByString: @" "];
    if(array != nil && [array count] >= 1)
    {
        return [array firstObject];
    }
    
    return @"";
}

+ (NSString*) getLastName: (NSString*) name
{
    if(name == nil || [name length] == 0) return @"";
    NSArray* array = [name componentsSeparatedByString: @" "];
    if(array != nil && [array count] >= 2)
    {
        return [array lastObject];
    }
    
    return @"";
}

#pragma mark - Map Pins.

+ (NSMutableArray*) sortAnnotations: (NSArray*) arrPins
{
    //First calculate polygon center
    CLLocationCoordinate2D centerPoint = [AppEngine calculateCenterPoint: arrPins];
    
    NSArray *sorted = [arrPins sortedArrayWithOptions: NSSortConcurrent | NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        double angle1 = [self angleBetween: ((MKPointAnnotation*)obj1).coordinate andPoint: centerPoint];
        double angle2 = [self angleBetween: ((MKPointAnnotation*)obj2).coordinate andPoint: centerPoint];
        
        if (angle1<angle2) {
            return NSOrderedDescending;
        }
        
        if(angle1>angle2) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
    }];
    
    NSMutableArray* arrResult = [sorted mutableCopy];
    return arrResult;
}

+ (CLLocationCoordinate2D) calculateCenterPoint: (NSArray*) arrPins
{
    CLLocationCoordinate2D coord;
    
    float avgLat =0;
    float avgLng =0;
    
    for(BasicMapAnnotation* annot in arrPins)
    {
        avgLat += annot.coordinate.latitude;
        avgLng += annot.coordinate.longitude;
    }
    
    float midLat = avgLat/arrPins.count;
    float midLng = avgLng/arrPins.count;
    coord.latitude = midLat;
    coord.longitude = midLng;
    return coord;
}

+ (double) angleBetween: (CLLocationCoordinate2D) point1 andPoint: (CLLocationCoordinate2D) point2
{
    double deltaX = point1.latitude - point2.latitude;
    double deltaY = point1.longitude - point2.longitude;
    
    double result = atan2(deltaY, deltaX) * 180 / M_PI;
    
    return result;
}


+ (float) getDistance: (CLLocation*) loc1 loc2: (CLLocation*) loc2
{
    CLLocationDistance meters = [loc1 distanceFromLocation:loc2];
    return meters / 1609.34;
}

+ (float) getDistanceForKM: (CLLocation*) loc1 loc2: (CLLocation*) loc2
{
    CLLocationDistance meters = [loc1 distanceFromLocation:loc2];
    return meters / 1000;
}

+ (void) addEventToCalendar: (Event*) e
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", [e.event_id intValue]], @"event_id", nil];
    [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
     {
         //Add Event in Calendar.
         EKEventStore *store = [EKEventStore new];
         [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
             if (!granted) { return; }
             
             EKEvent *event = [EKEvent eventWithEventStore:store];
             event.title = [NSString stringWithFormat: @"#everybodyrun %@", e.name];
             event.notes = @"Everybody Run Event";
             event.URL = [NSURL URLWithString: url];
             
             NSDate* startDate = [NSDate dateWithTimeIntervalSince1970: e.expire_date];
             
             event.startDate = startDate;
             event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
             event.calendar = [store defaultCalendarForNewEvents];
             NSError *err = nil;
             [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
             
             NSLog(@"calendar error = %@", err);
             NSString* localEventID = event.eventIdentifier;  //save the event id if you want to access this later
             
             NSLog(@"localEventID = %@", localEventID);
         }];
     }];
}

+ (NSString*) getOnlyPhoneNumbers: (NSString*) phoneString {
    NSString *newString = [[phoneString componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    
    return newString;
}

+ (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates: YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

+(UIImage*) createImageFromView:(UIView*)newt withSize:(CGSize)rensize {
    UIGraphicsBeginImageContextWithOptions(rensize,NO,2.0); //1.0 or 2.0 for retina (get it from UIScreen)
    [newt.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

+(UIImage*) createJPEGfromView:(UIView*)newt withSize:(CGSize)rensize toPath:  (NSString*)filePath quality:(float)quality{
    
    UIImage *ximage = [AppEngine createImageFromView:newt withSize:rensize];
    NSData *imageData = UIImageJPEGRepresentation(ximage, quality);
    
    if (filePath!=nil) {
        [imageData writeToFile:filePath atomically:YES];
    }
    return ximage;
    
}

+(CGFloat)retinaFactor {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] > 1){
        return [[UIScreen mainScreen]scale];
    } else {
        return 1.0f;
    }
}
@end
