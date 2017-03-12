//
//  LocationViewController.m
//  EverybodyRun
//
//  Created by star on 2/2/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"
#import "CreateEventViewController.h"
#import "AppDelegate.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import "CLPlacemark+HNKAdditions.h"
#import <Mapbox/Mapbox.h>
#import "DraggableAnntationView.h"

static NSString *const searchResultsCellIdentifier =  @"HNKDemoSearchResultsCellIdentifier";

@interface LocationViewController () <MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate, DraggableAnntationViewDelegate>
{
    NSMutableArray                      *arrSnapRoutes;
    NSMutableArray                      *arrSnapRoutesPoints;
    NSMutableArray                      *arrNormalRoutes;
    NSMutableArray                      *arrPins;
    BOOL                                isSnapToRoad;
    HNKGooglePlacesAutocompleteQuery    *searchQuery;
    NSArray                             *arrSearchResults;
    MGLMapView                          *mvMain;
}

//@property (nonatomic, weak) IBOutlet MKMapView               *mvMain;
@property (nonatomic, weak) IBOutlet UIView                  *viMapContainer;
@property (nonatomic, weak) IBOutlet UITableView             *tbList;
@property (nonatomic, weak) IBOutlet UISearchBar             *sbSearch;
@property (nonatomic, weak) IBOutlet UILabel                 *lbDistance;
@property (nonatomic, weak) IBOutlet UIButton                *btSnapToRoad;

@end

@implementation LocationViewController
@synthesize viMapContainer;
@synthesize sbSearch;
@synthesize tbList;
@synthesize lbDistance;
@synthesize btSnapToRoad;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    [mvMain addGestureRecognizer:lpgr];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeStyle:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSArray *styles = @[ @"streets", @"emerald", @"light", @"dark", @"satellite" ];
        NSString *currentStyle = [[mvMain.styleURL.lastPathComponent componentsSeparatedByString:@"-"] firstObject];
        NSUInteger index = [styles indexOfObject:currentStyle];
        if (index == styles.count - 1) {
            index = 0;
        } else {
            index += 1;
        }
        NSURL *newStyleURL = [[NSURL alloc] initWithString:
                              [NSString stringWithFormat:@"asset://styles/%@-v8.json", styles[index]]];
        mvMain.styleURL = newStyleURL;
    }
}


- (void) initMember
{
    [super initMember];
    
    arrPins = [[NSMutableArray alloc] init];
    arrSnapRoutes = [[NSMutableArray alloc] init];
    arrSnapRoutesPoints = [[NSMutableArray alloc] init];
    arrNormalRoutes = [[NSMutableArray alloc] init];
    
    lbDistance.layer.masksToBounds = YES;
    lbDistance.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    searchQuery = [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey: GOOGLE_PLACE_API_KEY];
    
    //Check Map Type.
    
    NSURL *styleURL;
    if([AppEngine sharedInstance].mapType == 0) {
        styleURL = [NSURL URLWithString: MAP_TYPE_DEFAULT_URL];
    }
    else {
        styleURL = [NSURL URLWithString: MAP_TYPE_SAT_URL];
    }

    CGRect rect = CGRectMake(viMapContainer.bounds.origin.x, viMapContainer.bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    mvMain = [[MGLMapView alloc] initWithFrame:rect styleURL:styleURL];
//    mvMain = [[MGLMapView alloc] initWithFrame:viMapContainer.bounds styleURL:styleURL];
    
    [mvMain setCenterCoordinate:CLLocationCoordinate2DMake([AppEngine sharedInstance].currentLatitude, [AppEngine sharedInstance].currentLongitude)
                        zoomLevel:MAP_ZOOM_LEVEL
                         animated:NO];
    mvMain.delegate = self;
    mvMain.userTrackingMode = MKUserTrackingModeFollow;
    mvMain.showsUserLocation = NO;
    
    [viMapContainer addSubview: mvMain];
    [viMapContainer addSubview:btSnapToRoad];
    [viMapContainer addSubview:tbList];


    if(_locationType == LOCATION_CURRENT)  ///
    {
        if([_arrRoute count] == 0)
        {
            BasicMapAnnotation* mAnnot = [[BasicMapAnnotation alloc] init];
            mAnnot.coordinate = [[CLLocation alloc] initWithLatitude: [AppEngine sharedInstance].currentLatitude longitude: [AppEngine sharedInstance].currentLongitude].coordinate;
            mAnnot.mIndex = 1;
            mAnnot.title = PIN_TOP_MESSAGE;
            mAnnot.hidden = NO;
            mAnnot.mKey = [NSString stringWithFormat: @"%@%d", LOCATION_PIN, 1];
            [arrPins addObject: mAnnot];
            [mvMain addAnnotation: mAnnot];
            [self updateAddress];
            
        }
    }

    [self initRoute];
    [self updateSnapToRoadUI];
}

- (void) initRoute
{
    if(_arrRoute != nil && [_arrRoute count] > 0)
    {
        //Set Safe Zone.
        for(int i = 0; i < [_arrRoute count]; i++)
        {
            NSString* strRecord = [_arrRoute objectAtIndex: i];
            NSArray* arrItem = [strRecord componentsSeparatedByString: @","];
            
            if(arrItem != nil && [arrItem count] > 1)
            {
                double lat = [[arrItem objectAtIndex: 0] doubleValue];
                double lng = [[arrItem objectAtIndex: 1] doubleValue];
                
                BasicMapAnnotation* mAnnot = [[BasicMapAnnotation alloc] init];
                mAnnot.coordinate = [[CLLocation alloc] initWithLatitude: lat longitude: lng].coordinate;
                mAnnot.mIndex = (int)i + 1;
                mAnnot.title = PIN_TOP_MESSAGE;
                mAnnot.hidden = NO;
                mAnnot.mKey = [NSString stringWithFormat: @"%@%d", LOCATION_PIN, i];
                [arrPins addObject: mAnnot];
                [mvMain addAnnotation:mAnnot];
            }
        }
        
        [self updateRegion];
        
        [mvMain showAnnotations: arrPins animated:YES];
    }
    else {
        [self updateDistance: 0];
    }
}

- (void) updateRegion
{
    [mvMain removeOverlays: arrSnapRoutes];
    [mvMain removeOverlays: arrNormalRoutes];
    
    if(isSnapToRoad) {
        [mvMain addOverlays: arrSnapRoutes];
    }
    else {
        [arrNormalRoutes removeAllObjects];
        if([arrPins count] > 1)
        {
            CLLocationCoordinate2D coordinates[arrPins.count + 1];
            for (int i = 0; i < [arrPins count]; i++)
            {
                BasicMapAnnotation* annotation = [arrPins objectAtIndex: i];
                coordinates[i] = annotation.coordinate;
            }
            
            coordinates[arrPins.count] = [[arrPins firstObject] coordinate];
            
            //Polygon.
            MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count: arrPins.count];
            [arrNormalRoutes addObject: polyline];
            [mvMain addOverlay: polyline];
//            [mvMain addAnnotation:polyline];
        }
    }
    [self updateLocation: arrPins];
    [self updateAddress];
}

- (IBAction)actionDone:(id)sender {
    if([arrPins count] <= 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_ROUTE] animated: YES completion: nil];
        return;
    }
    
    [SVProgressHUD show];
    BasicMapAnnotation* anno = [arrPins firstObject];
    CLLocation* loc = [[CLLocation alloc] initWithLatitude: anno.latitude longitude: anno.longitude];
    [[AppDelegate getDelegate] getAddressForLocation: loc success:^(NSString *address)
     {
         [SVProgressHUD dismiss];
         
         NSMutableArray* arrResult = [[NSMutableArray alloc] init];
         
         if(isSnapToRoad) {
             [arrResult addObjectsFromArray: arrSnapRoutesPoints];
         }
         else {
             for(BasicMapAnnotation* item in arrPins)
             {
                 NSString* record = [NSString stringWithFormat: @"%f,%f", item.latitude, item.longitude];
                 [arrResult addObject: record];
             }
         }
         
         [(CreateEventViewController*)self.previousViewController updateLocation: arrResult address: address snap_to_road: isSnapToRoad];
         [self.navigationController popViewControllerAnimated: YES];
         
     } failure:^{
         
         [SVProgressHUD dismiss];
         [self presentViewController: [AppEngine showErrorWithText: MSG_CANT_GET_ADDRESS] animated: YES completion: nil];
     }];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView: mvMain];
    CLLocationCoordinate2D touchMapCoordinate = [mvMain convertPoint:touchPoint toCoordinateFromView: mvMain];
    
    BasicMapAnnotation* mAnnot = [[BasicMapAnnotation alloc] init];
    mAnnot.coordinate = touchMapCoordinate;
    mAnnot.mIndex = [self getNextAnnoIndex];
    mAnnot.title = PIN_TOP_MESSAGE;
    mAnnot.hidden = NO;
    mAnnot.mKey = [NSString stringWithFormat: @"%@%d", LOCATION_PIN, mAnnot.mIndex];
    [arrPins addObject: mAnnot];
    [mvMain addAnnotation:mAnnot];
    [self updateRegion];
    if(isSnapToRoad) {
        [self updateSnapRoute];
    }
}

- (int) getNextAnnoIndex {
    int index = 0;
    for(BasicMapAnnotation* anno in arrPins) {
        if(anno.mIndex > index){
            index = anno.mIndex;
        }
    }
    
    index ++;
    return index;
}

#pragma mark - Mapbox SDK

- (BOOL)mapView:(__unused MGLMapView *)mapView annotationCanShowCallout:(__unused id <MGLAnnotation>)annotation {
    return YES;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return COLOR_GREEN_BTN;
}

- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation {
    if([annotation isKindOfClass: [BasicMapAnnotation class]]) {
        UIView *view = [[UIView alloc] initWithFrame: CGRectMake(-5, 1, 150, 35)];
        
        UIButton* btnTextDelete = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 110, 35)];
        btnTextDelete.backgroundColor = [UIColor colorWithRed: 233.0f/255.0f green:56.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
        [btnTextDelete setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        btnTextDelete.titleLabel.font = [UIFont fontWithName: FONT_REGULAR size: 14.0];
        [btnTextDelete setTitle: NSLocalizedString(@"DELETE PIN", nil) forState: UIControlStateNormal];
        btnTextDelete.layer.masksToBounds = YES;
        btnTextDelete.layer.cornerRadius = 3.0;
        [btnTextDelete addTarget: self action: @selector(deletePin:) forControlEvents: UIControlEventTouchUpInside];
        btnTextDelete.tag = [(BasicMapAnnotation*)annotation mIndex];
        [view addSubview: btnTextDelete];
        
        UIButton* btnAll = [[UIButton alloc] initWithFrame: CGRectMake(113, 0, 37, 35)];
        btnAll.backgroundColor = [UIColor blackColor];
        [btnAll setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        btnAll.titleLabel.font = [UIFont fontWithName: FONT_REGULAR size: 14.0];
        [btnAll setTitle: NSLocalizedString(@"ALL", nil) forState: UIControlStateNormal];
        btnAll.layer.masksToBounds = YES;
        [btnAll addTarget: self action: @selector(deleteAll:) forControlEvents: UIControlEventTouchUpInside];
        btnAll.layer.cornerRadius = 3.0;
        [view addSubview: btnAll];
        
        return view;
    }
    
    return nil;
}

- (void) deletePin: (UIButton*)sender {
    for(BasicMapAnnotation* anno in arrPins) {
        if(anno.mIndex == sender.tag)
        {
            [mvMain removeAnnotation: anno];
            [arrPins removeObject: anno];
            break;
        }
    }
    
    //Re index.
    [self updateRegion];
    if(isSnapToRoad) {
        [self updateSnapRoute];
    }
}

- (void) deleteAll: (UIButton*)sender {
    [mvMain removeAnnotations: mvMain.annotations];
    [arrPins removeAllObjects];
    
    //Re index.
    [self updateRegion];
}

//- (void)mapView:(MGLMapView *)mapView annotation:(id<MGLAnnotation>)annotation calloutAccessoryControlTapped:(UIControl *)control {
//    [mapView deselectAnnotation:annotation animated:NO];
//    if ([annotation isKindOfClass: [BasicMapAnnotation class]]) {
//        BasicMapAnnotation* currentAnno = (BasicMapAnnotation*)annotation;
//        for(BasicMapAnnotation* anno in arrPins) {
//            if(anno.mIndex == currentAnno.mIndex)
//            {
//                [mvMain removeAnnotation: anno];
//                [arrPins removeObject: anno];
//                break;
//            }
//        }
//        
//        //Re index.
//        [self updateRegion];
//        if(isSnapToRoad) {
//            [self updateSnapRoute];
//        }
//    }
//}

//- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
//    
//    MGLAnnotationView *annotationView = [mapView viewForAnnotation:userLocation];
//    
//}

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    // This example is only concerned with point annotations.
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        BasicMapAnnotation* anno = (BasicMapAnnotation*)annotation;
        int index = [anno mIndex];
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        NSString *reuseIdentifier = [NSString stringWithFormat:@"%f", annotation.coordinate.longitude];
        
        // For better performance, always try to reuse existing annotations. To use multiple different annotation views, change the reuse identifier for each.
        DraggableAnntationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"draggablePoint"];
        
        // If there’s no reusable annotation view available, initialize a new one.
        if (!annotationView) {
            annotationView = [[DraggableAnntationView alloc] initWithReuseIdentifier:reuseIdentifier size: 20 index: index delegate: self];
        }
        return annotationView;
    }
    return nil;
}

- (void) changedAnnotation:(CLLocationCoordinate2D)droppedAt index:(int)index {
    for(BasicMapAnnotation* anno in arrPins) {
        if(index == anno.mIndex) {
            anno.coordinate = droppedAt;
            [self updateRegion];
            break;
        }
    }
}

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark {
    [mvMain setCenterCoordinate:placemark.location.coordinate
                      zoomLevel:MAP_ZOOM_LEVEL
                       animated:NO];
    
    BasicMapAnnotation* mAnnot = [[BasicMapAnnotation alloc] init];                     ///
    mAnnot.coordinate = placemark.location.coordinate;                                  ///
    mAnnot.mIndex = [self getNextAnnoIndex];                                            ///
    mAnnot.title = PIN_TOP_MESSAGE;                                                     ///
    mAnnot.hidden = NO;                                                                 ///
    mAnnot.mKey = [NSString stringWithFormat: @"%@%d", LOCATION_PIN, mAnnot.mIndex];    ///
    [arrPins addObject: mAnnot];                                                        ///
    [mvMain addAnnotation:mAnnot];                                                      ///

//    [mvMain addAnnotation:placemark];
}

- (IBAction) actionSnapToRoad:(id)sender {
    isSnapToRoad = !isSnapToRoad;
    [self updateSnapToRoadUI];
    
    if(isSnapToRoad) {
        [self updateSnapRoute];
    } else {
        [self updateRegion];
    }
}

- (void) updateSnapRoute {
    if([arrPins count] > 0) {
        [mvMain removeOverlays: arrNormalRoutes];
        [mvMain removeOverlays: arrSnapRoutes];
        
        [arrSnapRoutes removeAllObjects];
        [arrSnapRoutesPoints removeAllObjects];
        
        int index = 0;
        [SVProgressHUD show];
        [btSnapToRoad setUserInteractionEnabled:NO];
        [mvMain setUserInteractionEnabled:NO];
        [self calculateRoutes: index];
    }
}

- (void) calculateRoutes: (int) index {
    
    if ([arrPins count] > 1) {
        BasicMapAnnotation* annoStart = [arrPins objectAtIndex: index];
        BasicMapAnnotation* annoEnd = [arrPins objectAtIndex: index + 1];
        
        MKPlacemark *placemarkStart = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(annoStart.latitude, annoStart.longitude) addressDictionary:nil];
        MKMapItem *itemStart = [[MKMapItem alloc] initWithPlacemark:placemarkStart];
        
        MKPlacemark *placemarkEnd = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(annoEnd.latitude, annoEnd.longitude) addressDictionary:nil];
        MKMapItem *itemEnd = [[MKMapItem alloc] initWithPlacemark:placemarkEnd];
        
        [self getSnapRoutes: itemStart endItem: itemEnd completionHandler:^{
            if(index >= [arrPins count] - 2) {
                [mvMain removeOverlays: arrSnapRoutes];
                [mvMain addOverlays: arrSnapRoutes];
                [btSnapToRoad setUserInteractionEnabled:YES];
                [mvMain setUserInteractionEnabled:YES];
                [SVProgressHUD dismiss];
            } else
            {
                [self calculateRoutes: index + 1];
            }
        }];
    } else {
        BasicMapAnnotation* annoStart = [arrPins objectAtIndex: 0];
        NSString* record = [NSString stringWithFormat: @"%f,%f", annoStart.latitude, annoStart.longitude];
        [arrSnapRoutesPoints addObject: record];
    }
}

- (void) getSnapRoutes: (MKMapItem*) itemStart endItem: (MKMapItem*) itemEnd completionHandler: (void (^)(void))success {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource: itemStart];
    [request setDestination: itemEnd];
    [request setTransportType:MKDirectionsTransportTypeWalking];
//    [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes: YES]; // Gives you several route options.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            // Perform async operation
            // Call your method/function here
            // Example:
            if (!error) {
                MKRoute *shortRoute = [[response routes] firstObject];
                for (MKRoute *route in [response routes]) {
                    if(shortRoute.distance > route.distance) {
                        shortRoute = route;
                    }
                }
                
                MKPolyline* line = [shortRoute polyline];
                
                NSUInteger pointCount = line.pointCount;
                CLLocationCoordinate2D *routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
                [line getCoordinates:routeCoordinates
                               range:NSMakeRange(0, pointCount)];
                
                MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates: routeCoordinates count: pointCount];
                [arrSnapRoutes addObject: polyline];
                for (int c=0; c < pointCount; c++) {
                    NSString* record = [NSString stringWithFormat: @"%f,%f", routeCoordinates[c].latitude, routeCoordinates[c].longitude];
                    [arrSnapRoutesPoints addObject: record];
                }
                free(routeCoordinates);
                success();
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                
//                NSLog(@"-------");
//                // Update UI
//                // Example:
//                // self.myLabel.text = result;
//                if(count >= [arrPins count] - 1) {
//                }
//                count++;
//                
            });
        });
    }];
}


- (void) updateLocation: (NSMutableArray*) arrRoute
{
    float distance = 0;
    
    if([arrRoute count] > 0) {
        //Calculate distance.
        float prevLat = 0;
        float prevLng = 0;
        float firstLat = 0;
        float firstLng = 0;
        
        int index = 0;
        for (int i = 0; i < [arrPins count]; i++) {
            BasicMapAnnotation* annotation = [arrPins objectAtIndex: i];
            float lat = annotation.coordinate.latitude;
            float lng = annotation.coordinate.longitude;
            
            if(index == 0)
            {
                firstLat = lat;
                firstLng = lng;
            }
            
            if(prevLat == 0 && prevLng == 0)
            {
                prevLat = lat;
                prevLng = lng;
            }
            else
            {
                CLLocation* loc1 = [[CLLocation alloc] initWithLatitude: prevLat longitude: prevLng];
                CLLocation* loc2 = [[CLLocation alloc] initWithLatitude: lat longitude: lng];
                
                CLLocationDistance meters = [loc1 distanceFromLocation: loc2];
                distance += meters;
                
                prevLat = lat;
                prevLng = lng;
            }
            index++;
        }
        
        
        CLLocation* loc1 = [[CLLocation alloc] initWithLatitude: prevLat longitude: prevLng];
        CLLocation* loc2 = [[CLLocation alloc] initWithLatitude: firstLat longitude: firstLng];
        
        CLLocationDistance meters = [loc1 distanceFromLocation: loc2];
        distance += meters;
    }
    
    [self updateDistance: distance];
}

- (void) updateDistance: (float) distance
{
    if([AppEngine sharedInstance].distanceUnit == DISTANCE_KILOMETER)
    {
        lbDistance.text = [NSString stringWithFormat: @"%0.2f KM", distance / 1000.0];
    }
    else
    {
        lbDistance.text = [NSString stringWithFormat: @"%0.2f Mile", distance / 1609.34];
    }
}

- (void) updateSnapToRoadUI {
    if(isSnapToRoad) {
        [btSnapToRoad setTitleColor: COLOR_GREEN_BTN forState: UIControlStateNormal];
        
    } else {
        [btSnapToRoad setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    }
}

- (void) updateAddress
{
    if([arrPins count] == 0)
    {
        sbSearch.text = @"";
    }
    else
    {
        BasicMapAnnotation* anno = [arrPins firstObject];
        CLLocation* loc = [[CLLocation alloc] initWithLatitude: anno.latitude longitude: anno.longitude];
        [[AppDelegate getDelegate] getAddressForLocation: loc success:^(NSString *address) {
            
            [SVProgressHUD dismiss];
            sbSearch.text = address;
            
        } failure:^{
            
            [SVProgressHUD dismiss];
            NSLog(@"failed address");
        }];
    }
}

#pragma mark - Search Location.

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        [tbList setHidden:NO];
        [searchQuery fetchPlacesForSearchQuery: searchText
                                    completion:^(NSArray *places, NSError *error) {
                                        if (error) {
                                            NSLog(@"ERROR: %@", error);
                                            [self handleSearchError:error];
                                        } else {
                                            arrSearchResults = places;
                                            tbList.userInteractionEnabled = YES;
                                            [tbList reloadData];
                                        }
                                    }];
    }
}

- (void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [tbList setHidden:YES];
}


#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearchResults.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultsCellIdentifier forIndexPath:indexPath];
    HNKGooglePlacesAutocompletePlace *thisPlace = arrSearchResults[indexPath.row];
    cell.textLabel.text = thisPlace.name;
    cell.textLabel.font = [UIFont fontWithName: FONT_REGULAR size: 12.0];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tbList)
    {
        [tableView deselectRowAtIndexPath: indexPath animated: NO];
        [sbSearch setShowsCancelButton:NO animated:YES];
        [sbSearch resignFirstResponder];
        
        HNKGooglePlacesAutocompletePlace *selectedPlace = arrSearchResults[indexPath.row];
        
        [tbList setHidden: YES];
        [tbList deselectRowAtIndexPath:indexPath animated:NO];
        sbSearch.text = selectedPlace.name;
        
        [SVProgressHUD show];
        [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                           apiKey: searchQuery.apiKey
                                       completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                           
                                           [SVProgressHUD dismiss];
                                           if (placemark)
                                           {
                                               [self recenterMapToPlacemark:placemark];
                                           }
                                       }];
    }
    else
    {
        
    }
}

@end
