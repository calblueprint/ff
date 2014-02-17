//
//  AUTForgotPasswordViewController.m
//  FFiPhoneApp
//
//  Created by lee on 10/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AUTForgotPasswordViewController.h"
#import "AuthenticationConstants.h"
#import "FFKit.h"

@interface AUTForgotPasswordViewController ()

@property (nonatomic, weak) IBOutlet UITextField *textFieldEmail;
@property (nonatomic, weak) IBOutlet UIButton *buttonSendInstructions;

- (IBAction)buttonExit_onTouchUpInside:(id)sender;
- (IBAction)buttonSendInstructions_onTouchUpInside:(id)sender;

@end

@implementation AUTForgotPasswordViewController

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

- (IBAction)buttonSendInstructions_onTouchUpInside:(id)sender
{
    [self.view endEditing:YES];
    [FFUI showLoadingViewOnView:self.view visible:YES];
    [self.buttonSendInstructions setEnabled:NO];
    
    [self sendResetPasswordInstructionsWithSuccess:^{
        [self buttonExit_onTouchUpInside:nil];
    } failure:^{
        [FFUI showLoadingViewOnView:self.view visible:NO];
        [self.buttonSendInstructions setEnabled:YES];
    }];
}

- (void)sendResetPasswordInstructionsWithSuccess:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
{
    FFDataUser *user = [[FFDataUser alloc] init];
    [user setEmail:self.textFieldEmail.text];
    
    [[FFRecordUser initWithModelObject:user] sendResetPasswordInstructionsWithCompletion:^(BOOL isSuccess, FFError *error) {
        
        if (isSuccess) {
            [FFUI showPopupMessageWithTitle:@"Sent" message:@"Instructions for resetting your password have been sent to your email address"];
            if (successBlock) { successBlock(); }
        }
        else {
            [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
            if (failureBlock) { failureBlock(); }
        }
    }];
}

#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    if (self.textFieldEmail.text.length > 0) {
        [self buttonSendInstructions_onTouchUpInside:nil];
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
    
    [FFUI scrollUpView:self.view withDirectionUp:up distance:40];
}

@end
