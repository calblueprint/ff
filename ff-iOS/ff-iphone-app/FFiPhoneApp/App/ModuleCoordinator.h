//
//  ModuleCoordinator.h
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PostDonationModuleController.h"
#import "AccountModuleController.h"
#import "FAQModuleController.h"

@class AppDelegate, FFDataUser, FFError, NavDrawerController;


@interface ModuleCoordinator : NSObject <PostDonationModuleControllerDelegate, AccountModuleControllerDelegate, FAQModuleControllerDelegate>

@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic) NavDrawerController *navDrawerController;
@property (nonatomic, weak) NSUserDefaults *userDefaults;

+ (instancetype)initSharedCoordinator;
+ (instancetype)sharedCoordinator;
- (void)didCreateAuthToken:(NSString *)authToken sender:(id)sender;
- (void)didFailCreatingAuthTokenWithError:(FFError *)error sender:(id)sender;
- (void)didReceiveRequestToRemoveAuthToken:(NSString *)authToken sender:(id)sender;
- (void)loadUserDataWithCompletion:(void (^)(FFDataUser *user))completion;

@end
