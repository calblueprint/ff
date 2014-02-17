//
//  POSDPostDonationNavigationController.h
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostDonationModuleController;

@interface POSDNavigationController : UINavigationController

@property (strong, nonatomic) PostDonationModuleController *moduleController;

@end
