//
//  AUTSignupStepOneViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AUTSignupStepOneViewController.h"
#import "AUTLoginViewController.h"

#import "FFKit.h"

#import "AuthenticationModuleController.h"

#import "AppDelegate.h"

@interface AUTSignupStepOneViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttonLoginFacebook;
@property (strong, nonatomic) IBOutlet UIButton *buttonSignup;

- (IBAction)buttonExit_onTouchUpInside:(id)sender;
- (IBAction)buttonLogin_onTouchUpInside:(id)sender;

@end

@implementation AUTSignupStepOneViewController

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

- (IBAction)buttonExit_onTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonLogin_onTouchUpInside:(id)sender
{
    [self presentLoginView];
}

- (IBAction)buttonSignup_onTouchUpInside:(id)sender
{
    [self.view endEditing:YES];
    [FFUI showLoadingViewOnView:self.view visible:YES];
    [self.buttonSignup setEnabled:NO];
    
    [self createUserWithSuccess:nil failure:^{
        [FFUI showLoadingViewOnView:self.view visible:NO];
        [self.buttonSignup setEnabled:YES];
    }];
}

- (void)createUserWithSuccess:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
{
    FFDataUser *user = [FFDataUser new];
    [user setEmail:self.textFieldEmail.text];
    [user setPassword:self.textFieldPassword.text];
    
    //
    // Create user
    //
    [[FFRecordUser initWithModelObject:user] createWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        
        if (isSuccess)
        {
            //
            // Create auth token
            //
            [[FFRecordAuthToken initWithEmail:self.textFieldEmail.text andPassword:self.textFieldPassword.text] createWithCompletion:^(BOOL isSuccess, NSString *authToken, FFError *error) {
                
                if (isSuccess) {
                    [self.moduleController didCreateAuthToken:authToken sender:self];
                    
                    if (successBlock) { successBlock(); }
                }
                else {
                    [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
                    [self.moduleController didFailCreatingAuthTokenWithError:error sender:self];
                    
                    if (failureBlock) { failureBlock(); }
                }

            }];
        }
        else {
            [self.moduleController didFailCreatingAuthTokenWithError:error sender:self];
            [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
            
            if (failureBlock) { failureBlock(); }
        }
        
    }];
}

- (void)configureAppearance
{    
    [self.buttonLoginFacebook ff_styleWithRoundCorners];
}

- (void)presentLoginView
{
    if ([self.presentingViewController isMemberOfClass:[AUTLoginViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self performSegueWithIdentifier:@"presentLoginView" sender:nil];
    }
}

#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.textFieldEmail.text.length > 0 && self.textFieldPassword.text.length > 0) {
        [self buttonSignup_onTouchUpInside:nil];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextFieldIfNecessary: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextFieldIfNecessary: textField up: NO];
}

- (void) animateTextFieldIfNecessary:(UITextField *)textField up:(BOOL)up
{
    if (IS_WIDESCREEN()) {
        return;
    }
    
    [FFUI scrollUpView:self.view withDirectionUp:up distance:90];
}

@end
