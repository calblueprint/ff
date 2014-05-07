//
//  AUTSignupStepTwoViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AUTSignupStepTwoViewController.h"

#import "FFKit.h"


@interface AUTSignupStepTwoViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textFieldFullName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *textFieldOrganization;
@property (strong, nonatomic) IBOutlet UIButton *buttonCompleteRegistration;

@end

@implementation AUTSignupStepTwoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [self.textFieldFullName setText:self.user.fullName];
    [self.textFieldPhoneNumber setText:self.user.mobilePhoneNumber];
    [self.textFieldOrganization setText:self.user.organization];
    
    self.textFieldPhoneNumber.inputAccessoryView = [FFUI keyboardToolbarWithDoneButtonOnView:self.view
                                                                          buttonActionTarget:self.textFieldPhoneNumber
                                                                                buttonAction:@selector(resignFirstResponder)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonCompleteRegistration_onTouchUpOnside:(id)sender
{
    [self.view endEditing:YES];
    [FFUI showLoadingViewOnView:self.view visible:YES];
    [self.buttonCompleteRegistration setEnabled:NO];
    
    [self completeRegistrationWithSuccess:nil failure:^{
        [FFUI showLoadingViewOnView:self.view visible:NO];
        [self.buttonCompleteRegistration setEnabled:YES];
    }];
}

- (void)completeRegistrationWithSuccess:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
{
    [self.user setFullName:self.textFieldFullName.text];
    [self.user setMobilePhoneNumber:self.textFieldPhoneNumber.text];
    [self.user setOrganization:self.textFieldOrganization.text];
    
    [[FFRecordUser initWithModelObject:self.user] updateWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        
        if (isSuccess) {
            if (successBlock) { successBlock(); }
            if (self.completionWithSuccess) { self.completionWithSuccess(user); }
        }
        else {
            [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
            if (failureBlock) { failureBlock(); }
        }
    }];
}

- (void)configureAppearance
{

}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
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
    if (textField == self.textFieldFullName) {
        if (!IS_WIDESCREEN()) {
            [FFUI scrollUpView:self.view withDirectionUp:up distance:15];
        }
    }
    else {
        if (IS_WIDESCREEN()) {
            [FFUI scrollUpView:self.view withDirectionUp:up distance:20];
        }
        else {
            [FFUI scrollUpView:self.view withDirectionUp:up distance:115];
        }
    }
}

@end
