//
//  MenuViewController.m
//  EverybodyRun
//
//  Created by star on 3/10/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "MenuTableViewCell.h"
#import "MFSideMenu.h"
#import "SettingsViewController.h"
#import "NotificationViewController.h"
#import "EditProfileViewController.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray                     *arrItems;
    UIImagePickerController     *imagePicker;
}

@property (nonatomic, weak) IBOutlet UILabel        *lbUsername;
@property (nonatomic, weak) IBOutlet UIImageView    *ivAvatar;
@property (nonatomic, weak) IBOutlet UITableView    *tbMain;

@end

@implementation MenuViewController
@synthesize lbUsername;
@synthesize ivAvatar;
@synthesize tbMain;

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
    
    ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width/2.0;
    
    arrItems = @[@"Notifications", @"Settings", @"Tutorial", @"Suggest a Service", @"Ciele Athletics Website", @"Terms of Use", @"Privacy Policy", @"Log out"];
    [tbMain registerNib: [UINib nibWithNibName: @"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MenuTableViewCell class])];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self fillOutInfo];
}

- (void) fillOutInfo {
    [ivAvatar setImageWithURL: [AppEngine getImageURL: [AppEngine sharedInstance].currentUser.profile_photo] placeholderImage: [UIImage imageNamed: @"default_user.png"]];
    
    NSString* firstName = [AppEngine sharedInstance].currentUser.first_name;
    NSString* lastName = [AppEngine sharedInstance].currentUser.last_name;
    lbUsername.text = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
}

- (IBAction) actionLogout:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil
                                                                   message: @"Are you sure to log out?"
                                                            preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle: @"Yes"
                                                        style: UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          [[CoreHelper sharedInstance] logout];
                                                          [self.navigationController popToViewController: [AppDelegate getDelegate].startView animated: YES];
                                                          
                                                      }];
    [alert addAction: yesAction];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No"
                                                       style: UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];
    [alert addAction: noAction];
    [self presentViewController: alert animated: YES completion: nil];
}

#pragma mark - UITableView Delegate.
#pragma mark Contents.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (int)[arrItems count];
}

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([MenuTableViewCell class])];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([MenuTableViewCell class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *name = [arrItems objectAtIndex:indexPath.row];
    [cell setMenuItem: name];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MenuTableViewCell getHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row)
    {
        //Notification
        case 0:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NotificationViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"NotificationViewController"];
            [self.navigationController pushViewController: nextView animated: YES];
        }
            break;
            
        //Settings.
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SettingsViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"SettingsViewController"];
            [self.navigationController pushViewController: nextView animated: YES];
        }
            break;

        //Tutorial
        case 2:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kTutorial]];
            break;

            
        //Suggest a Service.
        case 3:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kSuggestAService]];
            break;

            
        //Ciele HQ
        case 4:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kCieleHQURL]];
            break;
        

        //Terms of Use .
        case 5:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kTermsOfUse]];
            break;

        //Privacy Policy.
        case 6:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kPrivacyPolice]];
            break;

        //Logout.
        case 7:
            [self actionLogout: nil];
            break;
            
        default:
            break;
    }
}

- (IBAction) actionEditProfile:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfileViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: @"EditProfileViewController"];
    [self.navigationController pushViewController: nextView animated: YES];
}

- (IBAction)actionAvatar:(id)sender
{
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
    [self dismissViewControllerAnimated: YES completion:^{
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        ivAvatar.image = image;
        
        UIImage* imgAvatar = [AppEngine imageWithImage: ivAvatar.image scaledToWidth: USER_AVATAR_MAX_SIZE];
        [SVProgressHUD showWithStatus: @"Saving"];
        [[NetworkClient sharedClient] uploadAvatar: imgAvatar
                                           success:^(NSDictionary *responseObject) {
                                               
                                               int success = [[responseObject valueForKey: @"success"] intValue];
                                               if(success == 1)
                                               {
                                                   NSString* avatar = [[responseObject valueForKey: @"data"] valueForKey: @"uploadfile"];
                                                   [self updateProfile: avatar];
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

    }];
}

- (void) updateProfile: (NSString*) avatar{
    [[NetworkClient sharedClient] updateUser: [AppEngine sharedInstance].currentUser.user_id
                                   firstName: nil
                                    lastName: nil
                                       email: nil
                                    birthday: nil
                                      gender: -1
                                      avatar: avatar
                                     success:^(User *u) {
                                         
                                         [SVProgressHUD dismiss];
                                         [AppEngine sharedInstance].currentUser = u;
                                         [[CoreHelper sharedInstance] addUser: [AppEngine sharedInstance].currentUser];
                                         
                                     } failure:^(NSError *error) {
                                         [SVProgressHUD dismiss];
                                         [self presentViewController: [AppEngine showErrorWithText: MSG_INTERNET_ERROR] animated: YES completion: nil];
                                     }];
}


@end
