//
//  SettingsViewController.m
//  EverybodyRun
//
//  Created by star on 3/10/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    
}

@property (nonatomic, weak) IBOutlet UILabel            *lbMapNormal;
@property (nonatomic, weak) IBOutlet UILabel            *lbMapSat;
@property (nonatomic, weak) IBOutlet UISwitch           *swMap;

@property (nonatomic, weak) IBOutlet UILabel            *lbDistanceMile;
@property (nonatomic, weak) IBOutlet UILabel            *lbDistanceKM;
@property (nonatomic, weak) IBOutlet UISwitch           *swDistance;

@property (nonatomic, weak) IBOutlet UILabel            *lbWatermarkOn;
@property (nonatomic, weak) IBOutlet UILabel            *lbWatermarkOff;
@property (nonatomic, weak) IBOutlet UISwitch           *swWatermark;

@end

@implementation SettingsViewController
@synthesize lbMapNormal;
@synthesize lbMapSat;
@synthesize swDistance;

@synthesize lbDistanceMile;
@synthesize lbDistanceKM;
@synthesize swMap;

@synthesize lbWatermarkOn;
@synthesize lbWatermarkOff;
@synthesize swWatermark;

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
    
    swMap.layer.borderWidth = 1;
    swMap.layer.borderColor = [UIColor lightGrayColor].CGColor;
    swMap.layer.cornerRadius = 16;

    swDistance.layer.borderWidth = 1;
    swDistance.layer.borderColor = [UIColor lightGrayColor].CGColor;
    swDistance.layer.cornerRadius = 16;

    swWatermark.layer.borderWidth = 1;
    swWatermark.layer.borderColor = [UIColor lightGrayColor].CGColor;
    swWatermark.layer.cornerRadius = 16;
    
    swMap.on = [AppEngine sharedInstance].mapType;
    swDistance.on = ![AppEngine sharedInstance].distanceUnit;
    swWatermark.on = ![AppEngine sharedInstance].watermarkEnabled;
    
    [self updateSwitchLabels];
}

- (void) updateSwitchLabels {
    if(swMap.on) {
        lbMapNormal.textColor = COLOR_MAIN_TEXT;
        lbMapSat.textColor = COLOR_GREEN_BTN;
    } else {
        lbMapNormal.textColor = COLOR_GREEN_BTN;
        lbMapSat.textColor = COLOR_MAIN_TEXT;
    }
    
    if(swDistance.on) {
        lbDistanceMile.textColor = COLOR_MAIN_TEXT;
        lbDistanceKM.textColor = COLOR_GREEN_BTN;
    } else {
        lbDistanceMile.textColor = COLOR_GREEN_BTN;
        lbDistanceKM.textColor = COLOR_MAIN_TEXT;
    }
    
    if(swWatermark.on) {
        lbWatermarkOn.textColor = COLOR_MAIN_TEXT;
        lbWatermarkOff.textColor = COLOR_GREEN_BTN;
    } else {
        lbWatermarkOn.textColor = COLOR_GREEN_BTN;
        lbWatermarkOff.textColor = COLOR_MAIN_TEXT;
    }
}

- (IBAction) actionBack:(id)sender
{
    [AppEngine sharedInstance].mapType = swMap.on;
    [AppEngine sharedInstance].distanceUnit = !swDistance.on;
    [AppEngine sharedInstance].watermarkEnabled = !swWatermark.on;
    
    [[CoreHelper sharedInstance] saveSettingsInfo: [AppEngine sharedInstance].mapType
                                     distanceUnit: [AppEngine sharedInstance].distanceUnit
                                 watermarkEnabled: [AppEngine sharedInstance].watermarkEnabled];
    [[NSNotificationCenter defaultCenter] postNotificationName: DISTANCE_UNIT_CHANGED object:nil];
    [super actionBack: sender];
}

- (IBAction) actionChangedSwictch:(id)sender {
    [self updateSwitchLabels];
}

@end
