//
//  CurrentDonationsBaseViewController.h
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrentDonationsModuleController;

@interface CurrentDonationsBaseViewController : UIViewController

@property (strong, nonatomic) CurrentDonationsModuleController *moduleController;
@property (nonatomic, strong) NSMutableArray *didViewAppearOneTimeEventsQueue;

@end
