//
//  NotificationViewController.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/19/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface NotificationViewController () <UITableViewDataSource, UITableViewDelegate, NotificationTableViewCellDelegate>
{
    NSMutableArray              *arrItems;
}

@property(nonatomic, weak) IBOutlet UITableView         *tbList;

@end

@implementation NotificationViewController
@synthesize tbList;

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
    
    arrItems = [[NSMutableArray alloc] init];
    [tbList registerNib: [UINib nibWithNibName: @"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([NotificationTableViewCell class])];
//    tbList.estimatedRowHeight = 50; //Set this to any value that works for you.
    tbList.rowHeight = UITableViewAutomaticDimension;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self loadData];
}

- (void) loadData {
    
    if([arrItems count] == 0) {
        [SVProgressHUD show];
    }
    [[NetworkClient sharedClient] getNotifications: [AppEngine sharedInstance].currentUser.user_id success:^(NSArray *array) {
        [SVProgressHUD dismiss];
        [arrItems removeAllObjects];
        [arrItems addObjectsFromArray: array];
        [tbList reloadData];
        [AppEngine sharedInstance].currentUser.unread_notification_num = (int)[array count];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"unReadEventNotification" object:nil];
        [UIApplication sharedApplication].applicationIconBadgeNumber = (int)[array count];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self presentViewController: [AppEngine showErrorWithText: MSG_INTERNET_ERROR] animated: YES completion: nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (int)[arrItems count];
}

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([NotificationTableViewCell class])];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([NotificationTableViewCell class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.delegate = self;
    [cell setNotification: [arrItems objectAtIndex: indexPath.row]];
    cell.tag = indexPath.row;
    
    UISwipeGestureRecognizer *tapRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(CellSwipeHandler:)];
    [tapRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [cell addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(CellSwipeHandler:)];
    [tapRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [cell addGestureRecognizer:tapRecognizer];
    
    return cell;
}

- (void) CellSwipeHandler:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.tbList];
    NSIndexPath *indexPath = [self.tbList indexPathForRowAtPoint:location];
    NSLog(@"%ld", (long)indexPath.row);
    NotificationTableViewCell *cell = [self.tbList cellForRowAtIndexPath:indexPath];
    
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        cell.tailingConstant.constant = 55;
    } else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        cell.tailingConstant.constant = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([AppDelegate getDelegate].homeView != nil) {
        Notification* n = [arrItems objectAtIndex: indexPath.row];
        
        [SVProgressHUD show];
        [[NetworkClient sharedClient] getSingleEvent: n.event_id
                                             user_id: [AppEngine sharedInstance].currentUser.user_id
                                             success:^(NSDictionary *dicEvent) {
                                                 
                                                 [SVProgressHUD dismiss];
                                                 Event* e = [[Event alloc] initWithDictionary: dicEvent];
                                                 [(HomeViewController*)[AppDelegate getDelegate].homeView showEventInCenter: e];
                                                 [self actionBack: nil];
                                                 
                                             } failure:^(NSError *error) {
                                                 [SVProgressHUD dismiss];
                                                 [self presentViewController: [AppEngine showErrorWithText: MSG_INTERNET_ERROR] animated: YES completion: nil];
                                             }];
    }
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self deleteNotification:(int)indexPath.row];
    }
}

- (void) deleteNotification:(int)index {
    Notification* n = [arrItems objectAtIndex: index];
//    [arrItems removeObjectAtIndex: index];
//    [tbList reloadData];
    
    [[NetworkClient sharedClient] deleteNotification: n.notification_id success:^{
        [self loadData];
    } failure:^(NSError *error) {
        
    }];
}

@end
