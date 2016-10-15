//
//  HomeViewController.m
//  EverybodyRun
//
//  Created by star on 1/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "HomeViewController.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <MapKit/MapKit.h>
#import "CLPlacemark+HNKAdditions.h"
#import "AttendViewController.h"
#import "AppDelegate.h"
#import "EventAnnotation.h"
#import "ShopAnnotation.h"
#import <SWTableViewCell/SWTableViewCell.h>
#import "BasicMapAnnotation.h"
#import "MFSideMenu.h"
#import <MessageUI/MessageUI.h>
#import "WebViewController.h"
#import "MemberOnlyEventAnnotation.h"
#import "EventListViewController.h"
#import "FilterTableViewCell.h"
#import <JTCalendar/JTCalendar.h>
#import "BlogListViewController.h"
#import "JAmazonS3ClientManager.h"
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"
#import "OtherUserViewController.h"
#import "BaseEventAnnotation.h"
#import "ClusterAnnotation.h"
#import "CreateEventViewController.h"
#import <Mapbox/Mapbox.h>
#import "ERImageView.h"
#import "Branch.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

static NSString *const searchResultsCellIdentifier =  @"HNKDemoSearchResultsCellIdentifier";

@interface HomeViewController () <MFMessageComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate, MFMailComposeViewControllerDelegate, JTCalendarDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, FBSDKSharingDelegate, UIDocumentInteractionControllerDelegate>
{
    HNKGooglePlacesAutocompleteQuery    *searchQuery;
    JTCalendarManager                   *calendarManager;
    NSDate                              *todayDate;
    NSDate                              *minDate;
    NSDate                              *maxDate;
    
    NSDate                              *dateSelected;

    NSArray                             *arrSearchResults;
    NSArray                             *arrFilterTypes;
    FILTER_TYPE                         currentFilter;
    FILTER_CATEGORY                     currentCategory;
    
    BOOL                                isUpdatedCurrentLocationFirst;
    BOOL                                isLoading;
    BOOL                                isShowFilterView;
    BOOL                                isEventSelected;
    
    NSMutableArray                      *arrAllEvents;
    NSMutableArray                      *arrShops;
    NSMutableArray                      *arrMemberOnlyEvents;    
    NSMutableArray                      *arrAnnotations;
    NSMutableArray                      *arrAttendingEvents;
    NSMutableArray                      *arrOrganizingEvents;
    NSMutableArray                      *arrPolylines;
    
    CLLocationCoordinate2D              prevCenterPos;
    
    float                               prevSearchLat;
    float                               prevSearchLng;
    float                               initTopHeight;
    
    NSMutableArray                      *arrPins;
    
    NSURL                               *urlFullScreenImage;
    
    BaseEventAnnotation                 *currentSelectedAnnotation;
    Blog                                *currentBlog;
    Event                               *selectedEvent;
    MemberOnlyEvent                     *selectedMemberOnlyEvent;
    Shop                                *selectedShop;
    
    UIImagePickerController             *imagePicker;
    UIDocumentInteractionController         *docController;
    DID_COMPLETE_CALL_BACK_BLOCK            completeBlock;

}

@property(nonatomic, strong) QTree                              *qTree;

@property (nonatomic, weak) IBOutlet UILabel                    *lbFilter;
@property (nonatomic, weak) IBOutlet UIImageView                *ivFilterArrow;
@property (nonatomic, weak) IBOutlet UITableView                *tbFilterList;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *topFilterHeight;

@property (nonatomic, weak) IBOutlet MGLMapView                 *clusterMapView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *constraintMapBottom;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *constraintCalendarHeaderHeight;

//Top Header View.
@property (nonatomic, weak) IBOutlet UITableView                *tbList;
@property (nonatomic, weak) IBOutlet UIView                     *viTop;
@property (nonatomic, weak) IBOutlet UITextField                *tfSearchAddress;
@property (nonatomic, weak) IBOutlet UIButton                   *btCancelSearch;
@property (nonatomic, weak) IBOutlet UIButton                   *btToday;
@property (nonatomic, weak) IBOutlet UIButton                   *btTomorrow;
@property (nonatomic, weak) IBOutlet UIButton                   *btDate;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView         *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView   *calendarContentView;

@property (nonatomic, weak) IBOutlet UIButton                   *btEvents;

//Event Detail.
@property (nonatomic, weak) IBOutlet UIView                     *viEventDetail;
@property (nonatomic, weak) IBOutlet UIView                     *viEventDetailInfoContainer;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventTitle;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventInfo;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventAttendee;
@property (nonatomic, weak) IBOutlet UIButton                   *btRunIt;

@property (nonatomic, weak) IBOutlet UIView                     *viEventDetailFull;
@property (nonatomic, weak) IBOutlet UIView                     *viEventDetailFullInfoContainer;
@property (nonatomic, weak) IBOutlet UILabel                    *lbAddImages;
@property (nonatomic, weak) IBOutlet UIButton                   *btAddImages;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullTitle;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullInfo;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullTime;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullLocation;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullType;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullPace;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullVisibility;
@property (nonatomic, weak) IBOutlet UIScrollView               *scEventFullPhotos;
@property (nonatomic, weak) IBOutlet UIScrollView               *scEventFullAttending;
@property (nonatomic, weak) IBOutlet UIButton                   *btFullRunIt;
@property (nonatomic, weak) IBOutlet UIPageControl              *pgEventFullPhotos;
@property (nonatomic, weak) IBOutlet UILabel                    *lbEventFullDescription;
@property (nonatomic, weak) IBOutlet UIButton                   *btEventFullWebsite;

//Member Only
@property (nonatomic, weak) IBOutlet UIView                     *viMemberOnlyContainer;
@property (nonatomic, weak) IBOutlet UILabel                    *lbMemberOnlyTitle;
@property (nonatomic, weak) IBOutlet UILabel                    *lbMemberOnlyAddress;
@property (nonatomic, weak) IBOutlet UILabel                    *lbMemberOnlyCategory;

@property (weak, nonatomic) IBOutlet UIView                     *viMemberOnlyFull;
@property (weak, nonatomic) IBOutlet UIImageView                *ivMemberOnlyPhoto;
@property (weak, nonatomic) IBOutlet UILabel                    *lbMemberOnlyTitleFull;
@property (weak, nonatomic) IBOutlet UILabel                    *lbMemberOnlyAddressFull;
@property (weak, nonatomic) IBOutlet UILabel                    *lbMemberOnlyPhoneFull;
@property (weak, nonatomic) IBOutlet UILabel                    *lbMemberOnlyDescriptionFull;
@property (nonatomic, weak) IBOutlet UILabel                    *lbMemberOnlyCategoryFull;
@property (weak, nonatomic) IBOutlet UIButton                   *btShare;

//Shop
@property (nonatomic, weak) IBOutlet UIView                     *viShopContainer;
@property (nonatomic, weak) IBOutlet UILabel                    *lbShopTitle;
@property (nonatomic, weak) IBOutlet UILabel                    *lbShopAddress;
@property (nonatomic, weak) IBOutlet UILabel                    *lbShopSelected;

@property (weak, nonatomic) IBOutlet UIView                     *viShopFullContainer;
@property (weak, nonatomic) IBOutlet UIImageView                *ivShopPhoto;
@property (weak, nonatomic) IBOutlet UILabel                    *lbShopTitleFull;
@property (weak, nonatomic) IBOutlet UILabel                    *lbShopAddressFull;
@property (weak, nonatomic) IBOutlet UILabel                    *lbShopPhoneFull;
@property (nonatomic, weak) IBOutlet UILabel                    *lbShopSelectedFull;
@property (weak, nonatomic) IBOutlet UILabel                    *lbShopDescriptionFull;

//Full Screen.
@property (nonatomic, weak) IBOutlet UIView                     *viFullScreen;
@property (nonatomic, weak) IBOutlet UIImageView                *ivFull;

@end

@implementation HomeViewController

@synthesize lbFilter;
@synthesize ivFilterArrow;
@synthesize tbFilterList;
@synthesize topFilterHeight;

@synthesize clusterMapView;
@synthesize constraintMapBottom;

@synthesize viTop;
@synthesize tbList;
@synthesize tfSearchAddress;
@synthesize btCancelSearch;
@synthesize btToday;
@synthesize btDate;
@synthesize btTomorrow;
@synthesize calendarContentView;

@synthesize btEvents;

@synthesize viEventDetail;
@synthesize viEventDetailInfoContainer;
@synthesize lbEventTitle;
@synthesize lbEventInfo;
@synthesize lbEventAttendee;
@synthesize btRunIt;

@synthesize btShare;

@synthesize viEventDetailFull;
@synthesize viEventDetailFullInfoContainer;
@synthesize lbAddImages;
@synthesize btAddImages;
@synthesize lbEventFullTitle;
@synthesize lbEventFullInfo;
@synthesize lbEventFullTime;
@synthesize lbEventFullLocation;
@synthesize lbEventFullType;
@synthesize lbEventFullPace;
@synthesize lbEventFullVisibility;
@synthesize scEventFullPhotos;
@synthesize scEventFullAttending;
@synthesize btFullRunIt;
@synthesize pgEventFullPhotos;
@synthesize lbEventFullDescription;
@synthesize btEventFullWebsite;

@synthesize viMemberOnlyContainer;
@synthesize lbMemberOnlyTitle;
@synthesize lbMemberOnlyAddress;
@synthesize lbMemberOnlyCategory;

@synthesize viMemberOnlyFull;
@synthesize ivMemberOnlyPhoto;
@synthesize lbMemberOnlyTitleFull;
@synthesize lbMemberOnlyAddressFull;
@synthesize lbMemberOnlyPhoneFull;
@synthesize lbMemberOnlyDescriptionFull;
@synthesize lbMemberOnlyCategoryFull;

@synthesize viShopContainer;
@synthesize lbShopTitle;
@synthesize lbShopAddress;
@synthesize lbShopSelected;

@synthesize viShopFullContainer;
@synthesize ivShopPhoto;
@synthesize lbShopTitleFull;
@synthesize lbShopAddressFull;
@synthesize lbShopPhoneFull;
@synthesize lbShopSelectedFull;
@synthesize lbShopDescriptionFull;

@synthesize viFullScreen;
@synthesize ivFull;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) currentUserLocationUpdated: (id) sender
{
    if(isUpdatedCurrentLocationFirst) return;
    isUpdatedCurrentLocationFirst = YES;
    [self zoomMapView: [AppEngine sharedInstance].currentLatitude lng: [AppEngine sharedInstance].currentLongitude rate: DEFAULT_MAP_ZOOM_LEVEL];
}

- (IBAction) actionMenu:(id)sender
{
    if([AppEngine sharedInstance].currentUser == nil) return;
    if(self.menuContainerViewController.menuState == MFSideMenuStateLeftMenuOpen)
    {
        [self.menuContainerViewController setMenuState: MFSideMenuStateClosed];
    }
    else
    {
        [self.menuContainerViewController setMenuState: MFSideMenuStateLeftMenuOpen];
    }
}

- (IBAction) actionBlog:(id)sender
{
    if(self.menuContainerViewController.menuState == MFSideMenuStateRightMenuOpen)
    {
        [self.menuContainerViewController setMenuState: MFSideMenuStateClosed];
    }
    else
    {
        [self.menuContainerViewController setMenuState: MFSideMenuStateRightMenuOpen];
    }
}

- (void) initMember
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserLocationUpdated:) name:LOCATIONSERVICESUCCESSNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(changedDistanceUnit) name: DISTANCE_UNIT_CHANGED object: nil];
    
    //Date Init.
    isUpdatedCurrentLocationFirst = NO;
    [AppDelegate getDelegate].homeView = self;
    currentCategory = FILTER_ALL;
    
    isEventSelected = NO;
    isShowFilterView = NO;
    initTopHeight = topFilterHeight.constant;
    
    arrAllEvents = [[NSMutableArray alloc] init];
    arrShops = [[NSMutableArray alloc] init];
    arrAnnotations = [[NSMutableArray alloc] init];
    arrMemberOnlyEvents = [[NSMutableArray alloc] init];
    arrAttendingEvents = [[NSMutableArray alloc] init];
    arrOrganizingEvents = [[NSMutableArray alloc] init];
    arrPins = [[NSMutableArray alloc] init];
    arrPolylines = [[NSMutableArray alloc] init];
    
    btEvents.layer.masksToBounds = YES;
    btEvents.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    searchQuery = [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey: GOOGLE_PLACE_API_KEY];
    
    [[AppDelegate getDelegate] updateCurrentUserLocation];
    
    //Remove Events in Local for Updating.
    [[CoreHelper sharedInstance] deleteAllEvents];
    
    btCancelSearch.hidden = YES;
    
    //Filter.
    [self initFilter];
    [self initCalendar];
    
    //Init Map.
    [self initMap];
    
    [self initEventDetail];
    [self loadAllData];
    
    //Init Full Screen
    [self initFullScreen];
}

- (void) changedDistanceUnit
{
    
}

- (void) applicationIsActive {
    if([self isNeedUpdatingData]) {
        [self loadAllData];
    }  else {
        [[CoreHelper sharedInstance] deleteAllEvents];
        [self loadEventsFromServer];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    //Check Map Type.
    NSURL *styleURL;
    if([AppEngine sharedInstance].mapType == 0) {
        styleURL = [NSURL URLWithString: MAP_TYPE_DEFAULT_URL];
    }
    else {
        styleURL = [NSURL URLWithString: MAP_TYPE_SAT_URL];
    }
    clusterMapView.styleURL = styleURL;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

#pragma mark - Filter.

- (void) initFilter
{
    [AppEngine sharedInstance].filterDate = [NSDate date];
    currentFilter = FILTER_TODAY;
    [self updateFilterUI];
    
    arrFilterTypes = @[@{@"icon": @"event_item", @"sel_icon": @"event_item",  @"title": @"Event"},
                       @{@"icon": @"food_item_icon.png", @"sel_icon": @"food_item_sel_icon.png",  @"title": @"Food"},
                       @{@"icon": @"beverage_item_icon.png", @"sel_icon": @"beverage_sel_icon.png",  @"title": @"Beverage"},
                       @{@"icon": @"health_item_icon.png", @"sel_icon": @"health_sel_icon.png",  @"title": @"Health"},
                       @{@"icon": @"club_item_icon.png", @"sel_icon": @"club_sel_icon.png",  @"title": @"Clubs"},
                       @{@"icon": @"coach_item_icon.png", @"sel_icon": @"coach_sel_icon.png",  @"title": @"Coaches"},
                       @{@"icon": @"happy_item_icon.png", @"sel_icon": @"happy_sel_icon.png",  @"title": @"Happenings"},
                       @{@"icon": @"retailer_item_icon.png", @"sel_icon": @"retailer_sel_icon.png",  @"title": @"Ciele Retailers"},
                       @{@"icon": @"select_retailer_item_icon.png", @"sel_icon": @"select_retailer_sel_icon.png",  @"title": @"Ciele Select Retailers"},
                       @{@"icon": @"", @"sel_icon": @"",  @"title": @"All categories"},
                       ];
    [tbFilterList registerNib: [UINib nibWithNibName: @"FilterTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([FilterTableViewCell class])];
}

- (void) updateFilterUI
{
    btToday.selected = NO;
    btTomorrow.selected = NO;
    btDate.selected = NO;
    
    if(currentFilter == FILTER_TODAY)
    {
        btToday.selected = YES;
    }
    else if(currentFilter == FILTER_TOMORROW)
    {
        btTomorrow.selected = YES;
    }
    else
    {
        btDate.selected = YES;
    }
}

- (IBAction) actionFilter:(id)sender
{
    if(isEventSelected) return;
    if(sender == btToday)
    {
        tbFilterList.hidden = NO;
        calendarContentView.hidden = YES;
        currentFilter = FILTER_TODAY;
        [self todayFilter];
    }
    else if(sender == btTomorrow)
    {
        tbFilterList.hidden = NO;
        calendarContentView.hidden = YES;
        currentFilter = FILTER_TOMORROW;
        [self allDateFilter];
    }
    else
    {
        tbFilterList.hidden = YES;
        calendarContentView.hidden = NO;
        currentFilter = FILTER_DATE;
        
        [self openFilterType];
    }
    
    [self updateFilterUI];
    [self updateFilterType];
}

- (void) todayFilter
{
    [AppEngine sharedInstance].filterDate = [NSDate date];
//    [self refreshMapView];
    [self loadEventsFromServer];
}

- (void) allDateFilter
{
    NSDate *now = [NSDate date];
    int daysToAdd = 1;
    NSDate *tomorrowDate = [now dateByAddingTimeInterval: 60*60*24*daysToAdd];
    
    [AppEngine sharedInstance].filterDate = tomorrowDate;
//    [self refreshMapView];
    [self loadEventsFromServer];
}

- (void) initCalendar
{
    calendarManager = [JTCalendarManager new];
    calendarManager.delegate = self;
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [calendarManager setMenuView:_calendarMenuView];
    [calendarManager setContentView: calendarContentView];
    [calendarManager setDate: [NSDate date]];
}

- (void)createMinAndMaxDate
{
    todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    minDate = [calendarManager.dateHelper addToDate:todayDate months:-10];
    
    // Max date will be 2 month after today
    maxDate = [calendarManager.dateHelper addToDate:todayDate months:10];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.textLabel.font = [UIFont fontWithName: FONT_REGULAR size: 14.0];
    
    // Today
    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(dateSelected && [calendarManager.dateHelper date: dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![calendarManager.dateHelper date: calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    dateSelected = dayView.date;
    [AppEngine sharedInstance].filterDate = dateSelected;
    
    NSLog(@"[AppEngine sharedInstance].filterDate = %@", [AppEngine sharedInstance].filterDate);
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [calendarManager reload];
                    } completion:^(BOOL finished) {
                        [self closeFilterType];
                        [self refreshMapView];

                    }];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [calendarContentView loadNextPageWithAnimation];
        }
        else{
            [calendarContentView loadPreviousPageWithAnimation];
        }
    }
}


// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [calendarManager.dateHelper date:date isEqualOrAfter: minDate andEqualOrBefore: maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Filter Type.

- (void) openFilterType
{
    isShowFilterView = YES;
    CGFloat height = 560.0;
    if(IS_IPHONE_4_OR_LESS) {
        height = 400.0;
    }
    
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         
                         topFilterHeight.constant = height;
                         _constraintCalendarHeaderHeight.constant = 40.0;
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void) closeFilterType
{
    isShowFilterView = NO;
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         
                         topFilterHeight.constant = initTopHeight;
                         _constraintCalendarHeaderHeight.constant = 0;
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                     }];

}

- (IBAction) actionFilterType:(id)sender
{
    if(isEventSelected) return;
    
    isShowFilterView = !isShowFilterView;
    [self updateFilterType];
    
    tbFilterList.hidden = NO;
    calendarContentView.hidden = YES;

    if(isShowFilterView)
    {
        [self openFilterType];
    }
    else
    {
        [self closeFilterType];
    }
}

- (void) updateFilterType
{
    if(isShowFilterView)
    {
        if(!calendarContentView.hidden)
        {
            lbFilter.text = @"Close Date";
        }
        else
        {
            lbFilter.text = @"Close Filters";
        }

        ivFilterArrow.image = [UIImage imageNamed: @"uparrow.png"];
    }
    else
    {
        int index = 0;
        if(currentCategory == FILTER_EVENT) {
            index = 0;
        } if(currentCategory == FILTER_FOOD) {
            index = 1;
        } if(currentCategory == FILTER_BEVERAGE) {
            index = 2;
        } if(currentCategory == FILTER_HEALTH) {
            index = 3;
        } if(currentCategory == FILTER_CLUBS) {
            index = 4;
        } if(currentCategory == FILTER_COACHES) {
            index = 5;
        } if(currentCategory == FILTER_HAPPENINGS) {
            index = 6;
        } if(currentCategory == FILTER_RETAILERS) {
            index = 7;
        } if(currentCategory == FILTER_SELECT_RETAILERS) {
            index = 8;
        } if(currentCategory == FILTER_ALL) {
            index = 9;
        }
        
        NSDictionary* dicItem = [arrFilterTypes objectAtIndex: index];
        NSString* filterName = dicItem[@"title"];
        
        lbFilter.text = [NSString stringWithFormat: @"Show Filters / %@", filterName];
        ivFilterArrow.image = [UIImage imageNamed: @"downarrow.png"];
    }
}

#pragma mark - Load Data.

- (void) loadAllData
{
    [SVProgressHUD showWithStatus: @"Loading"];
    
    //Load My Events from Server.
    
    if([AppEngine sharedInstance].currentUser != nil) {
        [[NetworkClient sharedClient] getMyEvents: [AppEngine sharedInstance].currentUser.user_id
                                          success:^(NSDictionary *responseObject) {
                                              
                                              [arrOrganizingEvents removeAllObjects];
                                              if([[responseObject allKeys] containsObject: @"data"])
                                              {
                                                  NSDictionary* dicData = responseObject[@"data"];
                                                  if([[dicData allKeys] containsObject: @"events"])
                                                  {
                                                      NSArray* arrEvents = dicData[@"events"];
                                                      NSLog(@"get my events count = %d", (int)[arrEvents count]);
                                                      
                                                      if(arrEvents != nil)
                                                      {
                                                          for(NSDictionary* dicEvent in arrEvents)
                                                          {
                                                              Event* e = [[Event alloc] initWithDictionary: dicEvent];
                                                              [[CoreHelper sharedInstance] addEvent: e];
                                                              [arrOrganizingEvents addObject: e];
                                                          }
                                                      }
                                                  }
                                              }
                                              
                                              [self loadMemberOnlyEvents];
                                              
                                          } failure:^(NSError *error) {
                                              
                                              NSLog(@"get my events error = %@", error);
                                              [self loadMemberOnlyEvents];
                                          }];
    }
    else {
        [self loadMemberOnlyEvents];
    }
}

- (void) loadMemberOnlyEvents {
    //Load Member Only Events.
    [[NetworkClient sharedClient] getMemberOnlyEvents:^(NSArray *array) {
        
        [arrMemberOnlyEvents removeAllObjects];
        if(array != nil)
        {
            [arrMemberOnlyEvents addObjectsFromArray: array];
        }
        [self loadShop];
        
    } failure:^(NSString *errorMessage) {
        
        [self loadShop];
    }];
}

- (void) loadShop
{
    [[NetworkClient sharedClient] getAllShops:^(NSArray *results)
     {
         [[CoreHelper sharedInstance] deleteAllShops];
         [arrShops removeAllObjects];
         if(results != nil && [results count] > 0)
         {
             for(NSDictionary* dicItem in results)
             {
                 Shop* s = [[Shop alloc] initWithDictionary: dicItem];
                 [[CoreHelper sharedInstance] addShop: s];
                 [arrShops addObject: s];
             }
         }
         
         [self loadMyAttendData];
         
     } failure:^(NSError *error) {
         NSLog(@"getting shop error = %@", error);
         [self loadMyAttendData];
     }];
}


- (void) loadMyAttendData
{
    if ([AppEngine sharedInstance].currentUser != nil) {
        [[NetworkClient sharedClient] getMyAttendees: [AppEngine sharedInstance].currentUser.user_id
                                             success:^(NSDictionary *responseObject) {
                                                 
                                                 [SVProgressHUD dismiss];
                                                 int success = [[responseObject valueForKey: @"success"] intValue];
                                                 if(success == 1 && [responseObject[@"data"] isKindOfClass:[NSDictionary class]])
                                                 {
                                                     if([[responseObject[@"data"] allKeys] containsObject: @"attendees"])
                                                     {
                                                         NSArray* arrAttendees = [responseObject valueForKey: @"data"][@"attendees"];
                                                         NSLog(@"get my attend count = %d", (int)[arrAttendees count]);
                                                         
                                                         
                                                         [arrAttendingEvents removeAllObjects];
                                                         NSArray* arrEvents = [responseObject valueForKey: @"data"][@"events"];
                                                         if(arrEvents != nil)
                                                         {
                                                             for(NSDictionary* dicEvent in arrEvents)
                                                             {
                                                                 Event* e = [[Event alloc] initWithDictionary: dicEvent];
                                                                 [[CoreHelper sharedInstance] addEvent: e];
                                                                 [arrAttendingEvents addObject: e];
                                                             }
                                                         }
                                                     }
                                                 }
                                                 
                                                 [self updateEventByLocalDB];
                                                 [self checkExpiredEvents];
                                                 
                                             } failure:^(NSError *error) {
                                                 
                                                 NSLog(@"get my attendess error = %@", error);
                                                 [SVProgressHUD dismiss];
                                             }];
    }
    else {
        [SVProgressHUD dismiss];
        [self refreshMapView];
    }
}

- (void) checkExpiredEvents {
    for(Event* e in arrOrganizingEvents) {
        if([e isExpire: [NSDate date]] && !e.is_asked_expire) {

            e.is_asked_expire = YES;
            [[NetworkClient sharedClient] updatedAskedExpire: e success:^(NSDictionary *responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
            
            UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                                message: [NSString stringWithFormat: @"Congrats! Your EverybodyRun event \"%@\" has been completed. Do it again?", e.name]
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CreateEventViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"CreateEventViewController"];
                nextView.currentEvent = e;
                nextView.isEditing = YES;
                nextView.parentView = self;
                [self.navigationController pushViewController: nextView animated: YES];
            }];

            UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            [controller addAction: yesAction];
            [controller addAction: noAction];
            [self presentViewController: controller animated: YES completion: nil];
            break;
        }
    }
}

- (BOOL) isNeedUpdatingData
{
    NSDate *lastUpdated = [AppEngine sharedInstance].last_update;
    if(lastUpdated == nil)
    {
        [[CoreHelper sharedInstance] saveLastUpdate: [NSDate date]];
        return YES;
    }
    
    NSDate *today = [NSDate date];
    float interval = [today timeIntervalSinceDate: lastUpdated];
    if(interval > REFRESH_INTERVAL * 3600)
    {
        [[CoreHelper sharedInstance] saveLastUpdate: [NSDate date]];
        return YES;
    }
    
    return NO;
}

- (void) loadEventsFromServer
{
    if(clusterMapView.centerCoordinate.latitude == 0 && clusterMapView.centerCoordinate.longitude == 0) return;
    if(prevSearchLat == clusterMapView.centerCoordinate.latitude && prevSearchLng == clusterMapView.centerCoordinate.longitude) return;
    
    prevSearchLat = clusterMapView.centerCoordinate.latitude;
    prevSearchLng = clusterMapView.centerCoordinate.longitude;
    
    NSLog(@"loading events from server...");
    
    NSNumber* user_id = nil;
    if([AppEngine sharedInstance].currentUser != nil) {
        user_id = [AppEngine sharedInstance].currentUser.user_id;
    }
    
    //Load Get Events.
    [[NetworkClient sharedClient] getEventsByDistance: clusterMapView.centerCoordinate.latitude
                                                  lng: clusterMapView.centerCoordinate.longitude
                                              user_id: user_id
                                      success: ^(NSDictionary *responseObject) {
                                         
                                          int success = [[responseObject valueForKey: @"success"] intValue];
                                          if(success)
                                          {
                                              NSArray* arrEvents = [responseObject valueForKey: @"data"][@"events"];
                                              NSLog(@"get events count = %d", (int)[arrEvents count]);
                                              
                                              if(arrEvents != nil && [arrEvents count] > 0)
                                              {
                                                  for (NSDictionary* dicEvent in arrEvents)
                                                  {
                                                      Event* e = [[Event alloc] initWithDictionary: dicEvent];
                                                      [[CoreHelper sharedInstance] addEvent: e];
                                                  }
                                                  
                                                  [self updateEventByLocalDB];
                                              }
                                          }
                                          
                                      } failure:^(NSError *error) {
                                          
                                          NSLog(@"get home events error = %@", error);
                                      }];
}

- (void) updateEventByLocalDB
{
    //All Events.
    [arrAllEvents removeAllObjects];
    
    NSArray* arrEvents = [[CoreHelper sharedInstance] loadEvents];
    if(arrEvents != nil)
    {
        for(NSManagedObject* objEvent in arrEvents)
        {
            Event* e = [[Event alloc] initWithManageObject: objEvent];
            [arrAllEvents addObject: e];
        }
    }
    
    [self refreshMapView];
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tbFilterList)
    {
        return arrFilterTypes.count;
    }
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
    if(tableView == tbFilterList)
    {
        FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"FilterTableViewCell" forIndexPath:indexPath];
        if(currentCategory == indexPath.row)
        {
            [cell setFilter: [arrFilterTypes objectAtIndex: indexPath.row] isSelected: [self isSelectedFilter: (int)indexPath.row]];
        }
        else
        {
            [cell setFilter: [arrFilterTypes objectAtIndex: indexPath.row] isSelected: [self isSelectedFilter: (int)indexPath.row]];
        }

        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultsCellIdentifier forIndexPath:indexPath];
        HNKGooglePlacesAutocompletePlace *thisPlace = arrSearchResults[indexPath.row];
        cell.textLabel.text = thisPlace.name;
        cell.textLabel.font = [UIFont fontWithName: FONT_REGULAR size: 13.0];
        return cell;
    }
}

- (BOOL) isSelectedFilter: (int) index {
    if(index == 0) {
        return currentCategory == FILTER_EVENT;
    }
    if(index == 1) {
        return currentCategory == FILTER_FOOD;
    }
    if(index == 2) {
        return currentCategory == FILTER_BEVERAGE;
    }
    if(index == 3) {
        return currentCategory == FILTER_HEALTH;
    }
    if(index == 4) {
        return currentCategory == FILTER_CLUBS;
    }
    if(index == 5) {
        return currentCategory == FILTER_COACHES;
    }
    if(index == 6) {
        return currentCategory == FILTER_HAPPENINGS;
    }
    if(index == 7) {
        return currentCategory == FILTER_RETAILERS;
    }
    if(index == 8) {
        return currentCategory == FILTER_SELECT_RETAILERS;
    }
    if(index == 9) {
        return currentCategory == FILTER_ALL;
    }
    
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    if(tableView == tbFilterList)
    {
        switch (indexPath.row) {
            case 0:
                currentCategory = FILTER_EVENT;
                break;
            
            case 1:
                currentCategory = FILTER_FOOD;
                break;
            
            case 2:
                currentCategory = FILTER_BEVERAGE;
                break;
            
            case 3:
                currentCategory = FILTER_HEALTH;
                break;
            
            case 4:
                currentCategory = FILTER_CLUBS;
                break;
            
            case 5:
                currentCategory = FILTER_COACHES;
                break;
                
            case 6:
                currentCategory = FILTER_HAPPENINGS;
                break;
            
            case 7:
                currentCategory = FILTER_RETAILERS;
                break;
            
            case 8:
                currentCategory = FILTER_SELECT_RETAILERS;
                break;
                
            case 9:
                currentCategory = FILTER_ALL;
                break;
                
            default:
                break;
        }
        
        [self closeFilterType];
        [self updateFilterType];
        [tbFilterList reloadData];
        [self refreshMapView];
    }
    else
    {
        [tfSearchAddress resignFirstResponder];
        HNKGooglePlacesAutocompletePlace *selectedPlace = arrSearchResults[indexPath.row];
        [tbList setHidden: YES];
        [tbList deselectRowAtIndexPath:indexPath animated:NO];
        tfSearchAddress.text = selectedPlace.name;
        
        [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                           apiKey: searchQuery.apiKey
                                       completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                           if (placemark)
                                           {
                                               [self recenterMapToPlacemark:placemark];
                                               
                                               if(isEventSelected) {
                                                   [self actionCloseEventDetail: nil];
                                               }
                                               
                                               
                                               //Check Blog.
                                               [(BlogListViewController*)self.menuContainerViewController.rightMenuViewController checkBlogs: placemark];
                                           }
                                       }];
    }
}


#pragma mark - Search Location.

- (IBAction) actionSearchCancel:(id)sender {
    tfSearchAddress.text = @"";
    [tfSearchAddress resignFirstResponder];
    [tbList setHidden: YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    btCancelSearch.hidden = NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if(tfSearchAddress.text.length > 0) {
        btCancelSearch.hidden = NO;
    } else {
        btCancelSearch.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == tfSearchAddress) {
        NSString* searchText = [tfSearchAddress.text stringByReplacingCharactersInRange:range withString:string];
        if(searchText.length > 0) {
            [tbList setHidden:NO];
            [searchQuery fetchPlacesForSearchQuery: searchText
                                        completion:^(NSArray *places, NSError *error) {
                                            if (error) {
                                                NSLog(@"ERROR: %@", error);
                                                [self handleSearchError:error];
                                            } else {
                                                arrSearchResults = places;
                                                [tbList reloadData];
                                            }
                                        }];

        }
    }
    
    return YES; //If you don't your textfield won't get any text in it
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
                                                 [tbList reloadData];
                                             }
                                         }];
    }
}

#pragma mark - Helpers

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
{
    [clusterMapView setCenterCoordinate:placemark.location.coordinate
                      zoomLevel:MAP_ZOOM_LEVEL
                       animated:NO];
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

#pragma mark - Map

- (IBAction) actionGotoCurrentPos:(id)sender
{
    [self zoomMapView: [AppEngine sharedInstance].currentLatitude lng: [AppEngine sharedInstance].currentLongitude rate: DEFAULT_MAP_ZOOM_LEVEL];
}

- (void) initMap
{
    clusterMapView.userTrackingMode = MKUserTrackingModeFollow;
    self.qTree = [QTree new];
    [self actionGotoCurrentPos: nil];
}

-(void)reloadAnnotations {
    if( !self.isViewLoaded ) {
        return;
    }
    
    if(isEventSelected) {
        NSMutableArray* arrOnlyPins = [[NSMutableArray alloc] init];
        for(id anno in clusterMapView.annotations) {
            if(![anno isKindOfClass: [MGLPolyline class]]) {
                [arrOnlyPins addObject: anno];
            }
        }
        [clusterMapView removeAnnotations: arrOnlyPins];
        [clusterMapView addAnnotations: arrAnnotations];
    }
    else {
        
//        const MKCoordinateRegion mapRegion = clusterMapView.visibleCoordinateBounds;
        const MGLCoordinateBounds bounds = clusterMapView.visibleCoordinateBounds;
        
        CLLocationCoordinate2D topLeftCoord = bounds.sw;
        CLLocationCoordinate2D bottomRightCoord = bounds.ne;
        
        MKCoordinateRegion mapRegion;
        mapRegion.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        mapRegion.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        
        // Add a little extra space on the sides
        mapRegion.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
        mapRegion.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
        
        const CLLocationDegrees minNonClusteredSpan = MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5;
        NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
        
        NSMutableArray* annotationsToRemove = [clusterMapView.annotations mutableCopy];
        [annotationsToRemove removeObject:clusterMapView.userLocation];
        [annotationsToRemove removeObjectsInArray:objects];
        [clusterMapView removeAnnotations:annotationsToRemove];
        
        NSMutableArray* annotationsToAdd = [objects mutableCopy];
        [annotationsToAdd removeObjectsInArray:clusterMapView.annotations];
        
        NSMutableArray* newAnnotationsToAdd = [[NSMutableArray alloc] init];
        for(id annotation in annotationsToAdd) {
            if([annotation isKindOfClass: [QCluster class]]) {
                QCluster* clusterAnnotation = (QCluster*)annotation;
                
                ClusterAnnotation* anno = [[ClusterAnnotation alloc] init];
                anno.cluster = clusterAnnotation;
                anno.coordinate = clusterAnnotation.coordinate;
                [newAnnotationsToAdd addObject: anno];
            }
            else {
                [newAnnotationsToAdd addObject: annotation];
            }
        }
        [clusterMapView addAnnotations: newAnnotationsToAdd];
    }
}

- (void) zoomMapView: (float) lat lng: (float) lng rate: (int) zoomLevel
{
    if(lat == 0 && lng == 0) return;
    
    [clusterMapView setCenterCoordinate:CLLocationCoordinate2DMake(lat,lng)
                      zoomLevel:zoomLevel
                       animated:NO];
    
}

- (void) refreshMapView
{
    [arrAnnotations removeAllObjects];

    //Events.
    for(Event* e in arrAllEvents)
    {
        if(![e isExpire: [AppEngine sharedInstance].filterDate])
        {
            BOOL needToAdd = NO;
            if(e.visibility == VISIBILITY_CLOSED)
            {
                if([e isEventByCurrentUser] || e.is_attended)
                {
                    needToAdd = YES;
                }
            }
            else if(![e isExpire: [AppEngine sharedInstance].filterDate])
            {
                needToAdd = YES;
            }
            
            if(needToAdd)
            {
                if(currentCategory == FILTER_ALL || currentCategory == FILTER_EVENT) {
                    EventAnnotation *annotation = [[EventAnnotation alloc] initWithEvent: e];
                    annotation.event = e;
                    if(selectedEvent != nil && [selectedEvent.event_id intValue] == [e.event_id intValue]) {
                        annotation.isSelected = YES;
                    }
                    [arrAnnotations addObject: annotation];
                }
            }
        }
    }
    
    //Member Only Events.
    for(MemberOnlyEvent* e in arrMemberOnlyEvents)
    {
        MemberOnlyEventAnnotation *annotation = [[MemberOnlyEventAnnotation alloc] initWithEvent: e];
        annotation.event = e;
        if(selectedMemberOnlyEvent != nil && selectedMemberOnlyEvent.event_id == e.event_id) {
            annotation.isSelected = YES;
        }
        
        if(currentCategory == FILTER_ALL) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_FOOD && e.category_id == FILTER_FOOD) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_BEVERAGE && e.category_id == FILTER_BEVERAGE) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_HEALTH && e.category_id == FILTER_HEALTH) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_CLUBS && e.category_id == FILTER_CLUBS) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_COACHES && e.category_id == FILTER_COACHES) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_HAPPENINGS && e.category_id == FILTER_HAPPENINGS) {
            [arrAnnotations addObject: annotation];
        }
    }

    //Shop.
    for(Shop* s in arrShops)
    {
        ShopAnnotation* annotation = [[ShopAnnotation alloc] initWithShop: s];
        if(selectedShop != nil && [selectedShop.shop_id intValue] == [s.shop_id intValue]) {
            annotation.isSelected = YES;
        }
        if(currentCategory == FILTER_ALL) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_RETAILERS && ![s.is_select boolValue]) {
            [arrAnnotations addObject: annotation];
        }
        else if(currentCategory == FILTER_SELECT_RETAILERS && [s.is_select boolValue]) {
            [arrAnnotations addObject: annotation];
        }
    }
    
    NSLog(@"pin count = %d", (int)arrAnnotations.count);
    [self.qTree cleanup];
    
    if(arrAnnotations == nil || [arrAnnotations count] == 0) {
        [clusterMapView removeAnnotations: clusterMapView.annotations];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                       {
                           for(id annotation in arrAnnotations) {
                               [self.qTree insertObject:annotation];
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  [self reloadAnnotations];
                                              });
                           }
                       });
    } 
}

- (void) needsRefreshClusterMap
{
//    [clusterMapView needsRefresh];
}

- (void)moveCenterByOffset:(CGPoint)offset from:(CLLocationCoordinate2D)coordinate
{
    CGPoint point = [clusterMapView convertCoordinate:coordinate toPointToView:clusterMapView];
    point.x += offset.x;
    point.y -= offset.y;
    CLLocationCoordinate2D center = [clusterMapView convertPoint:point toCoordinateFromView:clusterMapView];
    [clusterMapView setCenterCoordinate:center animated: NO];
}

- (void) addedNewAttendEvent:(Event *)e
{
    [self loadMyAttendData];
}

- (void) sendEmailDetailForClosedEvent: (Event*) e
{
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    // Email Content
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    if(e.post_user_email && [e.post_user_email length] > 0)
    {
        [mc setToRecipients: @[e.post_user_email]];
    }
    
    [mc setSubject: EMAIL_TITLE];
    [mc setMessageBody: EMAIL_MESSAGE_BODY_CLOSED_EVENT isHTML: NO];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) sendMessageToOrganizer:(NSString *)email
{
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    // Email Content
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    if(email && [email length] > 0)
    {
        [mc setToRecipients: @[email]];
    }

    [mc setSubject: EMAIL_TITLE];
    [mc setMessageBody: EMAIL_MESSAGE_BODY isHTML: NO];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) selectedRSVP:(Event *)e
{
    [self shareEvent: e completedHander:^{
        
    }];
}

- (void) openEventURL:(NSString *)url title:(NSString *)title {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"WebViewController"];
    nextView.title = title;
    nextView.url = url;
    [self.navigationController pushViewController: nextView animated: YES];
}


#pragma mark - MapView Delegate

- (void) mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if(mapView == clusterMapView) {
        [self reloadAnnotations];
        if(prevCenterPos.latitude == 0 && prevCenterPos.longitude == 0)
        {
            prevCenterPos = mapView.centerCoordinate;
            [self loadEventsFromServer];
        }
        else
        {
            CLLocation* loc1 = [[CLLocation alloc] initWithLatitude: prevCenterPos.latitude longitude: prevCenterPos.longitude];
            CLLocation* loc2 = [[CLLocation alloc] initWithLatitude: mapView.centerCoordinate.latitude longitude: mapView.centerCoordinate.longitude];
            
            float distance = [loc1 distanceFromLocation: loc2] / 1609.0;
            if(distance > MAX_SEARCH_MILE)
            {
                prevCenterPos = mapView.centerCoordinate;
                [self loadEventsFromServer];
            }
        }
    }
}

- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id <MGLAnnotation>)annotation;
{
    if ([annotation isKindOfClass:[MGLUserLocation class]]) return;
    
    if( [annotation isKindOfClass:[ClusterAnnotation class]] ) {
        ClusterAnnotation* clusterAnno = (ClusterAnnotation*)annotation;
        MKCoordinateRegion region = MKCoordinateRegionMake(clusterAnno.cluster.coordinate, MKCoordinateSpanMake(2.5 * clusterAnno.cluster.radius, 2.5 * clusterAnno.cluster.radius));
        CLLocationCoordinate2D center = clusterAnno.cluster.coordinate;
        CLLocationCoordinate2D northWestCorner, southEastCorner;
        northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
        northWestCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);
        southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
        southEastCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
        
        MGLCoordinateBounds bound = MGLCoordinateBoundsMake(southEastCorner, northWestCorner);
        [mapView setVisibleCoordinateBounds: bound animated: YES];
    } else {
        if(currentSelectedAnnotation != nil && currentSelectedAnnotation == annotation) return;
        if(currentSelectedAnnotation != nil) {
            currentSelectedAnnotation.isSelected = NO;
            [clusterMapView deselectAnnotation: currentSelectedAnnotation animated: YES];
            [self deselectAnnotation];
        }
            
        currentSelectedAnnotation = annotation;
//        currentSelectedAnnotationView = view;

        //Event.
        if ([annotation isKindOfClass:[EventAnnotation class]])
        {
            EventAnnotation *eAnnotation = (EventAnnotation*)annotation;
            eAnnotation.isSelected = YES;
            [self showEventDetail: eAnnotation.event];
        }
            
        //Member Only Events.
        else if([annotation isKindOfClass: [MemberOnlyEventAnnotation class]])
        {
            MemberOnlyEventAnnotation *eAnnotation = (MemberOnlyEventAnnotation*)annotation;
            eAnnotation.isSelected = YES;
            [self showMemberOnlyEvent: eAnnotation.event];
            
            CLLocation* loc = [[CLLocation alloc] initWithLatitude: eAnnotation.event.lat longitude: eAnnotation.event.lng];
            [self moveCenterByOffset: CGPointMake(0, 0) from: [loc coordinate]];
        }
            
        //Shop
        else if([annotation isKindOfClass: [ShopAnnotation class]])
        {
            ShopAnnotation *eAnnotation = (ShopAnnotation*)annotation;
            eAnnotation.isSelected = YES;
            [self showShop: eAnnotation.shop];
            CLLocation* loc = [[CLLocation alloc] initWithLatitude: [eAnnotation.shop.lat doubleValue] longitude: [eAnnotation.shop.lng doubleValue]];
            [self moveCenterByOffset: CGPointMake(0, 0) from: [loc coordinate]];
        }
    }
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    
    //Cluster.
    if ([annotation isKindOfClass:[ClusterAnnotation class]]) {
        ClusterAnnotation* anno = (ClusterAnnotation*)annotation;
        MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier: [NSString stringWithFormat: @"cluster%ld", (long)anno.cluster.objectsCount]];
        
        if (annotationImage) {
            return annotationImage;
        } else {
            ClusterAnnotationView* annotationView = [[ClusterAnnotationView alloc] initWithCluster: anno.cluster];
            UIImage *image = [annotationView imageByRenderingView];
            UIImage* newImage = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
            return [MGLAnnotationImage annotationImageWithImage: newImage reuseIdentifier: [NSString stringWithFormat: @"cluster%ld", (long)anno.cluster.objectsCount]];
        }
    }
    
    //Events.
    else if ([annotation isKindOfClass:[EventAnnotation class]]) {
        EventAnnotation *eAnnotation = (EventAnnotation*)annotation;
        
        NSString* identifer = [eAnnotation getIdentiferString];
        MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier: identifer];
        
        if (annotationImage) {
            return annotationImage;
        } else {
            UIImage* image;
            
            if(eAnnotation.isSelected) {
                image = [eAnnotation getDoubleIconForAnnotation];
            } else {
                image = [eAnnotation getIconForAnnotation];
            }
            UIImage* newImage = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
            return [MGLAnnotationImage annotationImageWithImage: newImage reuseIdentifier: identifer];
        }
    }

    //Member Only Events.
    else if([annotation isKindOfClass: [MemberOnlyEventAnnotation class]])
    {
        MemberOnlyEventAnnotation *eAnnotation = (MemberOnlyEventAnnotation*)annotation;
        NSString* identifier = [eAnnotation getIdentifier];
        MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier: identifier];
        
        if (annotationImage) {
            return annotationImage;
        } else {
            
            UIImage* image;
            if(eAnnotation.isSelected) {
                image = [eAnnotation getDoubleIconForAnnotation];
            } else {
                image = [eAnnotation getIconForAnnotation];
            }
            
            UIImage* newImage = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
            return [MGLAnnotationImage annotationImageWithImage: newImage reuseIdentifier: identifier];
        }
    }
    
    //Shop
    else if([annotation isKindOfClass: [ShopAnnotation class]])
    {
        ShopAnnotation *eAnnotation = (ShopAnnotation*)annotation;
        NSString* identifier = [eAnnotation getIdentifier];
        MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier: identifier];
        
        if (annotationImage) {
            return annotationImage;
        } else {
            
            UIImage* image;
            if(eAnnotation.isSelected) {
                image = [eAnnotation getDoubleIconForAnnotation];
            } else {
                image = [eAnnotation getIconForAnnotation];
            }
            
            UIImage* newImage = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
            return [MGLAnnotationImage annotationImageWithImage: newImage reuseIdentifier: identifier];
        }
    }
    // Fallback to the default marker image.
    return nil;
}

- (BOOL)mapView:(__unused MGLMapView *)mapView annotationCanShowCallout:(__unused id <MGLAnnotation>)annotation {
    return NO;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return COLOR_GREEN_BTN;
}


#pragma mark - Deep Link.
- (void) selectEvent: (Event*) e {
    selectedEvent = e;
    [self zoomMapView: e.lat lng: e.lng rate: MAP_ZOOM_LEVEL];
    [self performSelector: @selector(selectEventAnnotation) withObject: self afterDelay: 0.2f];
}

- (void) selectEventAnnotation {
    BOOL isExist = NO;
    for(id anno in arrAnnotations)
    {
        if([anno isKindOfClass: [EventAnnotation class]])
        {
            Event* event = [(EventAnnotation*)anno event];
            if([event.event_id intValue] == [selectedEvent.event_id intValue])
            {
                [(EventAnnotation*)anno setIsSelected: YES];
                [clusterMapView selectAnnotation: anno animated: NO];
                isExist = YES;
                return;
            }
        }
    }
    
    if(!isExist) {
        EventAnnotation *annotation = [[EventAnnotation alloc] initWithEvent: selectedEvent];
        annotation.event = selectedEvent;
        annotation.isSelected = YES;
        [arrAnnotations addObject: annotation];
        [self.qTree cleanup];
        
        if(arrAnnotations == nil || [arrAnnotations count] == 0) {
            [clusterMapView removeAnnotations: clusterMapView.annotations];
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                           {
                               for(id annotation in arrAnnotations) {
                                   [self.qTree insertObject:annotation];
                                   dispatch_async(dispatch_get_main_queue(), ^
                                                  {
                                                      [self reloadAnnotations];
                                                  });
                               }
                           });
        }
    }
}

- (void) showEventInCenter: (Event*) e
{
    selectedEvent = e;
    [self zoomMapView: e.lat lng: e.lng rate: 14];
    [self.menuContainerViewController setMenuState: MFSideMenuStateClosed];
    [self performSelector: @selector(selectEventAnnotation) withObject: self afterDelay: 0.2f];
 }

#pragma mark - Event List.

- (IBAction) actionEvents:(id)sender
{
    if([AppEngine sharedInstance].currentUser == nil) return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventListViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"EventListViewController"];
    nextView.arrAllEvents = arrAllEvents;
    nextView.arrAttendingEvents = arrAttendingEvents;
    nextView.arrOrganizingEvents = arrOrganizingEvents;
    nextView.currentLocation = clusterMapView.centerCoordinate;
    nextView.homeViewController = self;
    [self.navigationController pushViewController: nextView animated: YES];    
}

#pragma mark - Manage Events.

- (void) updateEvent: (Event*) e
{
    //Checking Attending Events.
    int index = 0;
    for(Event* item in arrAttendingEvents)
    {
        if([item.event_id isEqual: e.event_id])
        {
            [arrAttendingEvents replaceObjectAtIndex: index withObject: e];
            break;
        }
        
        index ++;
    }
    
    //Checking My Events.
    index = 0;
    for(Event* item in arrOrganizingEvents)
    {
        if([item.event_id isEqual: e.event_id])
        {
            [arrOrganizingEvents replaceObjectAtIndex: index withObject: e];
            break;
        }
        
        index ++;
    }
    
    //Map Update.
    BOOL isExist = NO;
    index = 0;
    for(Event* item in arrAllEvents)
    {
        if([item.event_id isEqual: e.event_id])
        {
            isExist = YES;
            [arrAllEvents replaceObjectAtIndex: index withObject: e];
            break;
        }
        
        index ++;
    }
    
    if(!isExist)
    {
        [arrAllEvents addObject: e];
    }
    
    [self refreshMapView];
}

- (void) removeEvent: (int) event_id
{
    //Checking My Events.
    for(Event* e in arrOrganizingEvents)
    {
        if([e.event_id intValue] == event_id)
        {
            [arrOrganizingEvents removeObject: e];
            break;
        }
    }
    
    //Checking Attend Events.
    for(Event* e in arrAttendingEvents)
    {
        if([e.event_id intValue] == event_id)
        {
            [arrAttendingEvents removeObject: e];
            break;
        }
    }
    
    //Checking Map
    for(Event* item in arrAllEvents)
    {
        if([item.event_id intValue] == event_id)
        {
            [arrAllEvents removeObject: item];
            break;
        }
    }
    
    [[CoreHelper sharedInstance] deleteEvent: event_id];
    [self refreshMapView];
}

#pragma mark - Event Detail.
- (void) initEventDetail {
    
    btRunIt.layer.masksToBounds = YES;
    btRunIt.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    btShare.layer.masksToBounds = YES;
    btShare.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    viEventDetail.frame = CGRectMake(0, self.view.frame.size.height - viEventDetail.frame.size.height, self.view.frame.size.width, viEventDetail.frame.size.height);
    [self.view addSubview: viEventDetail];
    
    viEventDetail.frame = CGRectMake(-viEventDetail.frame.size.width, viEventDetail.frame.origin.y, viEventDetail.frame.size.width, viEventDetail.frame.size.height);
    viEventDetail.hidden = YES;
    
    //Full View.
    btFullRunIt.layer.masksToBounds = YES;
    btFullRunIt.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    viEventDetailFull.frame = CGRectMake(0, self.view.frame.size.height - viEventDetailFull.frame.size.height, viEventDetailFull.frame.size.width, viEventDetailFull.frame.size.height);
    [self.view addSubview: viEventDetailFull];
    viEventDetailFull.hidden = YES;
    
    //Shop.
    UITapGestureRecognizer* tapPhoneShop = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapPhone:)];
    tapPhoneShop.numberOfTapsRequired = 1;
    lbShopPhoneFull.userInteractionEnabled = YES;
    [lbShopPhoneFull addGestureRecognizer: tapPhoneShop];
    
    //Member Only Event.
    UITapGestureRecognizer* tapPhoneMemberOnly = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapPhone:)];
    tapPhoneMemberOnly.numberOfTapsRequired = 1;
    lbMemberOnlyPhoneFull.userInteractionEnabled = YES;
    [lbMemberOnlyPhoneFull addGestureRecognizer: tapPhoneMemberOnly];
    
    UISwipeGestureRecognizer* gestureSwipeOpen = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(actionShowMore:)];
    gestureSwipeOpen.direction = UISwipeGestureRecognizerDirectionUp;
    [viEventDetail addGestureRecognizer: gestureSwipeOpen];
    
    UISwipeGestureRecognizer* gestureSwipeCloseSummpery = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(actionCloseEventDetail:)];
    gestureSwipeCloseSummpery.direction = UISwipeGestureRecognizerDirectionDown;
    [viEventDetail addGestureRecognizer: gestureSwipeCloseSummpery];
    
    
    UISwipeGestureRecognizer* gestureSwipeClose = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(actionCloseEventFull:)];
    gestureSwipeClose.direction = UISwipeGestureRecognizerDirectionDown;
    [viEventDetailFull addGestureRecognizer: gestureSwipeClose];
}

- (void) showEventDetail: (Event*) e {
    
    selectedEvent = e;
    isEventSelected = YES;
    
    viEventDetailInfoContainer.hidden = NO;
    viEventDetailFullInfoContainer.hidden = NO;
    viMemberOnlyContainer.hidden = YES;
    viMemberOnlyFull.hidden = YES;
    viShopContainer.hidden = YES;
    viShopFullContainer.hidden = YES;

    
    //Fill out all information.
    lbEventTitle.text = e.name;
    lbEventFullTitle.text = e.name;
    
    lbEventInfo.text = [NSString stringWithFormat: @"%@ | %@", [e getExpireDateAndTime], [e getDistanceString]];
    lbEventFullInfo.text = lbEventInfo.text;
    
    lbEventFullTime.text = [NSString stringWithFormat: @"Time: %@", [e getExpireDateAndTime]];
    lbEventFullLocation.text = [NSString stringWithFormat: @"Location: %@", e.address];
    lbEventFullType.text = [NSString stringWithFormat: @"Type: %@", [ARRAY_TYPE objectAtIndex: e.type]];
    lbEventFullPace.text = [e getLevelString];
    lbEventFullVisibility.text = [NSString stringWithFormat: @"Visibility: %@", [ARRAY_VISIBILITY objectAtIndex: e.visibility]];
    lbEventFullDescription.text = [NSString stringWithFormat: @"Description: %@", e.note];
    
    btEventFullWebsite.hidden = YES;
    if(e.website != nil && [e.website length] > 0) {
        btEventFullWebsite.hidden = NO;
    }
    
    //Check Button Title.
    [self checkRunButtonTitle: e];
    [self openDetailPage];
}

- (void) openDetailPage {
    
    //Show Dialog
    viEventDetail.hidden = NO;
    viEventDetail.frame = CGRectMake(-viEventDetail.frame.size.width, viEventDetail.frame.origin.y, viEventDetail.frame.size.width, viEventDetail.frame.size.height);
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         
                         viEventDetail.frame = CGRectMake(0, viEventDetail.frame.origin.y, viEventDetail.frame.size.width, viEventDetail.frame.size.height);
                         constraintMapBottom.constant = viEventDetail.frame.size.height;
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         if(selectedEvent) {
                             [self showRoute: selectedEvent];
                         }
                     }];
}

- (void) checkRunButtonTitle: (Event*) e {
    
    if([AppEngine sharedInstance].currentUser == nil) {
        lbEventAttendee.hidden = YES;
        btRunIt.hidden = YES;
        btFullRunIt.hidden = YES;
    }
    else {
        lbEventAttendee.hidden = NO;
        btRunIt.hidden = NO;
        btFullRunIt.hidden = NO;
        
        if (e.attendees>0) {
            lbEventAttendee.text = [NSString stringWithFormat: @"%d Attendees", e.attendees + 1];
        } else {
            lbEventAttendee.text = [NSString stringWithFormat: @"%d Attendee", e.attendees + 1];
        }
        
        if(e.post_user_id != nil && [e.post_user_id intValue] == [[AppEngine sharedInstance].currentUser.user_id intValue]) {
            [btRunIt setTitle: @"share." forState: UIControlStateNormal];
            [btFullRunIt setTitle: @"share." forState: UIControlStateNormal];
            btRunIt.backgroundColor = COLOR_GREEN_BTN;
            btFullRunIt.backgroundColor = COLOR_GREEN_BTN;
            
            btAddImages.hidden = NO;
            lbAddImages.hidden = NO;
        }
        else if(e.is_attended) {
            if(e.allow_invite_request) {
                [btRunIt setTitle: @"share." forState: UIControlStateNormal];
                [btFullRunIt setTitle: @"share." forState: UIControlStateNormal];
                btRunIt.backgroundColor = COLOR_GREEN_BTN;
                btFullRunIt.backgroundColor = COLOR_GREEN_BTN;
                
            } else {
                [btRunIt setTitle: @"cancel." forState: UIControlStateNormal];
                [btFullRunIt setTitle: @"cancel." forState: UIControlStateNormal];
                btRunIt.backgroundColor = COLOR_RED_BTN;
                btFullRunIt.backgroundColor = COLOR_RED_BTN;
            }

            btAddImages.hidden = NO;
            lbAddImages.hidden = NO;
        }
        else {
            [btRunIt setTitle: @"run it." forState: UIControlStateNormal];
            [btFullRunIt setTitle: @"run it." forState: UIControlStateNormal];
            btRunIt.backgroundColor = COLOR_GREEN_BTN;
            btFullRunIt.backgroundColor = COLOR_GREEN_BTN;
            
            btAddImages.hidden = YES;
            lbAddImages.hidden = YES;
        }
    }
}

- (void) fetchAttendImages: (Event*) e {
    [[NetworkClient sharedClient] getAttendImages: e
                                          success:^(NSDictionary *responseObject) {
                                              NSLog(@"get attend images result = %@", responseObject);
                                              NSMutableArray* arrAttendImages = [[NSMutableArray alloc] init];

                                              if(e.main_image != nil && [e.main_image length] > 0) {
                                                  [arrAttendImages addObject: [AppEngine getImageURL: e.main_image]];
                                              }
                                              
                                              int successStatus = [responseObject[@"success"] intValue];
                                              if(successStatus)
                                              {
                                                  NSArray* array = responseObject[@"data"][@"attend_images"];
                                                  if(array != nil)
                                                  {
                                                      for(NSDictionary* dicItem in array)
                                                      {
                                                          AttendImage* image = [[AttendImage alloc] initWithDictionary: dicItem];
                                                          [arrAttendImages addObject: image.image_url];
                                                      }
                                                  }
                                              }
                                              
                                              [self updatePhotos: arrAttendImages];
                                              
                                          } failure:^(NSError *error) {
                                              
                                              NSLog(@"get attend images error = %@", error);
                                          }];
}

- (void) clearPhotoView {
    //Remove old images.
    for (UIView* v in scEventFullPhotos.subviews) {
        [v removeFromSuperview];
    }
    
    pgEventFullPhotos.numberOfPages = 0;
}

- (void) updatePhotos: (NSMutableArray*) arrImages {
    [self clearPhotoView];
    
    float fx = 0;
    float fy = 0;
    float fw = scEventFullPhotos.frame.size.width;
    float fh = scEventFullPhotos.frame.size.height;
    
    pgEventFullPhotos.numberOfPages = (int)arrImages.count;
    
    if(arrImages.count == 0) {
        ERImageView* cell = [[ERImageView alloc] initWithFrame: CGRectMake(fx, fy, fw, fh)];
        cell.layer.masksToBounds = YES;
        cell.contentMode = UIViewContentModeScaleAspectFill;
        cell.image = [UIImage imageNamed: @"event_default"];
        [scEventFullPhotos addSubview: cell];
    }
    else {
        for (NSURL* url in arrImages) {
            ERImageView* cell = [[ERImageView alloc] initWithFrame: CGRectMake(fx, fy, fw, fh)];
            cell.layer.masksToBounds = YES;
            cell.contentMode = UIViewContentModeScaleAspectFill;
            cell.imageURL = url;
            [cell setImageWithURL: url];
            [scEventFullPhotos addSubview: cell];
            cell.userInteractionEnabled = YES;
            
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapImage:)];
            [cell addGestureRecognizer: tapGesture];
            
            fx += fw;
        }
    }
    
    [scEventFullPhotos setContentSize: CGSizeMake(fx, 0)];
}

- (void) didTapImage: (UITapGestureRecognizer*)gestureRecognizer {
    ERImageView *imageView = (ERImageView*)gestureRecognizer.view;
    ivFull.image = nil;
    [ivFull setImageWithURL: imageView.imageURL];
    viFullScreen.hidden = NO;
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    if(scrollView == scEventFullPhotos) {
        NSInteger pageNumber = roundf(scrollView.contentOffset.x / (scrollView.frame.size.width));
        pgEventFullPhotos.currentPage = pageNumber;
    }
}
- (IBAction)actionAddImage:(id)sender
{
    if([AppEngine sharedInstance].currentUser == nil) return;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Select Source" message: nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle: @"Take Photo" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                                    {
                                        imagePicker = [[UIImagePickerController alloc] init];
                                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        imagePicker.allowsEditing = YES;
                                        imagePicker.delegate = self;
                                        [self presentViewController:imagePicker animated:YES completion:nil];
                                    }
                                }];
    
    UIAlertAction* loadFromGallery = [UIAlertAction actionWithTitle: @"Load from Gallery" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
                                          {
                                              imagePicker = [[UIImagePickerController alloc] init];
                                              imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                              imagePicker.allowsEditing = YES;
                                              imagePicker.delegate = self;
                                              [self presentViewController:imagePicker animated:YES completion:nil];
                                          }
                                      }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction: takePhoto];
    [alert addAction: loadFromGallery];
    [alert addAction: cancel];
    
    [self presentViewController: alert animated: YES completion: nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated: YES completion:^{
        
        [SVProgressHUD show];
        NSData* imgData = UIImageJPEGRepresentation(image, IMAGE_COMPRESSION_RATE);
        [[JAmazonS3ClientManager defaultManager] uploadPostPhotoData: imgData
                                                             fileKey: [AppEngine getImageName]
                                                    withProcessBlock:^(float progress) {
                                                        
                                                    } completeBlock:^(NSString *imagePath) {
                                                        
                                                        NSLog(@"Uploaded Photo = %@", imagePath);
                                                        [[NetworkClient sharedClient] uploadAttendImage: imagePath
                                                                                                user_id: [AppEngine sharedInstance].currentUser.user_id
                                                                                                  event: selectedEvent
                                                                                                success:^(NSDictionary *responseObject) {
                                                                                                    
                                                                                                    [SVProgressHUD dismiss];
                                                                                                    NSLog(@"attend image upload = %@", responseObject);
                                                                                                    
                                                                                                    int successStatus = [[responseObject valueForKey: @"success"] intValue];
                                                                                                    if(successStatus)
                                                                                                    {
                                                                                                        [self fetchAttendImages: selectedEvent];
                                                                                                    }
                                                                                                    
                                                                                                } failure:^(NSError *error) {
                                                                                                    
                                                                                                    [SVProgressHUD dismiss];
                                                                                                    NSLog(@"attend image upload error = %@", error.description);
                                                                                                }];
                                                        
                                                        
                                                    }];
    }];
}


- (IBAction) actionCloseEventDetail:(id)sender {
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         
                         viEventDetail.frame = CGRectMake(viEventDetail.frame.size.width, viEventDetail.frame.origin.y, viEventDetail.frame.size.width, viEventDetail.frame.size.height);
                         constraintMapBottom.constant = 0;
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         viEventDetail.hidden = YES;
                         viEventDetail.frame = CGRectMake(-viEventDetail.frame.size.width, viEventDetail.frame.origin.y, viEventDetail.frame.size.width, viEventDetail.frame.size.height);
                         
                         isEventSelected = NO;
                         currentSelectedAnnotation.isSelected = NO;
                         [clusterMapView deselectAnnotation: currentSelectedAnnotation animated: YES];
                         [self deselectAnnotation];
                         
                         [self reloadAnnotations];
                     }];
}

- (void) deselectAnnotation {
    
    if(currentSelectedAnnotation) {
        [clusterMapView removeOverlays: arrPolylines];
        [clusterMapView removeAnnotations: arrPins];
        [arrPins removeAllObjects];
        
        //Event.
        if ([currentSelectedAnnotation isKindOfClass:[EventAnnotation class]]) {
//            currentSelectedAnnotationView.image = [currentSelectedAnnotation getIconForAnnotation];
        }
        
        //Member Only Events.
        else if([currentSelectedAnnotation isKindOfClass: [MemberOnlyEventAnnotation class]])
        {
//            currentSelectedAnnotationView.image = [currentSelectedAnnotation getIconForAnnotation];
        }
        
        //Shop
        else if([currentSelectedAnnotation isKindOfClass: [ShopAnnotation class]]) {
//            currentSelectedAnnotationView.image = [currentSelectedAnnotation getIconForAnnotation];
        }

        [clusterMapView removeAnnotation: currentSelectedAnnotation];
        [clusterMapView addAnnotation: currentSelectedAnnotation];

        if(currentSelectedAnnotation != nil) {
            currentSelectedAnnotation.isSelected = NO;
            currentSelectedAnnotation = nil;
        }
        
        selectedEvent = nil;
        selectedShop = nil;
        selectedMemberOnlyEvent = nil;
    }

}

- (void) showRoute: (Event*) currentEvent
{
    [clusterMapView removeAnnotations: arrPins];
    [arrPins removeAllObjects];
    
    //Set Safe Zone.
    for(int i = 0; i < [currentEvent.map_points count]; i++)
    {
        NSString* strRecord = [currentEvent.map_points objectAtIndex: i];
        NSArray* arrItem = [strRecord componentsSeparatedByString: @","];
        
        if(arrItem != nil && [arrItem count] > 1)
        {
            double lat = [[arrItem objectAtIndex: 0] doubleValue];
            double lng = [[arrItem objectAtIndex: 1] doubleValue];
            
            BasicMapAnnotation* mAnnot = [[BasicMapAnnotation alloc] init];
            mAnnot.coordinate = [[CLLocation alloc] initWithLatitude: lat longitude: lng].coordinate;
            mAnnot.mIndex = (int)i;
            mAnnot.title = PIN_TOP_MESSAGE;
            mAnnot.hidden = YES;
            mAnnot.mKey = LOCATION_PIN;
            [arrPins addObject: mAnnot];
            [clusterMapView addAnnotation:mAnnot];
        }
    }
    
    [self updateRegion];
    [clusterMapView showAnnotations: arrPins animated: NO];
}

- (void) removeRoute {
    [clusterMapView removeAnnotations: arrPins];
    [arrPins removeAllObjects];
}

- (void) updateRegion
{
    [clusterMapView removeOverlays: arrPolylines];
    
    // remove polyline if one exists
    if([arrPins count] > 1)
    {
        [arrPolylines removeAllObjects];
        CLLocationCoordinate2D coordinates[arrPins.count + 1];
        for (int i = 0; i < [arrPins count]; i++)
        {
            BasicMapAnnotation* annotation = [arrPins objectAtIndex: i];
            coordinates[i] = annotation.coordinate;
        }
        
        MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates: coordinates count: arrPins.count];
        [arrPolylines addObject: polyline];
        [clusterMapView addOverlay: polyline];
    }
}

- (IBAction) actionDirection:(id)sender
{
    float lat = 0;
    float lng = 0;
    NSString* name = @"";
    
    if(selectedEvent != nil)
    {
        lat = selectedEvent.lat;
        lng = selectedEvent.lng;
        name = @"Destination";
    }
    else if(selectedMemberOnlyEvent != nil) {
        lat = selectedMemberOnlyEvent.lat;
        lng = selectedMemberOnlyEvent.lng;
        name = @"Destination";
    }
    else if(selectedShop != nil)
    {
        lat = [selectedShop.lat doubleValue];
        lng = [selectedShop.lng doubleValue];
        name = selectedShop.name;
    }
    
    [self showDirection: lat lng: lng name: name];
}

- (void) showDirection: (float) lat lng: (float) lng name: (NSString*) name
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate                                                                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName: name];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}


- (IBAction) actionShowMore:(id)sender {
    if (selectedEvent != nil) {
        [self loadAttendedUsers: selectedEvent];
    }
        
    viEventDetailFull.hidden = NO;
    viEventDetailFull.alpha = 0;
    viEventDetailFull.frame = viEventDetail.frame;
    float offset = 62.0;
    
    [self clearPhotoView];
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         viEventDetailFull.alpha = 1;
                         viEventDetailFull.frame = CGRectMake(0,
                                                              self.viTop.frame.size.height - offset,
                                                              viEventDetailFull.frame.size.width,
                                                              self.view.frame.size.height - self.viTop.frame.size.height + offset);
                         
                     } completion:^(BOOL finished) {
                         //Images for Event.
                         [self fetchAttendImages: selectedEvent];
                     }];
}

- (void) loadAttendedUsers: (Event*) e {
    [[NetworkClient sharedClient] getAttendedUserList: e success:^(NSDictionary *responseObject) {
        int success = [[responseObject valueForKey: @"success"] intValue];
        if(success && [responseObject valueForKey: @"data"])
        {
            [selectedEvent.arrAttendedUsers removeAllObjects];
            
            //Post User.
            NSDictionary* dicPostUser = [responseObject valueForKey: @"data"][@"post_user"];
            if(dicPostUser != nil)
            {
                User* postUser = [[User alloc] initWithDictionary: dicPostUser];
                [selectedEvent.arrAttendedUsers addObject: postUser];
            }
            
            //User List.
            NSArray* arrUsers = [responseObject valueForKey: @"data"][@"users"];
            if(arrUsers != nil)
            {
                for(NSDictionary* dicUser in arrUsers)
                {
                    User* u = [[User alloc] initWithDictionary: dicUser];
                    [selectedEvent.arrAttendedUsers addObject: u];
                }
            }
            
            [self updateAttendedUserUI];
        }

    } failure:^(NSError *error) {
        
    }];
}

- (void) updateAttendedUserUI {
    for(UIView* v in scEventFullAttending.subviews) {
        [v removeFromSuperview];
    }
    
    float fx = 20;
    float fy = 0;
    float fw = 32;
    float fh = 32;
    
    int index = 0;
    for(User* u in selectedEvent.arrAttendedUsers) {
        
        UIButton* cell = [[UIButton alloc] initWithFrame: CGRectMake(fx, fy, fw, fh)];
        if([u.profile_photo length] > 0) {
            [cell setImageForState: UIControlStateNormal withURL: [AppEngine getImageURL: u.profile_photo] placeholderImage: [UIImage imageNamed: @"default_user.png"]];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = cell.frame.size.width / 2.0;
        cell.contentMode = UIViewContentModeScaleAspectFill;
        cell.tag = index;
        [cell addTarget: self action: @selector(selectedAttedUser:) forControlEvents: UIControlEventTouchUpInside];
        [scEventFullAttending addSubview: cell];
        
        fx += fw + 8.0;
        
        index ++;
    }
    
    [scEventFullAttending setContentSize: CGSizeMake(fx, 0)];
}

- (void) selectedAttedUser: (UIButton*) btn {
    int index = (int)btn.tag;
    User* u = [selectedEvent.arrAttendedUsers objectAtIndex: index];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"OtherUserViewController"];
    nextView.userInfo = u;
    [self.navigationController pushViewController: nextView animated: YES];
}

- (IBAction) actionCloseEventFull:(id)sender {
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         viEventDetailFull.frame = viEventDetail.frame;
                         viEventDetailFull.alpha = 0;
                     } completion:^(BOOL finished) {
                         viEventDetailFull.hidden = YES;
                         
                     }];
}


- (IBAction)shareButtonClick:(id)sender {
    [self shareService:selectedMemberOnlyEvent completedHander:^{
        
    }];
}

- (void) shareService: (MemberOnlyEvent*) e completedHander: (void (^)(void))completed
{

    completeBlock = completed;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Share" message: @"Would you like to share this service with your friends"
                                                            preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction* facebookAction = [UIAlertAction actionWithTitle: @"Facebook"
                                                             style: UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               [self shareServiceFB: e completedHander: completed];
                                                               
                                                           }];
    UIAlertAction* twitterAction = [UIAlertAction actionWithTitle: @"Twitter"
                                                            style: UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [self shareServiceTwitter: e completedHander: completed];
                                                          }];
    UIAlertAction* messageAction = [UIAlertAction actionWithTitle: @"Message"
                                                            style: UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [self shareSeviceMessage: e completedHander: completed];
                                                          }];
    UIAlertAction* emailAction = [UIAlertAction actionWithTitle: @"Email"
                                                          style: UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            [self shareServiceEmail: e completedHander: completed];
                                                        }];
    
    UIAlertAction* instagramAction = [UIAlertAction actionWithTitle: @"Instagram"
                                                              style: UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                
                                                                [self shareServiceInstagram:e completedHander: completed];
                                                            }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle: @"No Thanks"
                                                           style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             completed();
                                                         }];
    [alert addAction: facebookAction];
    [alert addAction: twitterAction];
    [alert addAction: messageAction];
    [alert addAction: emailAction];
    [alert addAction: instagramAction];
    [alert addAction: cancelAction];
    [self presentViewController: alert animated: YES completion: nil];
}

#pragma mark - Sharing.

- (void) shareServiceFB: (MemberOnlyEvent*) e completedHander: (void (^)(void))completed
{

    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", e.event_id], @"event_id", nil];
    [SVProgressHUD showWithStatus: @"event link copied to clipboard, feel free to paste"];
    [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
     {
         UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:e.img]]];
         
         [SVProgressHUD dismiss];
         
         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
         pasteboard.string = [NSString stringWithFormat: @"%@\n%@", @"I would like you to check out this place I found on the #everybody run app, click for details:", url];
         
         FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
         photo.image = image;
         photo.userGenerated = YES;
         
         FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
         content.photos = @[photo];
         
         content.hashtag = [FBSDKHashtag hashtagWithString: @"#everybodyrun"];
         
         FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
         dialog.mode = FBSDKShareDialogModeAutomatic;
         dialog.shareContent = content;
         dialog.delegate = self;
         dialog.fromViewController = self;
         [dialog show];

     }];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"fb share result = %@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"fb share error = %@", error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
}

- (void) shareServiceTwitter: (MemberOnlyEvent*) e completedHander: (void (^)(void))completed
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] && [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter])
    {
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", e.event_id], @"event_id", nil];
        [SVProgressHUD show];
        [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
         {
             [SVProgressHUD dismiss];
             SLComposeViewController *tweetSheet = [SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeTwitter];
             
             [tweetSheet setInitialText: @"I would like you to check out this place I found on the #everybody run app, click for details:"];
             [tweetSheet addURL: [NSURL URLWithString: url]];
             SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
             {
                 completed();
             };
             
             tweetSheet.completionHandler = myBlock;
             UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:e.img]]];
             [tweetSheet addImage: image];
             [self presentViewController:tweetSheet animated:YES completion: nil];
         }];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"No Twitter Accounts"
                                                                       message: @"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                                                preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [alert addAction: actionOk];
        [self presentViewController: alert animated: YES completion: nil];
    }
}

- (void) shareSeviceMessage: (MemberOnlyEvent*) e completedHander: (void (^)(void))completed
{
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message:  @"Your device doesn't support SMS!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", e.event_id], @"event_id", nil];
    [SVProgressHUD show];
    [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
     {
         [SVProgressHUD dismiss];
         
         NSString *message = [NSString stringWithFormat: @"%@\n%@", @"I would like you to check out this place I found on the #everybody run app, click for details:", url];
         MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
         messageController.messageComposeDelegate = self;
         [messageController setBody: [NSString stringWithFormat: @"%@\n%@", message, url]];
         UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:e.img]]];
         NSData* imageData = UIImagePNGRepresentation(image);
         [messageController addAttachmentData: imageData typeIdentifier: @"public.data" filename: @"image.png"];
         [self presentViewController:messageController animated:YES completion:nil];

     }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    completeBlock();
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    completeBlock();
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) shareServiceEmail: (MemberOnlyEvent*) e completedHander: (void (^)(void))completed
{
    if(![MFMailComposeViewController canSendMail])
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message:  @"Your device doesn't support Email!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", e.event_id], @"event_id", nil];
    [SVProgressHUD show];
    [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
     {
         [SVProgressHUD dismiss];
         // Email Content
         NSString *messageBody = @"I would like you to check out this place I found on the #everybody run app, click for details:";
         MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
         mc.mailComposeDelegate = self;
         [mc setMessageBody: [NSString stringWithFormat: @"%@\n%@", messageBody, url] isHTML:NO];
         
         UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:e.img]]];

         NSData* imageData = UIImagePNGRepresentation(image);
         [mc addAttachmentData: imageData mimeType: @"image/png" fileName: @"image.png"];
         [self presentViewController:mc animated:YES completion:nil];
     }];
}

- (void) shareServiceInstagram: (MemberOnlyEvent*) e completedHander: (void (^)(void))completed
{
    //Sharing Instagram.
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:e.img]]];
        
        UIImage* imageNew = [self addWaterMark: image];
        NSData *imageData=UIImagePNGRepresentation(imageNew);
        NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
        if (![imageData writeToFile:writePath atomically:YES]) {
            // failure
            NSLog(@"image save failed to path %@", writePath);
        }
        else {
            // success.
        }
        
        NSURL *imageURL=[NSURL fileURLWithPath: writePath];
        docController = [UIDocumentInteractionController interactionControllerWithURL: imageURL];
        //        docController.UTI=@"com.instagram.photo";
        docController.delegate = self;
        [docController presentOpenInMenuFromRect: self.view.frame inView: self.view animated: YES];

    }
    else
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message: MSG_INSTAGRAM_NOT_SUPPORT
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
    }
    
}

- (UIImage*) addWaterMark: (UIImage*) backgroundImage
{
    //    CGRect screenBound = [[UIScreen mainScreen] bounds];
    //    float scale = [UIScreen mainScreen].scale;
    //    UIImage* croppedImage = [self imageByCroppingImage: backgroundImage width: screenBound.size.width * scale];
    
    UIImage* croppedImage = backgroundImage;
    UIImage *watermarkImage = [UIImage imageNamed:@"mask_image.png"];
    
    UIGraphicsBeginImageContextWithOptions(croppedImage.size, YES, croppedImage.scale);
    [croppedImage drawInRect:CGRectMake(0, 0, croppedImage.size.width, croppedImage.size.height)];
    
    float fw = watermarkImage.size.width / 2.0;
    float fh = watermarkImage.size.height / 2.0;
    float offset = 17.0;
    
    [watermarkImage drawInRect:CGRectMake(croppedImage.size.width - fw - offset,
                                          offset,
                                          fw,
                                          fh)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (void) postInstagrame: (UIImage*) image completedHander: (void (^)(void))completed
{
    completeBlock = completed;
    
    //Sharing Instagram.
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        UIImage* imageNew = [self addWaterMark: image];
        NSData *imageData=UIImagePNGRepresentation(imageNew);
        NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
        if (![imageData writeToFile:writePath atomically:YES]) {
            // failure
            NSLog(@"image save failed to path %@", writePath);
        }
        else {
            // success.
        }
        
        NSURL *imageURL=[NSURL fileURLWithPath: writePath];
        docController = [UIDocumentInteractionController interactionControllerWithURL: imageURL];
        //        docController.UTI=@"com.instagram.photo";
        docController.delegate = self;
        [docController presentOpenInMenuFromRect: self.view.frame inView: self.view animated: YES];
    }
    else
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message: MSG_INSTAGRAM_NOT_SUPPORT
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
    }
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(nullable NSString *)application
{
    completeBlock();
}



- (IBAction)actionRSVP:(id)sender
{
    if(([selectedEvent.post_user_id intValue] == [[AppEngine sharedInstance].currentUser.user_id intValue])) {
        [self selectedRSVP: selectedEvent];
    }
    else {
        if(!selectedEvent.is_attended) {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                     message: MSG_ASK_ADD_CALENDAR
                                                                              preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes"
                                                                style: UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                                  [AppEngine addEventToCalendar: selectedEvent];
                                                                  [self attendEvent];
                                                              }];
            [alertController addAction: yesAction];
            
            UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No"
                                                               style: UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                 [self attendEvent];
                                                             }];
            [alertController addAction: noAction];
            [self presentViewController: alertController animated: YES completion: nil];
        }
        else {
            if (selectedEvent.allow_invite_request) {
                [self selectedRSVP: selectedEvent];
            } else {
                [self cancelAttendEvent];
            }
        }
    }
}

- (void) attendEvent {
    if(selectedEvent == nil) return;
    
    [SVProgressHUD show];
    [[NetworkClient sharedClient] attendeeEvent: selectedEvent
                                   post_user_id: [AppEngine sharedInstance].currentUser.user_id
                                        success: ^(NSDictionary *responseObject) {
                                            
                                            [SVProgressHUD dismiss];
                                            
                                            NSLog(@"attended event = %@", responseObject);
                                            int success = [[responseObject valueForKey: @"success"] intValue];
                                            if(success)
                                            {
                                                selectedEvent.is_attended = YES;
                                                selectedEvent.attendees ++;
                                                
                                                [[CoreHelper sharedInstance] updateEvent: selectedEvent];
                                                [arrAttendingEvents addObject: selectedEvent];
//                                                [self addedNewAttendEvent: selectedEvent];
                                                [self checkRunButtonTitle: selectedEvent];
                                                [self loadAttendedUsers: selectedEvent];
                                            }
                                            
                                        } failure:^(NSError *error) {
                                            
                                            NSLog(@"post attend failed = %@", error.description);
                                            [SVProgressHUD dismiss];
                                        }];
}

- (void) cancelAttendEvent {
    if(selectedEvent == nil) return;
    
    [SVProgressHUD show];
    [[NetworkClient sharedClient] deleteAttend: selectedEvent
                                       user_id: [AppEngine sharedInstance].currentUser.user_id
                                       success:^(NSDictionary *responseObject) {
                                           
                                           [SVProgressHUD dismiss];
                                           NSLog(@"delete attend = %@", responseObject);
                                           
                                           int success = [[responseObject valueForKey: @"success"] intValue];
                                           if(success)
                                           {
                                               NSDictionary* dicData = [responseObject valueForKey: @"data"];
                                               
                                               //Update Event.
                                               int attendeesForEvent = [[dicData valueForKey: @"attend_count"] intValue];
                                               selectedEvent.attendees = attendeesForEvent;
                                               selectedEvent.is_attended = NO;
                                               [[CoreHelper sharedInstance] updateEvent: selectedEvent];
                                               
                                               //Remove event in Attending List.
                                               for(Event* item in arrAttendingEvents)
                                               {
                                                   if([item.event_id intValue] == [selectedEvent.event_id intValue])
                                                   {
                                                       [arrAttendingEvents removeObject: item];
                                                       break;
                                                   }
                                               }
                                               
                                               //Refresh Map.
                                               for(Event* item in arrAllEvents)
                                               {
                                                   if([item.event_id intValue] == [selectedEvent.event_id intValue])
                                                   {
                                                       item.attendees = attendeesForEvent;
                                                       item.is_attended = NO;
                                                   }
                                               }
                                               
                                               [self checkRunButtonTitle: selectedEvent];
                                               [self loadAttendedUsers: selectedEvent];
                                           }
                                           
                                       } failure:^(NSError *error) {
                                           
                                           [SVProgressHUD dismiss];
                                           NSLog(@"delete attend error = %@", error);
                                       }];
}

- (IBAction) actionEventWebSite:(id)sender {
    if(selectedEvent && selectedEvent.website) {
        [self openEventURL: selectedEvent.website title: selectedEvent.name];
    }
}

#pragma mark - Member Only Events.

- (void) showMemberOnlyEvent: (MemberOnlyEvent*) e {
    selectedMemberOnlyEvent = e;
    isEventSelected = YES;
    
    viEventDetailInfoContainer.hidden = YES;
    viEventDetailFullInfoContainer.hidden = YES;
    viMemberOnlyContainer.hidden = NO;
    viMemberOnlyFull.hidden = NO;
    viShopContainer.hidden = YES;
    viShopFullContainer.hidden = YES;
    
    lbMemberOnlyTitle.text = e.title;
    lbMemberOnlyTitleFull.text = e.title;
    
    lbMemberOnlyAddress.text = e.address;
    lbMemberOnlyAddressFull.text = e.address;
    lbMemberOnlyDescriptionFull.text = e.event_description;
    lbMemberOnlyCategory.text = e.category_title;
    lbMemberOnlyCategoryFull.text = e.category_title;
    
    lbMemberOnlyPhoneFull.text = e.tel;
    [ivMemberOnlyPhoto setImageWithURL: [NSURL URLWithString: e.img]];
    
    [self openDetailPage];
}

- (IBAction) actionMemberOnlyWebSite:(id)sender {
    if(selectedMemberOnlyEvent && selectedMemberOnlyEvent.url) {
        [self openEventURL: selectedMemberOnlyEvent.url title: selectedMemberOnlyEvent.title];
    }
}

#pragma mark - Shop.
- (void) showShop: (Shop*) s {
    selectedShop = s;
    isEventSelected = YES;
    
    viEventDetailInfoContainer.hidden = YES;
    viEventDetailFullInfoContainer.hidden = YES;
    viMemberOnlyContainer.hidden = YES;
    viMemberOnlyFull.hidden = YES;
    viShopContainer.hidden = NO;
    viShopFullContainer.hidden = NO;
    
    lbShopTitle.text = s.name;
    lbShopTitleFull.text = s.name;
    
    lbShopAddress.text = s.address;
    lbShopAddressFull.text = s.address;
    
    lbShopPhoneFull.text = s.phone;
    
    lbShopSelected.hidden = ![s.is_select boolValue];
    lbShopSelectedFull.hidden = ![s.is_select boolValue];
    
    lbShopDescriptionFull.text = s.shop_description;
    if(s.img != nil && [s.img length] > 0) {
        [ivShopPhoto setImageWithURL: [NSURL URLWithString: s.img]];
    }
    
    [self openDetailPage];
}

- (IBAction) actionShopWebsite {
    if(selectedShop && selectedShop.url) {
        [self openEventURL: selectedShop.url title: selectedShop.name];
    }
}

- (void) tapPhone: (id) sender {
    
    NSString* phoneNumber = @"";
    
    if(selectedShop) {
        phoneNumber = selectedShop.phone;
    } else if(selectedMemberOnlyEvent){
        phoneNumber = selectedMemberOnlyEvent.tel;
    }
    
    if(phoneNumber != nil && [phoneNumber length] > 0){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil message: MSG_ASK_PHONE_CALL preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString* newPhoneNumber = [AppEngine getOnlyPhoneNumbers: phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat: @"tel://%@", newPhoneNumber]]];
        }];
        [alert addAction: yesAction];
        
        UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No" style: UIAlertActionStyleCancel handler: nil];
        [alert addAction: noAction];
        [self presentViewController: alert animated: YES completion: nil];
    }
}

#pragma mark - Full Screen.

- (void) initFullScreen {
    viFullScreen.frame = self.view.bounds;
    [self.view addSubview: viFullScreen];
    viFullScreen.hidden = YES;
}

- (IBAction) actionCloseFullScreen:(id)sender {
    viFullScreen.hidden = YES;
}

@end
