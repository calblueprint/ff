//
//  AuthenticationModuleController.m
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AuthenticationModuleController.h"
#import "AuthenticationConstants.h"
#import "AuthenticationBaseViewController.h"

#import "ModuleCoordinator.h"

#import "AUTSignupStepTwoViewController.h"

#import "FFKit.h"

@implementation AuthenticationModuleController
{
    //
    // The completion block is called when the initial viewer is being dismissed (to report failures)
    //  and when the current module successfly completes its task. We use dispatch_once()
    //  to ensure the completion block is called exactly once
    //
    dispatch_once_t _completionBlockToken;
	__weak ModuleCoordinator *_moduleCoordinator;
}

//
// Module protocol methods
//

+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return [viewController isKindOfClass:[AuthenticationBaseViewController class]];
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        _moduleCoordinator = moduleCoordinator;
        self.storyboard = [UIStoryboard storyboardWithName:kAuthenticationStoryboardName bundle:nil];
    }

    return self;
}

//----------------------

- (UIViewController *)instantiateOptionsViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"AUTOptionsViewController"];
    [viewController setModuleController:self];

    return viewController;
}

- (UIViewController *)instantiateLoginViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"AUTLoginViewController"];
    [viewController setModuleController:self];
    
    if (self.completion) {
        [viewController setCompletionBlock:^{
            dispatch_once(&_completionBlockToken, ^{
                self.completion(NO, nil, nil);
            });
        }];
    }

    return viewController;
}

- (void)didCreateAuthToken:(NSString *)authToken sender:(id)sender;
{
    DebugLog(@"Did create auth token: %@", authToken);
    
    // Notify delegate so that it could configure authToken on FFRecords
    [[ModuleCoordinator sharedCoordinator] didCreateAuthToken:authToken sender:self];
    
    // Retrieve user info
    [FFRecordUser retrieveWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        
        if (isSuccess)
        {
            DebugLog(@"Retrieved user info");
            
            // Check if the user's data is incomplete
            if (!user.role || !user.defaultLocation) {
                AUTSignupStepTwoViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"AUTSignupStepTwoViewController"];
                [controller setUser:user];
                [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [controller setCompletionWithSuccess:^(FFDataUser *user) {
                    if (self.completion) {
                        dispatch_once(&_completionBlockToken, ^{
                            self.completion(YES, authToken, nil);
                        });
                    }
                }];
                [sender presentViewController:controller animated:YES completion:nil];
            }
            else if (![user.role isEqualToString:@"donor"]) {
                //
                // Allow only donors to login
                //
                [_moduleCoordinator didReceiveRequestToRemoveAuthToken:authToken sender:self];
                
                if (self.completion) {
                    dispatch_once(&_completionBlockToken, ^{
                        self.completion(NO, nil, [FFError initWithErrorType:@"role_error"
                                                             andDescription:@"Sorry, but it looks like you are not registered as a donor. Currently, this app is only for donors."]);
                    });
                }
            }
            else {
                if (self.completion) {
                    dispatch_once(&_completionBlockToken, ^{
                        self.completion(YES, authToken, nil);
                    });
                }
            }
        }
        else
        {
            DebugLog(@"Failed to retreive user info");

            [_moduleCoordinator didReceiveRequestToRemoveAuthToken:authToken sender:self];

            if (self.completion) {
                dispatch_once(&_completionBlockToken, ^{
                    self.completion(NO, nil, [FFError initWithErrorType:@"cannot_retrieve_user_info"
                                                         andDescription:@"Unable to login, please try again"]);
                });
            }
        }
        
    }];
}

- (void)didFailCreatingAuthTokenWithError:(FFError *)error sender:(id)sender;
{
    DebugLog(@"Did fail creating auth token");
    
    [_moduleCoordinator didFailCreatingAuthTokenWithError:error sender:self];
}

@end
