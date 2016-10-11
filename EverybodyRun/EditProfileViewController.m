//
//  EditProfileViewController.m
//  EverybodyRun
//
//  Created by Marcin Robak on 5/20/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource>
{
    UIImagePickerController     *imagePicker;
    BOOL                        isChangedAvatar;
    int                         currentInputMode;
    
    NSDate                      *selectedBirthday;
    int                         selectedGender;
    int                         currentInputType;
    
}

@property (nonatomic, weak) IBOutlet UIScrollView       *scContainer;
@property (nonatomic, weak) IBOutlet UIImageView        *ivAvatar;
@property (nonatomic, weak) IBOutlet UIButton           *btSave;
@property(nonatomic, weak) IBOutlet UIView              *viFirstName;
@property(nonatomic, weak) IBOutlet UITextField         *tfFirstName;
@property(nonatomic, weak) IBOutlet UIView              *viLastName;
@property(nonatomic, weak) IBOutlet UITextField         *tfLastName;
@property(nonatomic, weak) IBOutlet UIView              *viEmail;
@property(nonatomic, weak) IBOutlet UITextField         *tfEmail;
@property(nonatomic, weak) IBOutlet UIView              *viBirthday;
@property(nonatomic, weak) IBOutlet UITextField         *tfBirthday;
@property(nonatomic, weak) IBOutlet UIView              *viGender;
@property(nonatomic, weak) IBOutlet UITextField         *tfGender;
@property(nonatomic, weak) IBOutlet UIPickerView        *pickerView;
@property(nonatomic, weak) IBOutlet UIDatePicker        *datePicker;
@property(nonatomic, weak) IBOutlet UIToolbar           *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem     *titleLabel;

@end

@implementation EditProfileViewController
@synthesize scContainer;
@synthesize ivAvatar;
@synthesize btSave;
@synthesize viFirstName;
@synthesize tfFirstName;
@synthesize viLastName;
@synthesize tfLastName;
@synthesize viEmail;
@synthesize tfEmail;
@synthesize viGender;
@synthesize tfGender;
@synthesize viBirthday;
@synthesize tfBirthday;
@synthesize pickerView;
@synthesize datePicker;
@synthesize toolbar;
@synthesize titleLabel;

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
    
    isChangedAvatar = NO;
    
    ivAvatar.layer.masksToBounds = YES;
    ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width / 2.0;
    
    btSave.layer.masksToBounds = YES;
    btSave.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    viFirstName.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viLastName.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viEmail.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viBirthday.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viGender.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    tfBirthday.inputAccessoryView = toolbar;
    tfBirthday.inputView = datePicker;
    tfGender.inputAccessoryView = toolbar;
    tfGender.inputView = pickerView;
    
    [self fillInfo];
}

- (void) fillInfo {
    [ivAvatar setImageWithURL: [AppEngine getImageURL: [AppEngine sharedInstance].currentUser.profile_photo] placeholderImage: [UIImage imageNamed: @"default_user.png"]];
    tfFirstName.text = [AppEngine sharedInstance].currentUser.first_name;
    tfLastName.text = [AppEngine sharedInstance].currentUser.last_name;
    tfEmail.text = [AppEngine sharedInstance].currentUser.email;
    
    selectedGender = [[AppEngine sharedInstance].currentUser.gender intValue];
    tfGender.text = [ARRAY_GENDER objectAtIndex: selectedGender];
    
    selectedBirthday = [NSDate dateWithTimeIntervalSince1970: [[AppEngine sharedInstance].currentUser.birthday intValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: BIRTHDAY_FORMAT];
    tfBirthday.text = [formatter stringFromDate: selectedBirthday];
}

- (void) hideKeyboard
{
    [tfFirstName resignFirstResponder];
    [tfLastName resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfGender resignFirstResponder];
    [tfBirthday resignFirstResponder];
}

#pragma mark - Avatar.

- (IBAction)actionAvatar:(id)sender
{
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
    isChangedAvatar = YES;
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    ivAvatar.image = image;
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Save.
- (IBAction) actionSave:(id)sender
{
    [self hideKeyboard];
    
    NSString* firstName = tfFirstName.text;
    NSString* lastName = tfLastName.text;
    NSString* email = tfEmail.text;
    
    if(firstName == nil || [firstName length] == 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_FIRSTNAME] animated: YES completion: nil];
        return;
    }
    
    if(lastName == nil || [lastName length] == 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_LASTNAME] animated: YES completion: nil];
        return;
    }
    
    if(email == nil || ![AppEngine emailValidate: email])
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EMAIL] animated: YES completion: nil];
        return;
    }
    
    if (selectedBirthday == nil) {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_BIRTHDAY] animated: YES completion: nil];
        return;
    }
    
    if (selectedGender < 0) {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_GENDER] animated: YES completion: nil];
        return;
    }

    if(isChangedAvatar) {
        UIImage* imgAvatar = [AppEngine imageWithImage: ivAvatar.image scaledToWidth: USER_AVATAR_MAX_SIZE];
        [SVProgressHUD showWithStatus: @"Saving"];
        [[NetworkClient sharedClient] uploadAvatar: imgAvatar
                                           success:^(NSDictionary *responseObject) {
                                               
                                               int success = [[responseObject valueForKey: @"success"] intValue];
                                               if(success == 1)
                                               {
                                                   NSString* avatar = [[responseObject valueForKey: @"data"] valueForKey: @"uploadfile"];
                                                   [self updateProfile: firstName lastName: lastName email: email avatar: avatar showLoadingBar: NO];
                                               }
                                               else
                                               {
                                                   [SVProgressHUD dismiss];
                                                   [self presentViewController: [AppEngine showErrorWithText: MSG_CANT_UPLOAD_AVTAR] animated: YES completion: nil];
                                               }
                                               
                                           } failure:^(NSError *error) {
                                               
                                               [SVProgressHUD dismiss];
                                               [self presentViewController: [AppEngine showErrorWithText: MSG_CANT_UPLOAD_AVTAR] animated: YES completion: nil];
                                           }];
    }
    else {
        [self updateProfile: firstName lastName: lastName email: email avatar: nil showLoadingBar: YES];
    }
}

- (void) updateProfile: (NSString*) firstName lastName: (NSString*) lastName email: (NSString*) email avatar: (NSString*) avatar showLoadingBar: (BOOL) showLoadingBar {
    
    if(showLoadingBar) {
        [SVProgressHUD showWithStatus: @"Saving"];
    }
    
    [[NetworkClient sharedClient] updateUser: [AppEngine sharedInstance].currentUser.user_id
                                   firstName: firstName
                                    lastName: lastName
                                       email: email
                                    birthday: selectedBirthday
                                      gender: selectedGender
                                      avatar: avatar
                                     success:^(User *u) {
                                         
                                         [SVProgressHUD dismiss];
                                         [AppEngine sharedInstance].currentUser = u;
                                         [[CoreHelper sharedInstance] addUser: [AppEngine sharedInstance].currentUser];
                                         [self actionBack: nil];
                                         
                                     } failure:^(NSError *error) {
                                         [SVProgressHUD dismiss];
                                         [self presentViewController: [AppEngine showErrorWithText: MSG_INTERNET_ERROR] animated: YES completion: nil];
                                     }];
}

#pragma mark - UITextField Delegate.

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    float fy = 0;
    if(IS_IPHONE_5){
        fy += 20.0;
    } else if(IS_IPHONE_4_OR_LESS) {
        fy += 60.0;
    }
    
    [scContainer setContentOffset: CGPointMake(0, fy + textField.tag * 50.0f) animated: YES];
    
    if(textField == tfFirstName) {
        currentInputType = INPUT_FIRSTNAME;
    }
    else if(textField == tfLastName) {
        currentInputType = INPUT_LASTNAME;
    }
    else if(textField == tfEmail) {
        currentInputType = INPUT_EMAIL;
    }
    else if(textField == tfBirthday) {
        currentInputType = INPUT_BIRTHDAY;
        titleLabel.title = @"Birthday";
    }
    else if(textField == tfGender) {
        currentInputType = INPUT_GENDER;
        titleLabel.title = @"Gender";
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [scContainer setContentOffset: CGPointZero animated: YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == tfFirstName)
    {
        [tfLastName becomeFirstResponder];
    }
    else if(textField == tfLastName)
    {
        [tfEmail becomeFirstResponder];
    }
    else if(textField == tfEmail)
    {
        [tfBirthday becomeFirstResponder];
    }
    else if(textField == tfBirthday) {
        [tfGender becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction) actionInputDone:(id)sender {
    [self checkInputDone];
    [self hideKeyboard];
}

- (IBAction) actionInputNext:(id)sender {
    [self checkInputDone];
    
    if (currentInputType == INPUT_BIRTHDAY) {
        [tfGender becomeFirstResponder];
    }
    else if(currentInputType == INPUT_GENDER) {
        [self hideKeyboard];
    }
}

- (void) checkInputDone {
    if(currentInputType == INPUT_BIRTHDAY) {
        selectedBirthday = datePicker.date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: BIRTHDAY_FORMAT];
        tfBirthday.text = [formatter stringFromDate: selectedBirthday];
    } else {
        selectedGender = (int)[pickerView selectedRowInComponent: 0];
        tfGender.text = [ARRAY_GENDER objectAtIndex: selectedGender];
    }
}

#pragma mark - UIPickerDelegate, DataSource.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return ARRAY_GENDER.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [ARRAY_GENDER objectAtIndex: row];
}
@end
