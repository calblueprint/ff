//
//  CURDNavigationController.h
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrentDonationsModuleController;

@interface CURDNavigationController : UINavigationController

@property (strong, nonatomic) CurrentDonationsModuleController *moduleController;

@end
