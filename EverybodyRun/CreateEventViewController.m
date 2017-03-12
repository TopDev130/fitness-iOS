//
//  CreateEventViewController.m
//  EverybodyRun
//
//  Created by star on 2/1/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "CreateEventViewController.h"
#import "LocationViewController.h"
#import "EventListViewController.h"
#import "ERRangeSlider.h"
#import "HomeViewController.h"

@interface CreateEventViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIDocumentInteractionControllerDelegate>
{
    UIImagePickerController             *imagePicker;
    BOOL                                isContainImage;
    int                                 inputType;
    NSMutableArray                      *arrLocations;
    
    UITextField                         *tfDescription;
}

@property (nonatomic, weak) IBOutlet UILabel             *lbTitle;
@property (nonatomic, weak) IBOutlet UIButton            *btCreateEvent;

@property (nonatomic, weak) IBOutlet UIScrollView        *scMain;
@property (nonatomic, weak) IBOutlet UITextField         *tfEventName;
@property (nonatomic, weak) IBOutlet UILabel             *lbLocation;
@property (nonatomic, weak) IBOutlet UILabel             *lbDate;
@property (nonatomic, weak) IBOutlet UILabel             *lbTime;
@property (nonatomic, weak) IBOutlet UILabel             *lbType;
@property (nonatomic, weak) IBOutlet UIView              *viLevelSliderContainer;
@property (nonatomic, strong) ERRangeSlider              *sliderLevel;
@property (nonatomic, weak) IBOutlet UILabel             *lbDistance;
@property (nonatomic, weak) IBOutlet UISwitch            *swVisibility;
@property (nonatomic, weak) IBOutlet UILabel             *lbVisibilityPrivate;
@property (nonatomic, weak) IBOutlet UILabel             *lbVisibilityPublic;

@property (nonatomic, weak) IBOutlet UITextField         *tfOther;
@property (nonatomic, weak) IBOutlet UITextField         *tfWebsite;
@property (nonatomic, weak) IBOutlet UIButton            *btImage;
@property (nonatomic, weak) IBOutlet UIImageView         *ivPhoto;

@property (nonatomic, weak) IBOutlet UISwitch            *swAllowInvite;
@property (nonatomic, weak) IBOutlet UILabel             *lbAllowInviteNo;
@property (nonatomic, weak) IBOutlet UILabel             *lbAllowInviteYes;
@property (nonatomic, weak) IBOutlet UIView              *viInput;
@property (nonatomic, weak) IBOutlet UIDatePicker        *dpPicker;
@property (nonatomic, weak) IBOutlet UIPickerView        *pvInput;
@property (nonatomic, weak) IBOutlet UIBarItem           *biTitle;

@property (nonatomic, weak) IBOutlet UIView              *viOverlay;
@property (nonatomic, weak) IBOutlet UIView              *viLocationType;
@property (nonatomic, weak) IBOutlet UIButton            *btCurrentLocation;
@property (nonatomic, weak) IBOutlet UIButton            *btChooseLocation;

@end

@implementation CreateEventViewController
@synthesize lbTitle;
@synthesize btCreateEvent;

@synthesize scMain;
@synthesize tfEventName;
@synthesize lbLocation;
@synthesize lbDate;
@synthesize lbTime;
@synthesize lbType;
//@synthesize lbLevel;
@synthesize lbDistance;
@synthesize swVisibility;
@synthesize lbVisibilityPrivate;
@synthesize lbVisibilityPublic;
@synthesize tfOther;
@synthesize tfWebsite;
@synthesize btImage;
@synthesize ivPhoto;

@synthesize swAllowInvite;
@synthesize lbAllowInviteNo;
@synthesize lbAllowInviteYes;
@synthesize viInput;
@synthesize dpPicker;
@synthesize pvInput;
@synthesize biTitle;
@synthesize sliderLevel;
@synthesize viLevelSliderContainer;

@synthesize viOverlay;

@synthesize viLocationType;
@synthesize btCurrentLocation;
@synthesize btChooseLocation;
@synthesize currentEvent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isUpdate==YES) {
        [self updateEvent];
    }
}

- (void) initMember
{
    [super initMember];
    
    arrLocations = [[NSMutableArray alloc] init];
    
    if(self.isEditing || self.isView)
    {
        lbTitle.text = @"Edit Event";
        [btCreateEvent setTitle: @"Update" forState: UIControlStateNormal];
        
        [self editEvent: currentEvent];
    }
    else
    {
        currentEvent = [[Event alloc] init];
        currentEvent.type = -1;
        currentEvent.distance_unit = [AppEngine sharedInstance].distanceUnit;
        currentEvent.allow_invite_request = NO;
        currentEvent.snap_to_road = NO;
    }
    
    if(self.isView)
    {
        lbTitle.text = @"View Event";
        btCreateEvent.hidden = YES;
//        tfDistance.enabled = NO;
        tfEventName.enabled = NO;
        tfOther.enabled = NO;
        swAllowInvite.enabled = NO;
        btImage.enabled = NO;
    }
    
    btImage.layer.masksToBounds = YES;
    btImage.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    [self initSliderLevel];

    swAllowInvite.layer.borderWidth = 1;
    swAllowInvite.layer.borderColor = [UIColor lightGrayColor].CGColor;
    swAllowInvite.layer.cornerRadius = 16;

    swVisibility.layer.borderWidth = 1;
    swVisibility.layer.borderColor = [UIColor lightGrayColor].CGColor;
    swVisibility.layer.cornerRadius = 16;
    
    inputType = INPUT_EVENT_NAME;
    isContainImage = NO;
    btImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    btImage.layer.masksToBounds = YES;

    [biTitle setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17.0],
                                         NSForegroundColorAttributeName: [UIColor blackColor]
                                         } forState:UIControlStateNormal];
    
    [self.view addSubview: viOverlay];
    viOverlay.frame = CGRectMake(0, 63.0, self.view.bounds.size.width, self.view.bounds.size.height-63.0);
    viOverlay.hidden = YES;
    
    //Location Type.
    [self.view addSubview: viLocationType];
    viLocationType.frame = CGRectMake(0, 63.0, self.view.frame.size.width, viLocationType.frame.size.height);
    viLocationType.hidden = YES;
    
    btChooseLocation.layer.masksToBounds = YES;
    btChooseLocation.layer.cornerRadius = btChooseLocation.frame.size.width/2.0f;
    
    btCurrentLocation.layer.masksToBounds = YES;
    btCurrentLocation.layer.cornerRadius = btCurrentLocation.frame.size.width/2.0f;

    [self initInputUI];
    [self updateSwitchLabels];
}

- (void) updateSwitchLabels {
    if(swVisibility.on) {
        lbVisibilityPrivate.textColor = COLOR_MAIN_TEXT;
        lbVisibilityPublic.textColor = COLOR_GREEN_BTN;
    } else {
        lbVisibilityPrivate.textColor = COLOR_GREEN_BTN;
        lbVisibilityPublic.textColor = COLOR_MAIN_TEXT;
    }
    
    if(swAllowInvite.on) {
        lbAllowInviteNo.textColor = COLOR_MAIN_TEXT;
        lbAllowInviteYes.textColor = COLOR_GREEN_BTN;
    } else {
        lbAllowInviteNo.textColor = COLOR_GREEN_BTN;
        lbAllowInviteYes.textColor = COLOR_MAIN_TEXT;
    }
}

- (IBAction) actionChangedSwitch:(id)sender {
    [self updateSwitchLabels];
}

- (void) viewWillLayoutSubviews {
    sliderLevel.frame = CGRectMake(0, 8, viLevelSliderContainer.frame.size.width, viLevelSliderContainer.frame.size.height);
}

- (void) initInputUI
{
    [self.view addSubview: viInput];
    NSLog(@"Height=%f",viInput.frame.size.height);
    NSLog(@"width=%f",viInput.frame.size.width);
    viInput.frame = CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width, 260);
    viInput.hidden = YES;

//    viInput.frame = CGRectMake(0, self.view.bounds.size.height - viInput.frame.size.height, self.view.bounds.size.width, viInput.frame.size.height);
//    viInput.hidden = YES;
}

- (void) initSliderLevel
{
    sliderLevel = [[ERRangeSlider alloc] initWithFrame: CGRectMake(0, 0, viLevelSliderContainer.frame.size.width, viLevelSliderContainer.frame.size.height)];
    [viLevelSliderContainer addSubview: sliderLevel];
    if([AppEngine sharedInstance].distanceUnit == DISTANCE_MILE)
    {
        sliderLevel.minValue = 5;
        sliderLevel.maxValue = 19;
    }
    else
    {
        sliderLevel.minValue = 3;
        sliderLevel.maxValue = 12;
    }
    
    NSNumberFormatter *customFormatter = [[NSNumberFormatter alloc] init];
    [customFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    customFormatter.usesGroupingSeparator = YES;
    [customFormatter setMaximumFractionDigits:2];
    [customFormatter setMinimumFractionDigits:2];
    customFormatter.positiveSuffix = [NSString stringWithFormat: @"Min/%@", [ARRAY_DISTANCE_UNIT objectAtIndex: [AppEngine sharedInstance].distanceUnit]];
    sliderLevel.numberFormatterOverride = customFormatter;
    
    if(self.isEditing || self.isView)
    {
        sliderLevel.selectedMinimum = currentEvent.level_min;
        sliderLevel.selectedMaximum = currentEvent.level_max;
    }
    else
    {
        sliderLevel.selectedMinimum = sliderLevel.minValue;
        sliderLevel.selectedMinimum = sliderLevel.minValue;
    }

}

- (void) editEvent: (Event*) e
{
    tfEventName.text = e.name;
    lbDate.text = [e getExpireDate];
    lbTime.text = [e getExpireTime];
    lbLocation.text = e.address;
    lbType.text = [ARRAY_TYPE objectAtIndex: e.type];
    
    swVisibility.on = e.visibility;
    tfOther.text = e.note;
    
    if([e.main_image length] > 0)
    {
        [ivPhoto setImageWithURL: [AppEngine getImageURL: e.main_image]];
    }
    
    swAllowInvite.on = e.allow_invite_request;
    
    [self updateDistance];
    
    isContainImage = NO;
    [arrLocations addObjectsFromArray: e.map_points];
}

- (void) hideKeyboard
{
    [tfEventName resignFirstResponder];
    [tfOther resignFirstResponder];
}

- (IBAction)actionImage:(id)sender
{
    if(self.isView) return;
    [self hideKeyboard];
    
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

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isContainImage = YES;
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    ivPhoto.image = image;
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction) actionLocation:(id)sender
{
    if(self.isView) return;
    [self hideKeyboard];
    [self hideInputPicker];
    
    inputType = INPUT_LOCATION;
    if(arrLocations != nil && [arrLocations count] > 0)
    {
        [self gotoLocationView: LOCATION_CHOOSE];
    }
    else
    {
        [self showLocationDialog];
    }
}

- (IBAction) actionDate:(id)sender
{
    if(self.isView) return;
    [self hideKeyboard];
    inputType = INPUT_DATE;
    [self showInputPicker: YES];
}

- (IBAction) actionTime:(id)sender
{
    if(self.isView) return;
    [self hideKeyboard];
    inputType = INPUT_TIME;
    [self showInputPicker: YES];
}


- (IBAction) actionType:(id)sender
{
    if(self.isView) return;
    [self hideKeyboard];
    inputType = INPUT_TYPE;
    [self showInputPicker: YES];
}


- (IBAction) actionDistance:(id)sender
{
//    if(self.isView) return;
//    [self hideKeyboard];
//    inputType = INPUT_DISTANCE;
//    [self showDistanceDialog];
}

- (void) showInputPicker: (BOOL) animate
{
    if(inputType == INPUT_DATE)
    {
        dpPicker.hidden = NO;
        dpPicker.datePickerMode = UIDatePickerModeDate;
        pvInput.hidden = YES;
        biTitle.title = @"Date";
    }
    else if(inputType == INPUT_TIME)
    {
        dpPicker.hidden = NO;
        dpPicker.datePickerMode = UIDatePickerModeTime;
        pvInput.hidden = YES;
        biTitle.title = @"Time";
    }
    else if(inputType == INPUT_TYPE)
    {
        biTitle.title = @"Type";
        dpPicker.hidden = YES;
        pvInput.hidden = NO;
        [pvInput reloadAllComponents];
    }

    
    [pvInput selectRow: 0 inComponent: 0 animated: YES];
    viInput.hidden = NO;
    if(animate)
    {
        viInput.alpha = 0.0;
        [UIView animateWithDuration: 0.2f
                         animations:^{
                             
                             viInput.alpha = 1.0;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void) hideInputPicker
{
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         
                         viInput.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         
                         viInput.hidden = YES;
                     }];
}

- (void) fillOutInfo
{
    if(inputType == INPUT_DATE)
    {
        NSDate* date = dpPicker.date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: DATE_FORMATTER];
        NSString* selectedDate = [formatter stringFromDate: date];
        lbDate.text = selectedDate;
    }
    else if(inputType == INPUT_TIME)
    {
        NSDate* date = dpPicker.date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: TIME_FORMATTER];
        NSString* selectedTime = [formatter stringFromDate: date];
        lbTime.text = selectedTime;
    }
    else if(inputType == INPUT_TYPE)
    {
        int index = (int)[pvInput selectedRowInComponent: 0];
        lbType.text = [ARRAY_TYPE objectAtIndex: index];
        
        currentEvent.type = index;
    }
}

- (IBAction) actionDone:(id)sender
{
    [self fillOutInfo];
    [self hideInputPicker];
}

- (IBAction) actionNext:(id)sender
{
    [self fillOutInfo];
    
    if(inputType == INPUT_DATE)
    {
        inputType = INPUT_TIME;
        [self showInputPicker: NO];
    }
    else if(inputType == INPUT_TIME)
    {
        inputType = INPUT_TYPE;
        [self showInputPicker: NO];
    }
    else if(inputType == INPUT_TYPE)
    {
        [self hideInputPicker];
    }
}

#pragma mark - UITextField Delegate.

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == tfEventName) {
        inputType = INPUT_LOCATION;
        [self actionLocation: nil];
    } else if(textField == tfOther) {
        [tfWebsite becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == tfOther) {
        [scMain setContentOffset: CGPointMake(0, 200) animated: YES];
    } else if(textField == tfWebsite) {
        [scMain setContentOffset: CGPointMake(0, 240) animated: YES];
        [self checkWebSiteLink];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [scMain setContentOffset: CGPointZero animated: YES];
    [self checkWebSiteLink];
}

- (void) checkWebSiteLink {
    NSString* siteURL = [AppEngine getValidString: tfWebsite.text];
    if([siteURL hasPrefix: @"http://"] || [siteURL hasPrefix: @"https://"]) {
        tfWebsite.text = siteURL;
    } else
    {
        tfWebsite.text = [NSString stringWithFormat: @"http://%@", siteURL];
    }
}

#pragma mark - UIPickerDelegate.

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(inputType == INPUT_TYPE)
    {
        return [ARRAY_TYPE count];
    }
    else if(inputType == INPUT_LEVEL)
    {
        return [ARRAY_LEVEL count];
    }
    else
    {
        return [ARRAY_VISIBILITY count];
    }
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(inputType == INPUT_TYPE)
    {
        return [ARRAY_TYPE objectAtIndex: row];
    }
    else if(inputType == INPUT_LEVEL)
    {
        return [ARRAY_LEVEL objectAtIndex: row];
    }
    else
    {
        return [ARRAY_VISIBILITY objectAtIndex: row];
    }
}


#pragma mark - Location.

- (void) showLocationDialog
{
    viOverlay.hidden = NO;
    viLocationType.hidden = NO;
    viLocationType.alpha = 0.0;
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         
                         viLocationType.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void) hideLocationDialog
{
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         
                         viLocationType.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         viLocationType.hidden = YES;
                         viOverlay.hidden = YES;
                     }];
}

- (IBAction) actionCloseLocationType:(id)sender
{
    [self hideLocationDialog];
}

- (IBAction)actionCurrentLocation:(id)sender
{
    [self hideLocationDialog];
    [self gotoLocationView: LOCATION_CURRENT];
}

- (IBAction)actionChooseLocation:(id)sender
{
    [self hideLocationDialog];
    [self gotoLocationView: LOCATION_CHOOSE];
}

- (void) gotoLocationView: (int) type
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"LocationViewController"];
    nextView.locationType = type;
    nextView.arrRoute = [[NSMutableArray alloc] init];
    nextView.previousViewController = self;
    nextView.arrRoute = arrLocations;
    [self.navigationController pushViewController: nextView animated: YES];
}

- (void) updateLocation: (NSMutableArray*) arrRoute address: (NSString*) address snap_to_road: (BOOL) snap_to_road
{
    currentEvent.map_points = arrRoute;
    currentEvent.address = address;
    currentEvent.snap_to_road = snap_to_road;
    
    arrLocations = arrRoute;
    lbLocation.text = address;
    
    //Calculate distance.
    float distance = 0;
    float prevLat = 0;
    float prevLng = 0;
    float firstLat = 0;
    float firstLng = 0;
    
    int index = 0;
    for(NSString* strRecord in arrRoute)
    {
        NSArray* arrItem = [strRecord componentsSeparatedByString: @","];
        if(arrItem != nil && [arrItem count] > 1)
        {
            double lat = [[arrItem objectAtIndex: 0] doubleValue];
            double lng = [[arrItem objectAtIndex: 1] doubleValue];
            
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
        }
        
        index++;
    }
    

    CLLocation* loc1 = [[CLLocation alloc] initWithLatitude: prevLat longitude: prevLng];
    CLLocation* loc2 = [[CLLocation alloc] initWithLatitude: firstLat longitude: firstLng];
    
    CLLocationDistance meters = [loc1 distanceFromLocation: loc2];
    distance += meters;
    currentEvent.distance = distance;
    [self updateDistance];
}

- (void) updateDistance
{
    float distance = currentEvent.distance;
    if(currentEvent.distance_unit == DISTANCE_KILOMETER)
    {
        lbDistance.text = [NSString stringWithFormat: @"%0.2f KM", distance / 1000.0];
    }
    else
    {
        lbDistance.text = [NSString stringWithFormat: @"%0.2f Mi", distance / 1609.34];
    }
}

- (IBAction) actionSave:(id)sender
{
    [self hideKeyboard];
    
    currentEvent.name = tfEventName.text;
    
    NSString* strDate = lbDate.text;
    NSString* strTime = lbTime.text;
    
    currentEvent.note = [AppEngine getValidString: tfOther.text];
    currentEvent.allow_invite_request = swAllowInvite.on;
    currentEvent.visibility = swVisibility.on;    
    currentEvent.level_min = sliderLevel.selectedMinimum;
    currentEvent.level_max = sliderLevel.selectedMaximum;
    
    NSString* siteURL = [AppEngine getValidString: tfWebsite.text];
    if([siteURL hasPrefix: @"http://"] || [siteURL hasPrefix: @"https://"]) {
        currentEvent.website = siteURL;
    } else
    {
        currentEvent.website = [NSString stringWithFormat: @"http://%@", siteURL];
    }
    
    if([currentEvent.website isEqualToString: @"http://"] || [currentEvent.website isEqualToString: @"https://"]) {
        currentEvent.website = @"";
    }
    
    //Post User.
    currentEvent.post_user_id = [NSString stringWithFormat: @"%d", [[AppEngine sharedInstance].currentUser.user_id intValue]];
    currentEvent.post_user_email = [AppEngine sharedInstance].currentUser.email;
    currentEvent.post_user_first_name = [AppEngine sharedInstance].currentUser.first_name;
    currentEvent.post_user_last_name = [AppEngine sharedInstance].currentUser.last_name;
    currentEvent.post_user_avatar = [AppEngine sharedInstance].currentUser.profile_photo;
    
    if(currentEvent.map_points != nil && [currentEvent.map_points count] > 0)
    {
        NSString* firstPos = [currentEvent.map_points firstObject];
        NSArray* arrPos = [firstPos componentsSeparatedByString: @","];
        
        currentEvent.lat = [[arrPos firstObject] doubleValue];
        currentEvent.lng = [[arrPos lastObject] doubleValue];
    }
    
    if(currentEvent.name == nil || [currentEvent.name length] == 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EVENT_NAME] animated: YES completion: nil];
        return;
    }
    
    if(currentEvent.address == nil || [currentEvent.address length] == 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EVENT_ADDRESS] animated: YES completion: nil];
        return;
    }
    
    if(strDate == nil || [strDate length] == 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EVENT_DATE] animated: YES completion: nil];
        return;
    }
    
    if(strTime == nil || [strTime length] == 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EVENT_TIME] animated: YES completion: nil];
        return;
    }
    
    if(currentEvent.type == -1)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EVENT_TYPE] animated: YES completion: nil];
        return;
    }
    
//    if(currentEvent.level == -1)
//    {
//        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EVENT_LEVEL] animated: YES completion: nil];
//        return;
//    }

    if(currentEvent.distance_unit == -1)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EVENT_URL] animated: YES completion: nil];
        return;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: [NSString stringWithFormat: @"%@ %@", DATE_FORMATTER, TIME_FORMATTER]];
    NSDate* expireDate = [formatter dateFromString: [NSString stringWithFormat: @"%@ %@", strDate, strTime]];
    currentEvent.expire_date = [expireDate timeIntervalSince1970];
    
    if(!self.isEditing)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                 message: MSG_ASK_ADD_CALENDAR
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes"
                                                            style: UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [AppEngine addEventToCalendar: currentEvent];
                                                              [self saveEvent];
                                                          }];
        [alertController addAction: yesAction];
        
        UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No"
                                                           style: UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self saveEvent];
                                                             
                                                         }];
        [alertController addAction: noAction];
        [self presentViewController: alertController animated: YES completion: nil];
    }
    
    //Update Mode.
    else
    {
        [self saveEvent];
    }
}

- (void) saveEvent
{
    if(isContainImage)
    {
        UIImage* imgEvent = ivPhoto.image;
        
        [SVProgressHUD show];
        [[NetworkClient sharedClient] uploadEventImage: imgEvent
                                               success:^(NSDictionary *responseObject) {
                                                   
                                                   int success = [[responseObject valueForKey: @"success"] intValue];
                                                   if(success == 1)
                                                   {
                                                       NSString* imagePath = [responseObject valueForKey: @"data"][@"uploadfile"];
                                                       currentEvent.main_image = imagePath;
                                                       if(self.isEditing)
                                                       {
                                                           [self updateEvent];
                                                       }
                                                       else
                                                       {
                                                           [self createEvent: NO];
                                                       }
                                                       
                                                   }
                                                   else
                                                   {
                                                       [SVProgressHUD dismiss];
                                                       NSString* message = [responseObject valueForKey: @"message"];
                                                       [self presentViewController: [AppEngine showAlertWithText: message] animated: YES completion: nil];
                                                   }
                                                   
                                               } failure:^(NSError *error) {
                                                   
                                                   [SVProgressHUD dismiss];
                                                   [self presentViewController: [AppEngine showErrorWithText: MSG_CANT_UPLOAD_IMAGE] animated: YES completion: nil];
                                               }];
    }
    else
    {
        if(self.isEditing)
        {
            [self updateEvent];
        }
        else
        {
            [self createEvent: YES];
        }
        
    }
}

- (void) createEvent: (BOOL) showIndicator
{
    if(showIndicator)
    {
        [SVProgressHUD show];
    }
    
    [[NetworkClient sharedClient] createEvent: currentEvent.name
                                      address: currentEvent.address
                                          lat: currentEvent.lat
                                          lng: currentEvent.lng
                                   map_points: currentEvent.map_points
                                  expire_date: currentEvent.expire_date
                                         type: currentEvent.type
                                    level_min: currentEvent.level_min
                                    level_max: currentEvent.level_max
                                     distance: currentEvent.distance
                                distance_unit: currentEvent.distance_unit
                                   visibility: currentEvent.visibility
                                         note: currentEvent.note website: currentEvent.website
                                 snap_to_road: currentEvent.snap_to_road
                         allow_invite_request: currentEvent.allow_invite_request
                                   main_image: currentEvent.main_image
                                 post_user_id: [AppEngine sharedInstance].currentUser.user_id
                                      success:^(NSDictionary *responseObject) {
                                          [SVProgressHUD dismiss];
                                          NSLog(@"response = %@", responseObject);
                                          int success = [[responseObject valueForKey: @"success"] intValue];
                                          if(success == 1)
                                          {
                                              NSDictionary* dicEvent = [responseObject valueForKey: @"data"][@"event"];
                                              Event* e = [[Event alloc] initWithDictionary: dicEvent];
                                              [[CoreHelper sharedInstance] addEvent: e];
                                              
                                              //Add Post User Infomation.
                                              currentEvent = e;
                                              currentEvent.post_user_avatar = [AppEngine sharedInstance].currentUser.profile_photo;
                                              currentEvent.post_user_email = [AppEngine sharedInstance].currentUser.email;
                                              currentEvent.post_user_first_name = [AppEngine sharedInstance].currentUser.first_name;
                                              currentEvent.post_user_last_name = [AppEngine sharedInstance].currentUser.last_name;
                                              [(EventListViewController*)self.parentView addNewMyEvent: currentEvent];
                                              
                                              UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                                                       message: MSG_ASK_SHARE
                                                                                                                preferredStyle: UIAlertControllerStyleAlert];
                                              UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes"
                                                                                                  style: UIAlertActionStyleDefault
                                                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                                                    
                                                                                                    [self shareEvent: currentEvent completedHander:^{
                                                                                                        
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^ {
                                                                                                            [self checkInitialImage];
                                                                                                        });
                                                                                                    }];
                                                                                                }];
                                              [alertController addAction: yesAction];
                                              UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No"
                                                                                                 style: UIAlertActionStyleDefault
                                                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                                                   dispatch_async(dispatch_get_main_queue(), ^ {
                                                                                                        [self checkInitialImage];
                                                                                                    });
                                                                                               }];
                                              [alertController addAction: noAction];
                                              [self presentViewController: alertController animated: YES completion: nil];
                                          }
                                          else
                                          {
                                              NSString* mesage = [responseObject valueForKey: @"message"];
                                              [self presentViewController: [AppEngine showErrorWithText: mesage] animated: YES completion: nil];
                                              return;
                                          }
                                          
                                      } failure:^(NSError *error) {
                                         
                                          NSLog(@"error = %@", error);
                                          [SVProgressHUD dismiss];
                                          [self presentViewController: [AppEngine showErrorWithText: MSG_CANT_CREATE_EVENT] animated: YES completion: nil];
                                          
                                      }];
}

- (void) checkInitialImage
{
    UIImage* imgEvent = btImage.imageView.image;
    
    //Sharing Instagram.
    if(imgEvent)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil
                                                                       message: MSG_SUCCESS_EVENT_CREATE
                                                                preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self postInstagrame: imgEvent completedHander:^{
                [self actionBack: nil];
            }];
            
        }];
        
        [alert addAction: yesAction];
        UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No"
                                                           style: UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self actionBack: nil];
                                                         }];
        [alert addAction: noAction];
        [self presentViewController: alert animated: YES completion: nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil
                                                                       message: MSG_SUCCESS_EVENT_CREATE_NO_IMAGE
                                                                preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self actionBack: nil];
            
        }];
        
        [alert addAction: okAction];
        [self presentViewController: alert animated: YES completion: nil];
    }

}

#pragma mark - Update Event.

- (IBAction) actionBack:(id)sender
{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) updateEvent
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil
                                                                             message: @"Reason you are updating?"
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Description";
        tfDescription = textField;
    }];
    
    UIAlertAction* removeAction = [UIAlertAction actionWithTitle: @"Update"
                                                           style: UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             NSString* reason = tfDescription.text;
                                                             if(reason == nil || [reason length] == 0)
                                                             {
                                                                 [self presentViewController: [AppEngine showAlertWithText: MSG_ASK_REASON_FOR_REMOVE]
                                                                                    animated: YES
                                                                                  completion: nil];
                                                             }
                                                             else
                                                             {
                                                                 [SVProgressHUD show];
                                                                 [[NetworkClient sharedClient] updateEvent: currentEvent
                                                                                                   user_id: [AppEngine sharedInstance].currentUser.user_id                                                                  
                                                                                                    reason: reason
                                                                                                   success:^(NSDictionary *responseObject) {
                                                                                                       [SVProgressHUD dismiss];
                                                                                                       NSLog(@"update event response = %@", responseObject);
                                                                                                       [self finishedUpdateEvent];
                                                                                                       
                                                                                                   } failure:^(NSError *error) {
                                                                                                       
                                                                                                       [SVProgressHUD dismiss];
                                                                                                       NSLog(@"update error = %@", error);
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

- (void) finishedUpdateEvent
{
    if(![currentEvent isExpire: [NSDate date]]) {
        currentEvent.is_asked_expire = NO;
        [[NetworkClient sharedClient] updatedAskedExpire: currentEvent success:^(NSDictionary *responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }

    if([self.parentView isKindOfClass: [EventListViewController class]]) {
        [(EventListViewController*)self.parentView updateEvent: currentEvent];
    }
    else {
        [(HomeViewController*)self.parentView updateEvent: currentEvent];
    }

    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil message: MSG_RESHARE_EVENT preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self shareEvent: currentEvent completedHander:^{
            
            [self actionBack: nil];
            
        }];
        
    }];
    [alert addAction: yesAction];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self actionBack: nil];
        
    }];
    
    [alert addAction: noAction];
    [self presentViewController: alert animated: YES completion: nil];
}

@end
