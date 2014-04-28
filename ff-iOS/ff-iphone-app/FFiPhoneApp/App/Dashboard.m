//
//  Dashboard.m
//  FFiPhoneApp
//
//  Created by lee on 8/10/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "Dashboard.h"

#import "ModuleCoordinator.h"
#import "AppLoaderModuleController.h"
#import "AuthenticationModuleController.h"
#import "PostDonationModuleController.h"
#import "CurrentDonationsModuleController.h"
#import "PastDonationsModuleController.h"
#import "AccountModuleController.h"
#import "POSDPostDonationViewController.h"
#import "FAQModuleController.h"

#import "FFKit.h"

@interface Dashboard ()

@property (strong, nonatomic) ModuleCoordinator *moduleCoordinator;
@property (strong, nonatomic) UIViewController *postDonationViewController;
@property (strong, nonatomic) UIViewController *currentDonationsViewController;
@property (strong, nonatomic) UIViewController *pastDonationsViewController;
@property (strong, nonatomic) UIViewController *accountViewController;
@property (strong, nonatomic) UIViewController *authenticationOptionsViewController;
@property (strong, nonatomic) UIViewController *FAQViewController;
@property (strong, nonatomic) void (^authenticationCompletionBlock)(BOOL isSuccess, NSString *authToken, FFError *error);

@end

@implementation Dashboard

+ (instancetype)sharedDashboard
{
    static Dashboard *sharedDashboard = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDashboard = [[self alloc] init];
    });
    
    return sharedDashboard;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        [self setModuleCoordinator:[ModuleCoordinator sharedCoordinator]];
        
        __weak __typeof(&*self)weakSelf = self;
        ModuleCoordinator *coordinator = self.moduleCoordinator;
        [self setAuthenticationCompletionBlock:^(BOOL isSuccess, NSString *authToken, FFError *error) {
            __strong __typeof(&*weakSelf)strongSelf = weakSelf;
            
            if (isSuccess) {
                // Save auth token
                [coordinator.userDefaults setValue:authToken forKey:kUserDefaultsAuthTokenKey];
                [coordinator.userDefaults synchronize];
                
                // Load user data
                [coordinator loadUserDataWithCompletion:^(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations) {
                    // Configure dashbaord
                    //coordinator.tabBarController = [[Dashboard sharedDashboard] tabBarControllerWithUpdatedUser:user];
                    //[coordinator.tabBarController dismissViewControllerAnimated:YES completion:nil];
                    coordinator.navDrawerController = [[Dashboard sharedDashboard] navDrawerControllerWithUpdatedUser:user];
                    [coordinator.navDrawerController dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else {
                [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
                [coordinator.tabBarController dismissViewControllerAnimated:YES completion:^{
                    //coordinator.tabBarController = [strongSelf tabBarControllerWithReloadedAuthenticationModule];
                    coordinator.navDrawerController = [strongSelf navDrawerControllerWithReloadedAuthenticationModule];
                }];
            }
        }];
    }

    return self;
}


#pragma mark replacing tab bar with nav drawer

- (NavDrawerController *)instantiateNavDrawerControllerWithUser:(FFDataUser *)user
{
    self.navDrawerController = [[NavDrawerController alloc] initWithStyle:UITableViewStyleGrouped];
    
    // Post Donation
    self.postDonationModuleController = [[PostDonationModuleController alloc] initWithModuleCoordinator:self.moduleCoordinator];
    [self.postDonationModuleController setDelegate:self.moduleCoordinator];
    self.postDonationViewController = [self.postDonationModuleController instantiatePostDonationNavigationViewController];
    
    return [self navDrawerControllerWithUpdatedUser:user];
}

- (NavDrawerController *)navDrawerControllerWithUpdatedUser:(FFDataUser *)user
{
    if (!self.navDrawerController) { return nil; }
    
    if (!user)
    {
        /* Create guest dashboard */
        
        // Authentication Options
        self.authenticationModuleController = [[AuthenticationModuleController alloc] initWithModuleCoordinator:self.moduleCoordinator];
        [self.authenticationModuleController setCompletion:self.authenticationCompletionBlock];
        self.authenticationOptionsViewController = [self.authenticationModuleController instantiateOptionsViewController];
        self.navDrawerController.viewControllers = @[self.postDonationViewController,
                                                  self.authenticationOptionsViewController];
        self.navDrawerController.navCellNames = @[@"Donate", @"Account"];
        self.navDrawerController.drawerIcons = @[@"donate.png", @"account.png"];
        
        // Clear user locations data stored in the post donation module
        [self.postDonationModuleController setUserLocations:nil];
        
        // Release inactive modules
        self.currentDonationsModuleController = nil;
        self.pastDonationsModuleController = nil;
        self.accountModuleController = nil;
    }
    else if ([user.role isEqualToString:@"donor"])
    {
        /* Create donor dashboard */
        
        // Current Donations
        self.currentDonationsModuleController = [[CurrentDonationsModuleController alloc] initWithModuleCoordinator:self.moduleCoordinator];
        self.currentDonationsViewController = [self.currentDonationsModuleController instantiateCurrentDonationsNavigationViewController];
        
        // Past Donations
        self.pastDonationsModuleController = [[PastDonationsModuleController alloc] initWithModuleCoordinator:self.moduleCoordinator];
        [self.pastDonationsModuleController setDelegate:self.moduleCoordinator];
        self.pastDonationsViewController = [self.pastDonationsModuleController instantiatePastDonationsNavigationViewController];
        
        // Account
        self.accountModuleController = [[AccountModuleController alloc] initWithModuleCoordinator:self.moduleCoordinator];
        [self.accountModuleController setDelegate:self.moduleCoordinator];
        self.accountViewController = [self.accountModuleController instantiateProfileViewController];
        
        // FAQ
        self.FAQModuleController = [[FAQModuleController alloc] initWithModuleCoordinator:self.moduleCoordinator];
        [self.FAQModuleController setDelegate:self.moduleCoordinator];
        self.FAQViewController = [self.FAQModuleController instantiateFAQViewController];
        
        self.navDrawerController.viewControllers = @[self.postDonationViewController,
                                                  self.currentDonationsViewController,
                                                  self.pastDonationsViewController,
                                                  self.accountViewController,
                                                  self.FAQViewController];
        self.navDrawerController.navCellNames = @[@"Donate", @"Current Donation", @"Past Donations", @"Account", @"About", @"Logout"];
        self.navDrawerController.drawerIcons = @[@"donate.png", @"donatelist.png", @"donatelist.png", @"account.png", @"faq.png", @"logout.png"];
        
        // Release inactive modules
        self.authenticationModuleController = nil;
    }
    
    self.navDrawerController.selectedIndex = 0;
    
    return self.navDrawerController;
}

- (NavDrawerController *)navDrawerControllerWithReloadedPostDonationView
{
    // Post Donation
    self.postDonationViewController = [self.postDonationModuleController instantiatePostDonationNavigationViewController];
    
    // Replace the existing Post Donation view with a new one
    NSMutableArray *navDrawerViewControllers = [NSMutableArray array];
    for (UIViewController *viewController in self.navDrawerController.viewControllers) {
        if ([viewController class] == [self.postDonationViewController class]) {
            [navDrawerViewControllers addObject:self.postDonationViewController];
        }
        else {
            [navDrawerViewControllers addObject:viewController];
        }
    }
    
    self.navDrawerController.viewControllers = navDrawerViewControllers;
    
    return self.navDrawerController;
}

- (NavDrawerController *)navDrawerControllerWithReloadedAuthenticationModule
{
    // Authentication Options
    self.authenticationModuleController = [[AuthenticationModuleController alloc] initWithModuleCoordinator:self.moduleCoordinator];
    [self.authenticationModuleController setCompletion:self.authenticationCompletionBlock];
    self.authenticationOptionsViewController = [self.authenticationModuleController instantiateOptionsViewController];
    
    // Replace the existing Authentication Options view with a new one
    NSMutableArray *navDrawerViewControllers = [NSMutableArray array];
    for (UIViewController *viewController in self.navDrawerController.viewControllers) {
        if ([viewController class] == [self.authenticationOptionsViewController class]) {
            [navDrawerViewControllers addObject:self.authenticationOptionsViewController];
        }
        else {
            [navDrawerViewControllers addObject:viewController];
        }
    }
    
    self.navDrawerController.viewControllers = navDrawerViewControllers;
    
    return self.navDrawerController;
}


@end
