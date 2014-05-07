//
//  AppLoaderModuleController.m
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AppLoaderModuleController.h"
#import "AppLoaderConstants.h"

#import "APPLLoaderViewController.h"

#import "ModuleCoordinator.h"

#import "FFKit.h"

@implementation AppLoaderModuleController
{
    //
    // The completion block is called when the initial viewer is being dismissed (to report failures)
    //  and when the current module successfly completes its task. We use dispatch_once()
    //  to ensure the completion block is called exactly once
    //
    dispatch_once_t _completionBlockToken;
    void (^_completionBlock)(FFDataUser *user);
	__weak ModuleCoordinator *_moduleCoordinator;

    NSUInteger _numberOfRemainingCallbackToWait;
    FFDataUser *_user;
}

//
// Module controller protocol methods
//

+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return [viewController isKindOfClass:[AppLoaderBaseViewController class]];
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];

    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        _moduleCoordinator = moduleCoordinator;
        self.storyboard = [UIStoryboard storyboardWithName:kAppLoaderStoryboardName bundle:nil];
    }
    
    return self;
}

// --------------------------

- (UIViewController *)instantiateLoaderViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"APPLLoaderViewController"];
    [viewController setModuleController:self];

    return viewController;
}

- (void)loadUserDataWithCompletion:(void (^)(FFDataUser *user))completionBlock
{
    _completionBlock = completionBlock;
    
    [FFRecordUser retrieveWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        if (isSuccess) {
            _user = user;
        }
        else {
            _user = nil;
        }
				if (_completionBlock) {
				dispatch_once(&_completionBlockToken, ^{
						_completionBlock(_user);
				});
				}
    }];
}

@end
