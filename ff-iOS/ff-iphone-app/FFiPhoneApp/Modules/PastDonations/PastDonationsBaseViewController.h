//
//  PastDonationsBaseViewController.h
//  FFiPhoneApp
//
//  Created by lee on 8/12/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PastDonationsModuleController;

@interface PastDonationsBaseViewController : UIViewController

@property (strong, nonatomic) PastDonationsModuleController *moduleController;
@property (nonatomic, strong) NSMutableArray *didViewAppearOneTimeEventsQueue;

@end
