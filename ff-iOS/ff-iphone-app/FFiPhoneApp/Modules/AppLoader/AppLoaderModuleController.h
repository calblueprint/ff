//
//  AppLoaderModuleController.h
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleControllerProtocol.h"

@class FFDataUser, FFDataLocation, FFDataDonation, FFError;

@interface AppLoaderModuleController : NSObject <ModuleControllerProtocol>

@property (strong, nonatomic) UIStoryboard *storyboard;

- (UIViewController *)instantiateLoaderViewController;
- (void)loadUserDataWithCompletion:(void (^)(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations))completionBlock;

@end
