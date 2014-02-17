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

static NSUInteger const kNumberOfCallbackToWait = 4;

@implementation AppLoaderModuleController
{
    //
    // The completion block is called when the initial viewer is being dismissed (to report failures)
    //  and when the current module successfly completes its task. We use dispatch_once()
    //  to ensure the completion block is called exactly once
    //
    dispatch_once_t _completionBlockToken;
    void (^_completionBlock)(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations);
	__weak ModuleCoordinator *_moduleCoordinator;

    NSUInteger _numberOfRemainingCallbackToWait;
    FFDataUser *_user;
    NSArray *_locations;
    NSArray *_currentDonations;
    NSArray *_pastDonations;
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
        
        // Wait for 4 callbacks: User Info, Locations, Active Donations, Past Donations
        _numberOfRemainingCallbackToWait = kNumberOfCallbackToWait;
        
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

- (void)didReceiveCallback
{
    _numberOfRemainingCallbackToWait--;
    if (_numberOfRemainingCallbackToWait == 0) {
        _numberOfRemainingCallbackToWait = kNumberOfCallbackToWait;
        if (_completionBlock) {
            dispatch_once(&_completionBlockToken, ^{
                _completionBlock(_user, _locations, _currentDonations, _pastDonations);
            });
        }
    }
}

- (void)loadUserDataWithCompletion:(void (^)(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations))completionBlock
{
    _completionBlock = completionBlock;
    
    [FFRecordUser retrieveWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        if (isSuccess) {
            _user = user;
        }
        else {
            _user = nil;
        }
        [self didReceiveCallback];
    }];
    
    [FFRecordLocation retrieveWithCompletion:^(BOOL isSuccess, NSArray *locations, FFError *error) {
        if (isSuccess) {
            _locations = locations;
        }
        else {
            _locations = nil;
        }
        [self didReceiveCallback];
    }];
    
    [FFRecordDonation retrieveCurrentDonationsWithMaximumID:-1 completion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
        if (isSuccess) {
            _currentDonations = donations;
        }
        else {
            _currentDonations = nil;
        }
        [self didReceiveCallback];
    }];
    
    [FFRecordDonation retrievePastDonationsWithMaximumID:-1 completion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
        if (isSuccess) {
            _pastDonations = donations;
        }
        else {
            _pastDonations = nil;
        }
        [self didReceiveCallback];
    }];
}

@end
