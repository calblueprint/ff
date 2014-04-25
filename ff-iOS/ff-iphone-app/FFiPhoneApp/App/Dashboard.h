//
//  Dashboard.h
//  FFiPhoneApp
//
//  Created by lee on 8/10/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavDrawerController.h"


@class FFDataUser, AuthenticationModuleController, CurrentDonationsModuleController, AccountModuleController, PostDonationModuleController, PastDonationsModuleController, FAQModuleController;

@interface Dashboard : NSObject

@property (strong, nonatomic) AuthenticationModuleController *authenticationModuleController;
@property (strong, nonatomic) CurrentDonationsModuleController *currentDonationsModuleController;
@property (strong, nonatomic) PastDonationsModuleController *pastDonationsModuleController;
@property (strong, nonatomic) AccountModuleController *accountModuleController;
@property (strong, nonatomic) PostDonationModuleController *postDonationModuleController;
@property (strong, nonatomic) FAQModuleController *FAQModuleController;

@property (strong, nonatomic) NavDrawerController *navDrawerController;

+ (instancetype)sharedDashboard;

- (NavDrawerController *)instantiateNavDrawerControllerWithUser:(FFDataUser *)user;
- (NavDrawerController *)navDrawerControllerWithUpdatedUser:(FFDataUser *)user;
- (NavDrawerController *)navDrawerControllerWithReloadedPostDonationView;

@end
