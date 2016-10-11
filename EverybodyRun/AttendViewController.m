//
//  AttendViewController.m
//  EverybodyRun
//
//  Created by star on 2/3/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "AttendViewController.h"
#import "AttendeeTableViewCell.h"
#import "OtherUserViewController.h"

@interface AttendViewController () <UITableViewDataSource, UITableViewDelegate, AttendeeTableViewCellDelegate>
{
    __weak IBOutlet UITableView         *tbList;
    NSMutableArray                      *arrUserList;
}

@end

@implementation AttendViewController

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
    
    arrUserList = [[NSMutableArray alloc] init];
    [tbList registerNib: [UINib nibWithNibName: @"AttendeeTableViewCell" bundle:nil] forCellReuseIdentifier: @"AttendeeTableViewCell"];
    
    [self loadAttendeeUserList];
}

- (void) loadAttendeeUserList
{
    [SVProgressHUD show];
    [[NetworkClient sharedClient] getAttendedUserList: self.currentEvent
                                              success:^(NSDictionary *responseObject) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  
                                                  NSLog(@"get attended user list = %@", responseObject);
                                                  int success = [[responseObject valueForKey: @"success"] intValue];
                                                  if(success && [responseObject valueForKey: @"data"])
                                                  {
                                                      [arrUserList removeAllObjects];
                                                      
                                                      //Post User.
                                                      NSDictionary* dicPostUser = [responseObject valueForKey: @"data"][@"post_user"];
                                                      if(dicPostUser != nil)
                                                      {
                                                          User* postUser = [[User alloc] initWithDictionary: dicPostUser];
                                                          [arrUserList addObject: postUser];
                                                      }
                                                      
                                                      //User List.
                                                      NSArray* arrUsers = [responseObject valueForKey: @"data"][@"users"];
                                                      if(arrUsers != nil)
                                                      {
                                                          for(NSDictionary* dicUser in arrUsers)
                                                          {
                                                              User* u = [[User alloc] initWithDictionary: dicUser];
                                                              [arrUserList addObject: u];
                                                          }
                                                      }
                                                      
                                                      [tbList reloadData];
                                                  }
                                                  
                                              } failure:^(NSError *error) {
                                                  
                                                  [SVProgressHUD dismiss];
                                                  NSLog(@"get attended user list error = %@", error.description);
                                                  
                                              }];
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrUserList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AttendeeTableViewCell getCellHeight];
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

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttendeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"AttendeeTableViewCell" forIndexPath:indexPath];
    [cell updateUser: [arrUserList objectAtIndex: indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void) selectedUser: (User*) u {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"OtherUserViewController"];
    nextView.userInfo = u;
    [self.navigationController pushViewController: nextView animated: YES];    
}

@end
