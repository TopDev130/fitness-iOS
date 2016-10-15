//
//  EventListViewController.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/20/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "EventListViewController.h"
#import "RATreeView.h"
#import "TitleTableViewCell.h"
#import "DetailTableViewCell.h"
#import "CreateEventViewController.h"
#import "AttendViewController.h"
#import "RADataObject.h"
#import "HomeViewController.h"

@interface EventListViewController () <RATreeViewDelegate, RATreeViewDataSource, TitleTableViewCellDelegate, DetailTableViewCellDelegate>
{
    NSMutableArray                      *arrNearbyEvents;
    NSMutableArray                      *arrTreeData;

    int                                 currentType;
    UITextField                         *tfDescription;
}

@property (weak, nonatomic) IBOutlet RATreeView          *treeEvents;
@property (weak, nonatomic) IBOutlet UILabel             *lbNearbyTitle;
@property (weak, nonatomic) IBOutlet UILabel             *lbNearbyEvents;
@property (weak, nonatomic) IBOutlet UILabel             *lbAttendingTitle;
@property (weak, nonatomic) IBOutlet UILabel             *lbAttendingEvents;
@property (weak, nonatomic) IBOutlet UILabel             *lbOrganizingTitle;
@property (weak, nonatomic) IBOutlet UILabel             *lbOrganizingEvents;

@end

@implementation EventListViewController
@synthesize treeEvents;
@synthesize lbNearbyTitle;
@synthesize lbNearbyEvents;
@synthesize lbAttendingTitle;
@synthesize lbAttendingEvents;
@synthesize lbOrganizingTitle;
@synthesize lbOrganizingEvents;

@synthesize arrAllEvents;
@synthesize arrAttendingEvents;
@synthesize arrOrganizingEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMember
{
    [super initMember];
    
    currentType = EVENT_FILTER_NEARBY;
    arrTreeData = [[NSMutableArray alloc] init];
    arrNearbyEvents = [[NSMutableArray alloc] init];
    
    treeEvents.delegate = self;
    treeEvents.dataSource = self;
    treeEvents.separatorStyle = RATreeViewCellSeparatorStyleNone;
    treeEvents.rowsCollapsingAnimation = RATreeViewRowAnimationFade;
    
    [treeEvents registerNib: [UINib nibWithNibName: @"TitleTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TitleTableViewCell class])];
    [treeEvents registerNib: [UINib nibWithNibName: @"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([DetailTableViewCell class])];
    
    [self getNearbyEvents];
    [self updateTypeUI];
    [self loadTreeData];
}

- (void) getNearbyEvents
{
    [arrNearbyEvents removeAllObjects];
    for(Event* e in arrAllEvents)
    {
        if(![e isEventByCurrentUser] && !e.is_attended && [e isNearByEvent: self.currentLocation.latitude lng: self.currentLocation.longitude] && ![e isExpire: [AppEngine sharedInstance].filterDate]) {
            [arrNearbyEvents addObject: e];
        }
    }
}

-(void) loadTreeData
{
    lbNearbyEvents.text = [NSString stringWithFormat: @"%d events", (int)arrNearbyEvents.count];
    lbAttendingEvents.text = [NSString stringWithFormat: @"%d events", (int)arrAttendingEvents.count];
    lbOrganizingEvents.text = [NSString stringWithFormat: @"%d events", (int)arrOrganizingEvents.count];
    
    [arrTreeData removeAllObjects];
    
    NSArray* array;
    if(currentType == EVENT_FILTER_NEARBY)
    {
        array = arrNearbyEvents;
    }
    else if(currentType == EVENT_FILTER_ATTENDING)
    {
        array = arrAttendingEvents;
    }
    else
    {
        array = arrOrganizingEvents;
    }
    
    for(Event* e in array)
    {
        RADataObject* objDetail = [[RADataObject alloc] initWithEvent: e children: nil type: NODE_DETAIL];
        RADataObject* objItem = [[RADataObject alloc] initWithEvent: e children: [NSArray arrayWithObject: objDetail] type: NODE_EVENT];
        [arrTreeData addObject: objItem];
    }
}

- (void) updateTypeUI
{
    lbNearbyTitle.textColor = COLOR_SUB_TEXT;
    lbNearbyEvents.textColor = COLOR_SUB_TEXT;
    lbAttendingTitle.textColor = COLOR_SUB_TEXT;
    lbAttendingEvents.textColor = COLOR_SUB_TEXT;
    lbOrganizingTitle.textColor = COLOR_SUB_TEXT;
    lbOrganizingEvents.textColor = COLOR_SUB_TEXT;

    
    //Nearby
    if(currentType == EVENT_FILTER_NEARBY)
    {
        lbNearbyTitle.textColor = COLOR_MAIN_TEXT;
        lbNearbyEvents.textColor = COLOR_MAIN_TEXT;
    }
    
    //Attending.
    else if(currentType == EVENT_FILTER_ATTENDING)
    {
        lbAttendingTitle.textColor = COLOR_MAIN_TEXT;
        lbAttendingEvents.textColor = COLOR_MAIN_TEXT;
    }
    
    //Organizing
    else
    {
        lbOrganizingTitle.textColor = COLOR_MAIN_TEXT;
        lbOrganizingEvents.textColor = COLOR_MAIN_TEXT;
    }
}

- (IBAction) actionType:(UIButton *)sender
{
    currentType = (int)sender.tag;
    [self updateTypeUI];
    
    [self loadTreeData];
    [treeEvents reloadData];
}

- (IBAction) actionCreateEvent:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateEventViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"CreateEventViewController"];
    nextView.isEditing = NO;
    nextView.parentView = self;
    [self.navigationController pushViewController: nextView animated: YES];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"send notification button clicked!");
            break;
            
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    Event* e = [(TitleTableViewCell*)cell event];
    if([e.post_user_id intValue] == [[AppEngine sharedInstance].currentUser.user_id intValue])
    {
        //Edit
        if(index == 0)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CreateEventViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"CreateEventViewController"];
            nextView.currentEvent = e;
            nextView.isEditing = YES;
            nextView.parentView = self;
            [self.navigationController pushViewController: nextView animated: YES];
        }
        
        //Delete
        else
        {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                     message: @"Reason you are removing?"
                                                                              preferredStyle: UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Description";
                tfDescription = textField;
            }];
            
            UIAlertAction* removeAction = [UIAlertAction actionWithTitle: @"Remove"
                                                                   style: UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     
                                                                     NSString* reason = tfDescription.text;
                                                                     if(reason == nil || [reason length] == 0)
                                                                     {
                                                                         [self presentViewController: [AppEngine showAlertWithText: MSG_ASK_REASON_FOR_REMOVE]
                                                                                            animated: YES
                                                                                          completion: nil];
                                                                         return;
                                                                     }
                                                                     else
                                                                     {
                                                                         [SVProgressHUD show];
                                                                         [[NetworkClient sharedClient] deleteEvent: e
                                                                                                           user_id: [AppEngine sharedInstance].currentUser.user_id
                                                                                                            reason: reason
                                                                                                           success:^(NSDictionary *responseObject) {
                                                                                                               
                                                                                                               [SVProgressHUD dismiss];
                                                                                                               NSLog(@"delete event result = %@", responseObject);
                                                                                                               int successs = [[responseObject valueForKey: @"success"] intValue];
                                                                                                               if(successs)
                                                                                                               {
                                                                                                                   [self removeEvent: [e.event_id intValue]];
                                                                                                               }
                                                                                                               
                                                                                                           } failure:^(NSError *error) {
                                                                                                               
                                                                                                               NSLog(@"delete event error = %@", error);
                                                                                                               [SVProgressHUD dismiss];
                                                                                                           }];
                                                                     }
                                                                 }];
            [alertController addAction: removeAction];
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle: @"Cancel"
                                                                   style: UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     
                                                                 }];
            [alertController addAction: cancelAction];
            [self presentViewController: alertController animated: YES completion: nil];
        }
    }
    else
    {
        if(![e isExpire: [AppEngine sharedInstance].filterDate]) {
            if(index == 0) {
                [self goEvent: e];
            } else {
                [self removeAttend: e];
            }
        } else {
            [self removeAttend: e];
        }
    }
}

- (void) goEvent: (Event*) e {
    [(HomeViewController*)self.homeViewController selectEvent: e];
    [self actionBack: nil];
}

- (void) removeAttend: (Event*) e {
    [SVProgressHUD show];
    [[NetworkClient sharedClient] deleteAttend: e
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
                                               e.attendees = attendeesForEvent;
                                               e.is_attended = NO;
                                               [[CoreHelper sharedInstance] updateEvent: e];
                                               
                                               //Remove event in Attending List.
                                               for(Event* item in arrAttendingEvents)
                                               {
                                                   if([item.event_id intValue] == [e.event_id intValue])
                                                   {
                                                       [arrAttendingEvents removeObject: item];
                                                       break;
                                                   }
                                               }
                                               
                                               //Refresh Map.
                                               for(Event* item in arrAllEvents)
                                               {
                                                   if([item.event_id intValue] == [e.event_id intValue])
                                                   {
                                                       item.attendees = attendeesForEvent;
                                                       item.is_attended = NO;
                                                   }
                                               }
                                               
                                               [self getNearbyEvents];
                                               [self loadTreeData];
                                               [treeEvents reloadData];
                                           }
                                           
                                       } failure:^(NSError *error) {
                                           
                                           [SVProgressHUD dismiss];
                                           NSLog(@"delete attend error = %@", error);
                                       }];
}

- (void) selectedAttendees:(Event *)e
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AttendViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"AttendViewController"];
    nextView.currentEvent = e;
    [self.navigationController pushViewController: nextView animated: YES];
}

#pragma mark - DetailTableviewCell Delegate.
- (void) selectedLocation:(Event *)e {
    [self goEvent: e];
}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    RADataObject *dataObject = item;
    if(dataObject.type == NODE_EVENT)
    {
        return 44;
    }
    else
    {
        return [DetailTableViewCell getHeight];
    }
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}

#pragma mark TreeView Data Source

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item
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

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    if(dataObject.type == NODE_EVENT)
    {
        TitleTableViewCell *cell = [treeEvents dequeueReusableCellWithIdentifier:NSStringFromClass([TitleTableViewCell class])];
        cell.delegate = self;
        cell.dataDelegate = self;
        [cell setRightUtilityButtons: [self rightButtons: dataObject.event]  WithButtonWidth: 55.0];
        [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:45];

        [cell updateEvent: dataObject.event];
        return cell;
    }
    else
    {
        DetailTableViewCell *cell = [treeEvents dequeueReusableCellWithIdentifier:NSStringFromClass([DetailTableViewCell class])];
        cell.delegate = self;
        [cell updateDetailEvent: dataObject.event];
        return cell;
    }
    
    return nil;
}

- (NSArray *) leftButtons {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] title:@"MSG"];
    //Set Fonts.
    for(UIButton* btn in leftUtilityButtons)
    {
        [btn.titleLabel setFont: [UIFont fontWithName: @"CenturyGothic" size: 11.0]];
    }
    return leftUtilityButtons;
}

- (NSArray*) rightButtons: (Event*) e
{
    NSMutableArray* rightButtons = [NSMutableArray new];
    
    if(currentType == EVENT_FILTER_NEARBY)
    {
        if(![e isExpire: [AppEngine sharedInstance].filterDate]) {
            [rightButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed: 0 green: 238.0/255.0 blue: 0 alpha: 1.0] title: @"GO"];
        }
    }
    else if(currentType == EVENT_FILTER_ATTENDING)
    {
        if(![e isExpire: [AppEngine sharedInstance].filterDate]) {
            [rightButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed: 0 green: 238.0/255.0 blue: 0 alpha: 1.0] title: @"GO"];
        }        
        [rightButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed: 239.0/255.0 green: 78.0/255.0 blue: 60.0/255.0 alpha: 1.0] title: @"REMOVE"];
    }
    else
    {
        [rightButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed: 88.0/255.0 green: 89.0/255.0 blue: 91.0/255.0 alpha: 1.0] title: @"EDIT"];
        [rightButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed: 239.0/255.0 green: 78.0/255.0 blue: 60.0/255.0 alpha: 1.0] title: @"REMOVE"];
    }
    
    //Set Fonts.
    for(UIButton* btn in rightButtons)
    {
        [btn.titleLabel setFont: [UIFont fontWithName: @"CenturyGothic" size: 11.0]];
    }
    
    return rightButtons;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [arrTreeData count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [arrTreeData objectAtIndex:index];
    }
    
    return data.children[index];
}

- (void) treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    [treeView deselectRowForItem: item animated: NO];
}

#pragma mark - Event Management.

- (void) addNewMyEvent: (Event*) newEvent
{
    currentType = EVENT_FILTER_ORGANIZING;
    [arrAllEvents addObject: newEvent];
    [arrOrganizingEvents addObject: newEvent];
    
    [self updateTypeUI];
    [self loadTreeData];
    [treeEvents reloadData];
    [(HomeViewController*)self.homeViewController refreshMapView];
}

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
            [arrAllEvents replaceObjectAtIndex: index  withObject: e];
            break;
        }
        
        index ++;
    }
    
    if(!isExist)
    {
        [arrAllEvents addObject: e];
    }
    
    [self loadTreeData];
    [treeEvents reloadData];
    [(HomeViewController*)self.homeViewController refreshMapView];
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
    [self loadTreeData];
    [treeEvents reloadData];
    [(HomeViewController*)self.homeViewController refreshMapView];
}

@end
