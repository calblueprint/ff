//
//  AUTFacebookLoginViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/30/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AUTFacebookLoginViewController.h"

#import "AuthenticationConstants.h"
#import "AuthenticationModuleController.h"

#import "FFKit.h"

@interface AUTFacebookLoginViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *viewWebViewBackground;
@property (nonatomic) NSInteger maximumLoginTimes;

- (IBAction)buttonExit_onTouchUpInside:(id)sender;
- (void)login;

@end

@implementation AUTFacebookLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.webView setHidden:YES];
    [self setMaximumLoginTimes:3];
    [self login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonExit_onTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login
{
    if (self.maximumLoginTimes-- < 0 ) {
        [FFUI showPopupMessageWithTitle:@"Error" message:@"Unable to connect to Facebook. Please try again later."];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kOAuthEndpointURL, kOAuthRequestPath]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Retrieve auth token from request.URL
    if ([request.URL.scheme isEqualToString:kOAuthTokenPassingURLScheme]) {
        [self.moduleController didCreateAuthToken:request.URL.host sender:self];
        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FFUI showLoadingViewOnView:self.viewWebViewBackground visible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [FFUI showLoadingViewOnView:self.viewWebViewBackground visible:NO];
    [self.webView setHidden:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Ignore the error about our custom scheme url
    NSURL *url = [error.userInfo ff_objectForKey:@"NSErrorFailingURLKey"];
    if ([url.scheme isEqualToString:kOAuthTokenPassingURLScheme]) {
        return;
    }

    // Retry after 3 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        [self login];
    });
}

@end
