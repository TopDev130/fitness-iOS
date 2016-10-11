//
//  StartViewController.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/19/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"

@interface StartViewController () <UIScrollViewDelegate>
{
    
}

@property (nonatomic, weak) IBOutlet UIButton       *btJoin;
@property (nonatomic, weak) IBOutlet UIButton       *btLogin;
@property (nonatomic, weak) IBOutlet UIView         *viOnboard;
@property (nonatomic, weak) IBOutlet UIScrollView   *scBoard;
@property (nonatomic, weak) IBOutlet UIView         *viBoard1;
@property (nonatomic, weak) IBOutlet UIView         *viBoard2;
@property (nonatomic, weak) IBOutlet UIView         *viBoard3;
@property (nonatomic, weak) IBOutlet UIView         *viBoard4;
@property (nonatomic, weak) IBOutlet UIView         *viBoard5;
@property (nonatomic, weak) IBOutlet UIPageControl  *pgControl;
@property (nonatomic, weak) IBOutlet UIButton       *btTutorial;
@property (nonatomic, weak) IBOutlet UIButton       *btGo;

@end

@implementation StartViewController
@synthesize btJoin;
@synthesize btLogin;
@synthesize viOnboard;
@synthesize scBoard;
@synthesize viBoard1;
@synthesize viBoard2;
@synthesize viBoard3;
@synthesize viBoard4;
@synthesize viBoard5;
@synthesize pgControl;
@synthesize btTutorial;
@synthesize btGo;

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
    
    btJoin.layer.masksToBounds = YES;
    btJoin.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    btLogin.layer.masksToBounds = YES;
    btLogin.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    [AppDelegate getDelegate].rootNavBar = self.navigationController;
    [AppDelegate getDelegate].startView = self;
    
    [self initOnBoard];
    viOnboard.hidden = YES;
    
    NSManagedObject* global = [[CoreHelper sharedInstance] getGlobalInfo];
    if(global != nil)
    {
        NSNumber* current_user_id = [global valueForKey: @"current_user_id"];
        [AppEngine sharedInstance].mapType = [[global valueForKey: @"map_type"] intValue];
        [AppEngine sharedInstance].distanceUnit = [[global valueForKey: @"distance_unit"] intValue];
        [AppEngine sharedInstance].watermarkEnabled = [[global valueForKey: @"watermark_enabled"] boolValue];
        [AppEngine sharedInstance].last_update = [global valueForKey: @"last_update"];
        
        if(current_user_id != nil)
        {
            NSManagedObject* objUser = [[CoreHelper sharedInstance] getUser: current_user_id];
            if(objUser)
            {
                [AppEngine sharedInstance].currentUser = [[User alloc] initWithManageObject: objUser];
                [self gotoMainView: NO];
            }
        }
        
        BOOL onBoard = [[global valueForKey: @"is_show_onboard"] boolValue];
        if(!onBoard) {
            viOnboard.hidden = NO;
        }
    }
    else {
        [[CoreHelper sharedInstance] saveSettingsInfo: 0 distanceUnit: 1 watermarkEnabled: YES];
        
        [AppEngine sharedInstance].mapType = 0;
        [AppEngine sharedInstance].distanceUnit = 1;
        [AppEngine sharedInstance].watermarkEnabled = YES;

        viOnboard.hidden = NO;
    }
}

- (void) initOnBoard {
    
    btTutorial.layer.cornerRadius = YES;
    btTutorial.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    btGo.layer.cornerRadius = YES;
    btGo.layer.cornerRadius = BUTTON_CORNER_RADIUS;

    float fx = 0;
    float fy = 1;
    float fw = self.view.frame.size.width;
    float fh = self.view.frame.size.height;
    
    viBoard1.frame = CGRectMake(fx, fy, fw, fh);
    [scBoard addSubview: viBoard1];

    fx += fw;
    viBoard2.frame = CGRectMake(fx, fy, fw, fh);
    [scBoard addSubview: viBoard2];

    fx += fw;
    viBoard3.frame = CGRectMake(fx, fy, fw, fh);
    [scBoard addSubview: viBoard3];

    fx += fw;
    viBoard4.frame = CGRectMake(fx, fy, fw, fh);
    [scBoard addSubview: viBoard4];

    fx += fw;
    viBoard5.frame = CGRectMake(fx, fy, fw, fh);
    [scBoard addSubview: viBoard5];

    fx += fw;
    [scBoard setContentSize: CGSizeMake(fx, fh)];
    
    viOnboard.frame = self.view.bounds;
    [self.view addSubview: viOnboard];
}

- (void) viewWillLayoutSubviews {
    viOnboard.frame = self.view.bounds;
//    viBoard1.frame = CGRectMake(0, 0, viOnboard.frame.size.width, viOnboard.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging || scrollView.isDecelerating){
        int page = (int)(lround(scrollView.contentOffset.x / (scrollView.contentSize.width / pgControl.numberOfPages)));
        pgControl.currentPage = page;
    }
}


- (IBAction) actionExplore:(id)sender {
    [self gotoMainView: YES];
}

- (IBAction) actionTutorial: (id)sender {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kTutorial]];
}

- (IBAction) actionGo:(id)sender {
    viOnboard.alpha = 1.0;
    [UIView animateWithDuration: 0.4f animations:^{
        viOnboard.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[CoreHelper sharedInstance] setOnBoard: YES];
    }];
}

@end
