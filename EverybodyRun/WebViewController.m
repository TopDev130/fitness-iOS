//
//  WebViewController.m
//  EverybodyRun
//
//  Created by star on 4/18/16.
//  Copyright © 2016 samule. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
{
    
}

@property (nonatomic, weak) IBOutlet UILabel                *lbTitle;
@property (nonatomic, weak) IBOutlet UIWebView              *webView;

@end

@implementation WebViewController
@synthesize lbTitle;
@synthesize webView;

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
    
    lbTitle.text = self.title;
    [SVProgressHUD show];
    
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: self.url]];
    [webView loadRequest: request];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [self presentViewController: [AppEngine showErrorWithText: MSG_WEB_PAGE_NOT_VALID] animated: YES completion: nil];
}

- (IBAction) actionBack:(id)sender {
    
    [SVProgressHUD dismiss];
    [super actionBack: sender];
}

@end
