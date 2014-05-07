//
//  AUTLoginViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AUTLoginViewController.h"
#import "AUTSignupStepOneViewController.h"
#import "AUTFacebookLoginViewController.h"

#import "FFKit.h"

#import "AuthenticationModuleController.h"

@interface AUTLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttonLoginFacebook;
@property (strong, nonatomic) IBOutlet UIButton *buttonSignup;
@property (strong, nonatomic) IBOutlet UIButton *buttonForgotPassword;
@property (strong, nonatomic) IBOutlet UIView *viewLoginFieldsBackground;

- (IBAction)buttonSignup_onTouchUpInside:(id)sender;
- (IBAction)buttonExit_onTouchUpInside:(id)sender;


@end

@implementation AUTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLogin_onTouchUpInside:(id)sender
{
    [self.view endEditing:YES];
    [FFUI showLoadingViewOnView:self.view visible:YES];
    [self.buttonLogin setEnabled:NO];
    
    [self createAuthTokenWithSuccess:nil failure:^{
        [FFUI showLoadingViewOnView:self.view visible:NO];
        [self.buttonLogin setEnabled:YES];
    }];
}

- (IBAction)buttonSignup_onTouchUpInside:(id)sender
{
    [self presentSignupView];
}

- (IBAction)buttonExit_onTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureAppearance
{
    [self.textFieldEmail ff_styleWithPadding];
    [self.textFieldPassword ff_styleWithPadding];
    [self.buttonLogin ff_styleWithShadow];
    [self.buttonLoginFacebook ff_styleWithShadow];
    [self.buttonSignup ff_styleWithShadow];
    [self.viewLoginFieldsBackground ff_styleWithRoundCorners];
    [self.viewLoginFieldsBackground ff_styleWithShadow];
}

- (void)presentSignupView
{
    if ([self.presentingViewController isMemberOfClass:[AUTSignupStepOneViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self performSegueWithIdentifier:@"presentSignupStepOneView" sender:nil];
    }
}

- (void)createAuthTokenWithSuccess:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
{
    [[FFRecordAuthToken initWithEmail:self.textFieldEmail.text andPassword:self.textFieldPassword.text] createWithCompletion:^(BOOL isSuccess, NSString *authToken, FFError *error) {
        
        if (isSuccess) {
            [self.moduleController didCreateAuthToken:authToken sender:self];
            
            if (successBlock) { successBlock(); }
        }
        else {
            [self.moduleController didFailCreatingAuthTokenWithError:error sender:self];
            [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
            
            if (failureBlock) { failureBlock(); }
        }
    }];
}

#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.textFieldEmail.text.length > 0 && self.textFieldPassword.text.length > 0) {
        [self buttonLogin_onTouchUpInside:nil];
    }
    
    return YES;
}

@end
