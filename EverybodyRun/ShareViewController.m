//
//  ShareViewController.m
//  EverybodyRun
//
//  Created by star on 3/11/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "ShareViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "Branch.h"
#import "BasicMapAnnotation.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ShareViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate, FBSDKSharingDelegate>
{
    UIDocumentInteractionController         *docController;
    DID_COMPLETE_CALL_BACK_BLOCK            completeBlock;
}

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    shareMapView = [[MKMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    shareMapView.mapType = MKMapTypeStandard;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showShareRoute: (Event*) currentEvent
{
    [shareMapView removeAnnotations: shareMapView.annotations];
    for(int i = 0; i < [currentEvent.map_points count]; i++)
    {
        NSString* strRecord = [currentEvent.map_points objectAtIndex: i];
        NSArray* arrItem = [strRecord componentsSeparatedByString: @","];
        
        if(arrItem != nil && [arrItem count] > 1)
        {
            float lat = [[arrItem objectAtIndex: 0] floatValue];
            float lng = [[arrItem objectAtIndex: 1] floatValue];
            
            BasicMapAnnotation* mAnnot = [[BasicMapAnnotation alloc] init];
            mAnnot.coordinate = [[CLLocation alloc] initWithLatitude: lat longitude: lng].coordinate;
            mAnnot.mIndex = (int)i;
            mAnnot.title = PIN_TOP_MESSAGE;
            mAnnot.mKey = LOCATION_PIN;
            [shareMapView addAnnotation:mAnnot];
        }
    }
    
    [self updateShareRegion];
    [shareMapView showAnnotations: shareMapView.annotations animated: NO];
}

- (void) updateShareRegion
{
    [shareMapView removeOverlays: shareMapView.overlays];
    
    // remove polyline if one exists
    if([shareMapView.annotations count] > 1)
    {
        CLLocationCoordinate2D coordinates[shareMapView.annotations.count + 1];
        for (int i = 0; i < [shareMapView.annotations count]; i++)
        {
            BasicMapAnnotation* annotation = [shareMapView.annotations objectAtIndex: i];
            coordinates[i] = annotation.coordinate;
        }
        
        coordinates[shareMapView.annotations.count] = [[shareMapView.annotations firstObject] coordinate];
        
        //Polygon.
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates: coordinates count: shareMapView.annotations.count];
        [shareMapView addOverlay: polyLine];
    }
}

- (void) shareEvent: (Event*) e completedHander: (void (^)(void))completed
{
    if(![e isEventByCurrentUser] && !e.allow_invite_request) return;
    
    [self showShareRoute: e];
    [self.view bringSubviewToFront: shareMapView];
    
    completeBlock = completed;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Share" message: @"Would you like to share this event with your friends"
                                                            preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction* facebookAction = [UIAlertAction actionWithTitle: @"Facebook"
                                                             style: UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               [self shareEventFB: e completedHander: completed];
                                                               
                                                           }];
    UIAlertAction* twitterAction = [UIAlertAction actionWithTitle: @"Twitter"
                                                            style: UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [self shareEventTwitter: e completedHander: completed];
                                                          }];
    UIAlertAction* messageAction = [UIAlertAction actionWithTitle: @"Message"
                                                            style: UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [self shareEventMessage: e completedHander: completed];
                                                          }];
    UIAlertAction* emailAction = [UIAlertAction actionWithTitle: @"Email"
                                                          style: UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            [self shareEventEmail: e completedHander: completed];
                                                        }];
    
    UIAlertAction* instagramAction = [UIAlertAction actionWithTitle: @"Instagram"
                                                          style: UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            [self shareEventInstagram: e completedHander: completed];
                                                        }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle: @"No Thanks"
                                                           style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             completed();
                                                         }];
    [alert addAction: facebookAction];
    [alert addAction: twitterAction];
    [alert addAction: messageAction];
    [alert addAction: emailAction];
    [alert addAction: instagramAction];
    [alert addAction: cancelAction];
    [self presentViewController: alert animated: YES completion: nil];
}

#pragma mark - Sharing.

- (void) shareEventFB: (Event*) e completedHander: (void (^)(void))completed
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", [e.event_id intValue]], @"event_id", nil];
    [SVProgressHUD showWithStatus: @"event link copied to clipboard, feel free to paste"];
    [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
     {

         [self getMapImage: e success:^(UIImage *image) {
             [SVProgressHUD dismiss];
             
             UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
             pasteboard.string = [NSString stringWithFormat: @"%@\n%@", [self getShareMessage: e], url];
             
             FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
             photo.image = image;
             photo.userGenerated = YES;
             
             FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
             content.photos = @[photo];
             content.hashtag = [FBSDKHashtag hashtagWithString: @"#everybodyrun"];

             FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
             dialog.mode = FBSDKShareDialogModeAutomatic;
             dialog.shareContent = content;
             dialog.delegate = self;
             dialog.fromViewController = self;
             [dialog show];
             
         }];
     }];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"fb share result = %@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"fb share error = %@", error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
}

- (void) shareEventTwitter: (Event*) e completedHander: (void (^)(void))completed
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] && [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter])
    {
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", [e.event_id intValue]], @"event_id", nil];
        [SVProgressHUD show];
        [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
         {
             [SVProgressHUD dismiss];
             SLComposeViewController *tweetSheet = [SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeTwitter];
             
             [tweetSheet setInitialText: [self getShareTwitterMessage: e]];
             [tweetSheet addURL: [NSURL URLWithString: url]];
             SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
             {
                 completed();
             };
             
             tweetSheet.completionHandler = myBlock;
             [self getMapImage: e success:^(UIImage *image) {
                 [tweetSheet addImage: image];
                 [self presentViewController:tweetSheet animated:YES completion: nil];
             }];
         }];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"No Twitter Accounts"
                                                                       message: @"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                                                preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [alert addAction: actionOk];
        [self presentViewController: alert animated: YES completion: nil];
    }
}

- (void) shareEventMessage: (Event*) e completedHander: (void (^)(void))completed
{
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message:  @"Your device doesn't support SMS!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", [e.event_id intValue]], @"event_id", nil];
    [SVProgressHUD show];
    [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
     {
         [SVProgressHUD dismiss];
         
         NSString *message = [self getShareMessage: e];
         MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
         messageController.messageComposeDelegate = self;
         [messageController setBody: [NSString stringWithFormat: @"%@\n%@", message, url]];
         [self getMapImage: e success:^(UIImage *image) {
             NSData* imageData = UIImagePNGRepresentation(image);
             [messageController addAttachmentData: imageData typeIdentifier: @"public.data" filename: @"image.png"];
             [self presentViewController:messageController animated:YES completion:nil];
         }];
     }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    completeBlock();
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    completeBlock();
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) shareEventEmail: (Event*) e completedHander: (void (^)(void))completed
{
    if(![MFMailComposeViewController canSendMail])
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message:  @"Your device doesn't support Email!"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
        return;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat: @"%d", [e.event_id intValue]], @"event_id", nil];
    [SVProgressHUD show];
    [[Branch getInstance] getShortURLWithParams:params andCallback:^(NSString *url, NSError *error)
     {
         [SVProgressHUD dismiss];
         // Email Content
         NSString *messageBody = [self getShareMessage: e];
         MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
         mc.mailComposeDelegate = self;
         [mc setMessageBody: [NSString stringWithFormat: @"%@\n%@", messageBody, url] isHTML:NO];
         [self getMapImage: e success:^(UIImage *image) {
             NSData* imageData = UIImagePNGRepresentation(image);
             [mc addAttachmentData: imageData mimeType: @"image/png" fileName: @"image.png"];
             [self presentViewController:mc animated:YES completion:nil];
         }];
     }];
}

- (void) shareEventInstagram: (Event*) e completedHander: (void (^)(void))completed
{
    //Sharing Instagram.
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        [self getMapImage: e success:^(UIImage *image) {
            UIImage* imageNew = [self addWaterMark: image];
            NSData *imageData=UIImagePNGRepresentation(imageNew);
            NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
            if (![imageData writeToFile:writePath atomically:YES]) {
                // failure
                NSLog(@"image save failed to path %@", writePath);
            }
            else {
                // success.
            }
            
            NSURL *imageURL=[NSURL fileURLWithPath: writePath];
            docController = [UIDocumentInteractionController interactionControllerWithURL: imageURL];
            //        docController.UTI=@"com.instagram.photo";
            docController.delegate = self;
            [docController presentOpenInMenuFromRect: self.view.frame inView: self.view animated: YES];
        }];
    }
    else
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message: MSG_INSTAGRAM_NOT_SUPPORT
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
    }

}

- (UIImage *)imageByCroppingImage:(UIImage *)image width: (float) width
{
    float w1 = image.size.width;
    if(image.size.width > image.size.height)
    {
        w1 = image.size.height;
    }
    
    float w2 = width;
    if(w1 < width)
    {
        w2 = w1;
    }
    
    double x = (image.size.width - w2) / 2.0;
    double y = (image.size.height - w2) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, w2, w2);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (UIImage*) addShareEventWaterMark: (UIImage*) backgroundImage
{
    UIImage *watermarkImage = [UIImage imageNamed:@"watermark"];
    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, YES, backgroundImage.scale);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    float fw = watermarkImage.size.width / 2.0;
    float fh = watermarkImage.size.height / 2.0;
    float offset = 17.0;
    
    [watermarkImage drawInRect:CGRectMake(offset,
                                          offset,
                                          fw,
                                          fh)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


- (UIImage*) addWaterMark: (UIImage*) backgroundImage
{
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    float scale = [UIScreen mainScreen].scale;
//    UIImage* croppedImage = [self imageByCroppingImage: backgroundImage width: screenBound.size.width * scale];
    
    UIImage* croppedImage = backgroundImage;
    UIImage *watermarkImage = [UIImage imageNamed:@"mask_image.png"];
    
    UIGraphicsBeginImageContextWithOptions(croppedImage.size, YES, croppedImage.scale);
    [croppedImage drawInRect:CGRectMake(0, 0, croppedImage.size.width, croppedImage.size.height)];
    
    float fw = watermarkImage.size.width / 2.0;
    float fh = watermarkImage.size.height / 2.0;
    float offset = 17.0;
    
    [watermarkImage drawInRect:CGRectMake(croppedImage.size.width - fw - offset,
                                          offset,
                                          fw,
                                          fh)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (void) postInstagrame: (UIImage*) image completedHander: (void (^)(void))completed
{
    completeBlock = completed;
    
    //Sharing Instagram.
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        UIImage* imageNew = [self addWaterMark: image];
        NSData *imageData=UIImagePNGRepresentation(imageNew);
        NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
        if (![imageData writeToFile:writePath atomically:YES]) {
            // failure
            NSLog(@"image save failed to path %@", writePath);
        }
        else {
            // success.
        }
        
        NSURL *imageURL=[NSURL fileURLWithPath: writePath];
        docController = [UIDocumentInteractionController interactionControllerWithURL: imageURL];
//        docController.UTI=@"com.instagram.photo";
        docController.delegate = self;
        [docController presentOpenInMenuFromRect: self.view.frame inView: self.view animated: YES];
    }
    else
    {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: nil
                                                                            message: MSG_INSTAGRAM_NOT_SUPPORT
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* actionOk = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completed();
        }];
        [controller addAction: actionOk];
        [self presentViewController: controller animated: YES completion: nil];
    }
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(nullable NSString *)application
{
    completeBlock();
}

- (void) getMapImage: (Event*) e success: (void (^)(UIImage *image))success
 {
    //Get Image.
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = shareMapView.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = shareMapView.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
     [snapshotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
         // get the image associated with the snapshot
         UIImage *image = snapshot.image;
         
         // Get the size of the final image
         CGRect finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height);
         
         // Get a standard annotation view pin. Clearly, Apple assumes that we'll only want to draw standard annotation pins!
         MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
         UIImage *pinImage = [UIImage imageNamed: @"open_event_double"];
         
         // ok, let's start to create our final image
         
         UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
         
         // first, draw the image from the snapshotter
         
         [image drawAtPoint:CGPointMake(0, 0)];
         
         // now, let's iterate through the annotations and draw them, too
         
         CGContextRef context = UIGraphicsGetCurrentContext();
         
         CGContextSetStrokeColorWithColor(context,  [COLOR_GREEN_BTN CGColor]);
         CGContextSetLineWidth(context, ROUTE_LINE_WIDTH);
         CGContextBeginPath(context);
         
         for(int i = 0; i < [e.map_points count]; i++)
         {
             NSString* strRecord = [e.map_points objectAtIndex: i];
             NSArray* arrItem = [strRecord componentsSeparatedByString: @","];
             
             if(arrItem != nil && [arrItem count] > 1)
             {
                 float lat = [[arrItem objectAtIndex: 0] floatValue];
                 float lng = [[arrItem objectAtIndex: 1] floatValue];
                 
                 CLLocation* loc = [[CLLocation alloc] initWithLatitude: lat longitude: lng];
                 CGPoint point = [snapshot pointForCoordinate:loc.coordinate];
                 
                 if(i == 0) {
                     CGContextMoveToPoint(context,point.x, point.y);
                     if (CGRectContainsPoint(finalImageRect, point)) // this is too conservative, but you get the idea
                     {
                         CGPoint pinCenterOffset = pin.centerOffset;
                         point.x -= pin.bounds.size.width / 2.0;
                         point.y -= pin.bounds.size.height / 2.0;
                         point.x -= pinCenterOffset.x;
                         point.y += pinCenterOffset.y * 3 - 5.0;
                         [pinImage drawAtPoint:point];
                     }
                     
                 }
                 else {
                     CGContextAddLineToPoint(context,point.x, point.y);
                 }
             }
         }
         
         CGContextStrokePath(context);
         
         // grab the final image
         UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         
         UIImage* resultImage = finalImage;
         if([AppEngine sharedInstance].watermarkEnabled) {
             resultImage = [self addShareEventWaterMark: finalImage];
         }

         success(resultImage);
     }];
//    [snapshotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
//    }];
}
@end
