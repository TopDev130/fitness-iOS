//
//  LoginViewController.m
//  EverybodyRun
//
//  Created by star on 2/28/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController () <UITextFieldDelegate>
{
}

@property(nonatomic, weak) IBOutlet UIScrollView    *scMain;
@property(nonatomic, weak) IBOutlet UITextField     *tfEmail;
@property(nonatomic, weak) IBOutlet UITextField     *tfPassword;
//@property(nonatomic, weak) IBOutlet UILabel         *lbVersion;
@property (nonatomic, weak) IBOutlet UIButton       *btLogIn;
@property (nonatomic, weak) IBOutlet UIView         *viEmail;
@property (nonatomic, weak) IBOutlet UIView         *viPassword;

@end

@implementation LoginViewController
@synthesize tfEmail;
@synthesize tfPassword;
@synthesize scMain;
//@synthesize lbVersion;
@synthesize btLogIn;
@synthesize viEmail;
@synthesize viPassword;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMember
{
    [super initMember];
    
//    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
//    lbVersion.text = [NSString stringWithFormat: @"%@(%@)", appVersionString, appBuildString];

    btLogIn.layer.masksToBounds = YES;
    btLogIn.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    
    viEmail.layer.cornerRadius = YES;
    viEmail.layer.cornerRadius = BUTTON_CORNER_RADIUS;

    viPassword.layer.cornerRadius = YES;
    viPassword.layer.cornerRadius = BUTTON_CORNER_RADIUS;
}

- (void) hideKeyboard
{
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
}

- (IBAction)actionLogin:(id)sender
{
    [self hideKeyboard];
    
    NSString* email = tfEmail.text;
    NSString* password = tfPassword.text;
    
    if(email == nil || ![AppEngine emailValidate: email])
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_EMAIL] animated: YES completion: nil];
        return;
    }
    
    if(password == nil || [password length] == 0)
    {
        [self presentViewController: [AppEngine showAlertWithText: MSG_INVALID_PASSWORD] animated: YES completion: nil];
        return;
    }
    
    [SVProgressHUD show];
    [[NetworkClient sharedClient] loginWithEmail: email
                                        password: password
                                         success:^(NSDictionary *responseObject) {
                                             
                                             [SVProgressHUD dismiss];
                                             int success = [[responseObject valueForKey: @"success"] intValue];
                                             if(success == 1)
                                             {
                                                 NSDictionary* dicUser = [[responseObject valueForKey: @"data"] valueForKey: @"user"];
                                                 [AppEngine sharedInstance].currentUser = [[User alloc] initWithDictionary: dicUser];
                                                 
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
                                             
                                             [SVProgressHUD dismiss];
                                             NSLog(@"login error = %@", error);
                                         }];
    
}

- (IBAction)actionFB:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken])
             {
                 [SVProgressHUD show];
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      
                      if (!error)
                      {
                          NSLog(@"fetched user:%@", result);
                          NSString* fbId = [result valueForKey: @"id"];
                          NSString* name = [result valueForKey: @"name"];
                          
                          [[NetworkClient sharedClient] loginWithFB: fbId
                                                               name: name
                                                            success:^(NSDictionary *responseObject) {
                                                                
                                                                [SVProgressHUD dismiss];
                                                                int success = [[responseObject valueForKey: @"success"] intValue];
                                                                if(success)
                                                                {
                                                                    NSDictionary* dicUser = [responseObject valueForKey: @"data"][@"user"];
                                                                    User* u = [[User alloc] initWithDictionary: dicUser];
                                                                    [[CoreHelper sharedInstance] addUser: u];
                                                                    [AppEngine sharedInstance].currentUser = u;
                                                                    
                                                                    [self gotoMainView: YES];
                                                                }
                                                                else
                                                                {
                                                                    NSString* message = [responseObject valueForKey: @"message"];
                                                                    [self presentViewController: [AppEngine showErrorWithText: message]
                                                                                       animated: YES
                                                                                     completion: nil];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
                                                                [SVProgressHUD dismiss];
                                                                [self presentViewController: [AppEngine showErrorWithText: MSG_INTERNET_ERROR]
                                                                                   animated: YES
                                                                                 completion: nil];
                                                            }];
                      }
                      else
                      {
                          [SVProgressHUD dismiss];
                          [self presentViewController: [AppEngine showErrorWithText: error.description]
                                             animated: YES
                                           completion: nil];
                      }
                  }];
             }
         }
     }];
}

- (IBAction)actionForgotPassword:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Forgot Password" message: @"Please type your email address." preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //Do Some action here
                                                   UITextField *textField = alert.textFields[0];
                                                   NSLog(@"text was %@", textField.text);
                                                   
                                                   NSString* email = textField.text;
                                                   if(email == nil && [AppEngine emailValidate: email])
                                                   {
                                                       [self presentViewController: [AppEngine showErrorWithText: MSG_INVALID_EMAIL]
                                                                          animated: YES
                                                                        completion: nil];
                                                       return;
                                                   }
                                                   
                                                   [SVProgressHUD show];
                                                   [[NetworkClient sharedClient] forgotPassword: email
                                                                                        success:^(NSDictionary *responseObject) {
                                                                                            
                                                                                            [SVProgressHUD dismiss];
                                                                                            NSLog(@"url = %@", [responseObject valueForKey: @"url"]);
                                                                                            NSString* message = [responseObject valueForKey: @"message"];
                                                                                            [self presentViewController: [AppEngine showMessage: message
                                                                                                                                          title: nil]
                                                                                                               animated: YES
                                                                                                             completion: nil];
                                                                                            
                                                                                            
                                                                                        } failure:^(NSError *error) {
                                                                                            NSLog(@"error = %@", error);
                                                                                            [SVProgressHUD dismiss];
                                                                                            [self presentViewController: [AppEngine showErrorWithText: MSG_INTERNET_ERROR]
                                                                                                               animated: YES
                                                                                                             completion: nil];
                                                                                        }];
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - UITextField Delegate.
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == tfEmail)
    {
        [tfPassword becomeFirstResponder];
    }
    else if(textField == tfPassword)
    {
        [textField resignFirstResponder];
        [self actionLogin: nil];
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(IS_IPHONE_4_OR_LESS)
    {
        [scMain setContentOffset: CGPointMake(0, 60.0) animated: YES];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [scMain setContentOffset: CGPointZero animated: YES];
}


@end
