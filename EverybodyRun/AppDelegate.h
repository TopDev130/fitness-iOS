//
//  AppDelegate.h
//  EverybodyRun
//
//  Created by star on 1/28/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow                  *window;
@property (nonatomic, strong) CLLocationManager         *locationManager;
@property (nonatomic, strong) UINavigationController    *rootNavBar;
@property (nonatomic, strong) id                        startView;
@property (nonatomic, strong) id                        homeView;

+ (AppDelegate*) getDelegate;
- (void) startUpdatingLocation;
- (void) getAddressForLocation: (CLLocation*) location
                       success:(void(^)(NSString *address)) success
                       failure:(void(^)(void))failure;

- (void) updateCurrentUserLocation;

@end


