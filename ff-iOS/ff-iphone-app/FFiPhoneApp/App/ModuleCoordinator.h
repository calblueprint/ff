//
//  ModuleCoordinator.h
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PostDonationModuleController.h"
#import "PastDonationsModuleController.h"
#import "AccountModuleController.h"
#import "NavDrawerController.h"

@class AppDelegate, FFDataUser, FFError;

@interface ModuleCoordinator : NSObject <PostDonationModuleControllerDelegate, PastDonationsModuleControllerDelegate, AccountModuleControllerDelegate>

@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic) NavDrawerController *navDrawerController;
@property (nonatomic, weak) NSUserDefaults *userDefaults;

+ (instancetype)initSharedCoordinator;
+ (instancetype)sharedCoordinator;
- (void)didCreateAuthToken:(NSString *)authToken sender:(id)sender;
- (void)didFailCreatingAuthTokenWithError:(FFError *)error sender:(id)sender;
- (void)didReceiveRequestToRemoveAuthToken:(NSString *)authToken sender:(id)sender;
- (void)loadUserDataWithCompletion:(void (^)(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations))completion;

@end
