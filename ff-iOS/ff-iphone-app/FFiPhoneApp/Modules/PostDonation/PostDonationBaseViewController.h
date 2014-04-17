//
//  PostDonationBaseViewController.h
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDonationModuleController.h"
#import "MMDrawerController.h"

@class PostDonationModuleController;

@interface PostDonationBaseViewController : UIViewController

@property (strong, nonatomic) PostDonationModuleController *moduleController;

@end
