//
//  SignupViewController.m
//  EverybodyRun
//
//  Created by star on 1/30/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIImagePickerController             *imagePicker;
    BOOL                                isContainAvatar;
    BOOL                                isShowPassword;
    int                                 currentInputType;
    
    NSDate                              *selectedBirthday;
    int                                 selectedGender;
}

@property(nonatomic, weak) IBOutlet UIScrollView        *scContainer;
@property(nonatomic, weak) IBOutlet UIButton            *btAvatar;
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
@property(nonatomic, weak) IBOutlet UIView              *viPassword;
@property(nonatomic, weak) IBOutlet UITextField         *tfPassword;
@property(nonatomic, weak) IBOutlet UIView              *viConfirmPassword;
@property(nonatomic, weak) IBOutlet UITextField         *tfConfirmPassword;
@property(nonatomic, weak) IBOutlet UIButton            *btSignUp;
@property(nonatomic, weak) IBOutlet UIPickerView        *pickerView;
@property(nonatomic, weak) IBOutlet UIDatePicker        *datePicker;
@property(nonatomic, weak) IBOutlet UIToolbar           *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem     *titleLabel;
@end

@implementation SignupViewController
@synthesize scContainer;
@synthesize btAvatar;
@synthesize viFirstName;
@synthesize tfFirstName;
@synthesize viLastName;
@synthesize tfLastName;
@synthesize tfEmail;
@synthesize viEmail;
@synthesize viBirthday;
@synthesize tfBirthday;
@synthesize viGender;
@synthesize tfGender;
@synthesize tfPassword;
@synthesize viPassword;
@synthesize tfConfirmPassword;
@synthesize viConfirmPassword;
@synthesize btSignUp;
@synthesize pickerView;
@synthesize datePicker;
@synthesize titleLabel;
@synthesize toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) initMember
{
    [super initMember];
    
    selectedGender = -1;
    
    isShowPassword = NO;
    isContainAvatar = NO;
    btAvatar.layer.masksToBounds = YES;
    btAvatar.layer.cornerRadius = btAvatar.frame.size.width / 2.0f;
    btAvatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    btSignUp.layer.masksToBounds = YES;
    btSignUp.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    viFirstName.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viLastName.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viEmail.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viBirthday.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viGender.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viPassword.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    viConfirmPassword.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    tfBirthday.inputAccessoryView = toolbar;
    tfBirthday.inputView = datePicker;
    tfGender.inputAccessoryView = toolbar;
    tfGender.inputView = pickerView;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(hideKeyboard)];
    gesture.cancelsTouchesInView = self;
    [scContainer addGestureRecognizer: gesture];
}

- (void) hideKeyboard
{
    [tfFirstName resignFirstResponder];
    [tfLastName resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfBirthday resignFirstResponder];
    [tfGender resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfConfirmPassword resignFirstResponder];
}

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
    isContainAvatar = YES;
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [btAvatar setImage: image forState: UIControlStateNormal];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction) actionShowPassword:(id)sender
{
    isShowPassword = !isShowPassword;
    tfPassword.secureTextEntry = isShowPassword;
    tfConfirmPassword.secureTextEntry = isShowPassword;
}

- (IBAction)actionSignIn:(id)sender
{
    [self hideKeyboard];
    
    NSString* firstName = tfFirstName.text;
    NSString* lastName = tfLastName.text;
    NSString* email = tfEmail.text;
    NSString* password = tfPassword.text;
    NSString* confirmPassword = tfConfirmPassword.text;
    
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
    
    if(password == nil || [password length] == 0 || ![password isEqual: confirmPassword])
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_PASSWORD] animated: YES completion: nil];
        return;
    }
    
    UIImage* imgAvatar = nil;
    if(isContainAvatar)
    {
        imgAvatar = [AppEngine imageWithImage: btAvatar.imageView.image scaledToWidth: USER_AVATAR_MAX_SIZE];
        [SVProgressHUD show];
        [[NetworkClient sharedClient] uploadAvatar: imgAvatar
                                           success:^(NSDictionary *responseObject) {
                                               
                                               int success = [[responseObject valueForKey: @"success"] intValue];
                                               if(success == 1)
                                               {
                                                   NSString* avatar = [[responseObject valueForKey: @"data"] valueForKey: @"uploadfile"];
                                                   [self registerAccount: email
                                                               firstName: firstName
                                                                lastName: lastName
                                                                birthday: selectedBirthday
                                                                  gender:selectedGender
                                                                password: password
                                                                  avatar: avatar
                                                          showLoadingBar: NO];
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
    else
    {
        [self registerAccount: email
                    firstName: firstName
                     lastName: lastName
                     birthday: selectedBirthday
                       gender:selectedGender
                     password: password
                       avatar: @""
               showLoadingBar: YES];
    }
}

- (void) registerAccount: (NSString*) email
               firstName: (NSString*) firstName
                lastName: (NSString*) lastName
                birthday: (NSDate*) birthday
                  gender: (int) gender
                password: (NSString*) password
                  avatar: (NSString*) avatar
          showLoadingBar: (BOOL) show
{
    if(show)
    {
        [SVProgressHUD show];
    }

    [[NetworkClient sharedClient] signWithEmail: email
                                      firstName: firstName
                                       lastName: lastName
                                       birthday: birthday
                                         gender: gender
                                       password: password
                                         avatar: avatar
                                        success:^(id responseObject) {
                                            
                                            NSLog(@"register result = %@", responseObject);
                                            [SVProgressHUD dismiss];
                                            int success = [[responseObject valueForKey: @"success"] intValue];
                                            if(success == 1)
                                            {
                                                NSDictionary* dicUser = [[responseObject valueForKey: @"data"] valueForKey: @"user"];
                                                User* currentUser = [[User alloc] initWithDictionary: dicUser];
                                                [AppEngine sharedInstance].currentUser = currentUser;
                                                
                                                [[CoreHelper sharedInstance] addUser: [AppEngine sharedInstance].currentUser];
                                                [[CoreHelper sharedInstance] setCurrentUserId: [AppEngine sharedInstance].currentUser.user_id];

                                                [self gotoMainView: YES];
                                            }
                                            else
                                            {
                                                NSString* message = [responseObject valueForKey: @"message"];
                                                [self presentViewController: [AppEngine showErrorWithText: message] animated: YES completion: nil];
                                            }
                                            
                                        } failure:^(NSError *error) {
                                            
                                            NSLog(@"register error = %@", error);
                                            [SVProgressHUD dismiss];
                                            [self presentViewController: [AppEngine showErrorWithText: MSG_CANT_CREATE_ACCOUNT] animated: YES completion: nil];
                                        }];
}

#pragma mark - UITextField Delegate.

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    float fy = 0;
    if(IS_IPHONE_5){
        fy += 40.0;
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
    else if(textField == tfPassword) {
        currentInputType = INPUT_PASSWORD;
    }
    else if(textField == tfConfirmPassword) {
        currentInputType = INPUT_CONFIRM_PASSWORD;
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
    else if(textField == tfGender) {
        [tfPassword becomeFirstResponder];
    }
    else if(textField == tfPassword)
    {
        [tfConfirmPassword becomeFirstResponder];
    }
    else
    {
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
        [tfPassword becomeFirstResponder];
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
