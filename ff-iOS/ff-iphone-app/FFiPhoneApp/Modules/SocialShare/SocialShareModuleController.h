//
//  SocialShareModuleController.h
//  FFiPhoneApp
//
//  Created by lee on 8/14/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModuleControllerProtocol.h"

@class FFDataDonation;

@interface SocialShareModuleController : NSObject <ModuleControllerProtocol>

@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) FFDataDonation *donation;
@property (strong, nonatomic) UIImage *mealPhoto;

- (UIViewController *)instantiateShareDonationViewController;

@end
