//
//  BlogListViewController.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "BlogListViewController.h"
#import "BlogListTableViewCell.h"
#import "BlogLocationTableViewCell.h"
#import "MFSideMenu.h"
#import "WebViewController.h"

@interface BlogListViewController () <UITableViewDataSource, UITableViewDelegate, BlogLocationTableViewCellDelegate, UIViewControllerTransitioningDelegate>
{
    NSMutableArray          *arrItems;
    BOOL                    isLocalBlog;
    Blog                    *currLocationBlog;
}

@property (nonatomic, weak) IBOutlet UITableView            *tbList;
@property (nonatomic, weak) IBOutlet UIButton               *btJournal;

@end

@implementation BlogListViewController
@synthesize tbList;
@synthesize btJournal;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    btJournal.layer.masksToBounds = YES;
    btJournal.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    isLocalBlog = NO;
    
    arrItems = [[NSMutableArray alloc] init];
    [tbList registerNib: [UINib nibWithNibName: @"BlogListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BlogListTableViewCell class])];
    [tbList registerNib: [UINib nibWithNibName: @"BlogLocationTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BlogLocationTableViewCell class])];
    tbList.estimatedRowHeight = 72.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBlogList];
}

- (void) loadBlogList {
    [[NetworkClient sharedClient] getBlogList:^(NSArray *items) {
        
        [arrItems removeAllObjects];
        [arrItems addObjectsFromArray: items];
        [tbList reloadData];
        [self updateParrentUI];
//        NSLog(@"---%d",[AppEngine sharedInstance].currentUser.unread_blog_num);
        
    } failure:^(NSString *errorMessage) {
        
    }];
}

- (void) updateParrentUI {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"unreadBlogNotification" object:nil];
}

- (void) updateUI {
    if(isLocalBlog) {
        [btJournal setTitle: @"latest." forState: UIControlStateNormal];
    }
    else {
        [btJournal setTitle: @"journal." forState: UIControlStateNormal];
    }
    [tbList reloadData];
}

- (void) checkBlogs: (CLPlacemark*) placemark {
    [[NetworkClient sharedClient] getBlogs: placemark.location.coordinate.latitude
                                       lng: placemark.location.coordinate.longitude
                                   success:^(Blog *b) {
                                       
                                       if(b)
                                       {
                                           [[NetworkClient sharedClient] getBlogImage: b.mediaURL
                                                                              success:^(NSString *url) {
                                                                                  
                                                                                  b.imageURL = url;
                                                                                  currLocationBlog = b;
                                                                                  isLocalBlog = YES;
                                                                                  [self.menuContainerViewController setMenuState: MFSideMenuStateRightMenuOpen];
                                                                                  [self updateUI];
                                                                                  
                                                                                  [self performSelector:@selector(actionCloseBlog:) withObject: self afterDelay: BLOG_HIDE_TIME];
                                                                                  
                                                                              } failure:^(NSString *errorMessage) {
                                                                                  
                                                                              }];
                                       }
                                       
                                   } failure:^(NSString *errorMessage) {
                                       
                                   }];
}

- (void) showLocalBlog: (Blog*) b {
    
    isLocalBlog = YES;
    [tbList reloadData];
}

- (void) hideLocalBlog {
    isLocalBlog = NO;
    [self updateUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(isLocalBlog) {
        return 1;
    } else {
        return (int)[arrItems count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isLocalBlog) {
        return 512;
    }
    else {
        return UITableViewAutomaticDimension;
    }
}

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(isLocalBlog) {
        BlogLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([BlogLocationTableViewCell class])];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([BlogLocationTableViewCell class]) owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBlog: currLocationBlog];
        return cell;
    }
    else {
        BlogListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([BlogListTableViewCell class])];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([BlogListTableViewCell class]) owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBlog: [arrItems objectAtIndex: indexPath.row]];
        return cell;
    }
}

- (void) readMoreBlog:(Blog *)b
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"WebViewController"];
    nextView.title = b.title;
    nextView.url = b.link;
    b.isRead = YES;
    NSString *gen_key = [NSString stringWithFormat:@"%@-%d", [AppEngine sharedInstance].currentUser.user_id, b.blogId];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:gen_key];
    [AppEngine sharedInstance].currentUser.unread_blog_num--;
    [self updateParrentUI];
    [self.navigationController pushViewController: nextView animated: YES];
}

- (IBAction) actionJournal:(id)sender {
    if(isLocalBlog) {
        isLocalBlog = NO;
        [self updateUI];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WebViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"WebViewController"];
        nextView.title = @"journal.";
        nextView.url = kJournalURL;
        [self.navigationController pushViewController: nextView animated: YES];
    }
}

- (IBAction) actionCloseBlog:(id)sender {
    /////
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    if (isLocalBlog) {
        [nc postNotificationName:@"localizedBlogNotification" object:nil userInfo:@{@"isLocalBlog":@1}];
    } else {
        [nc postNotificationName:@"localizedBlogNotification" object:nil userInfo:@{@"isLocalBlog":@0}];
    }
    [self.menuContainerViewController setMenuState: MFSideMenuStateClosed];
}

@end
