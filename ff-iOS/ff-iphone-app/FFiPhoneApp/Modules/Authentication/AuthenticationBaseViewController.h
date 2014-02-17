//
//  AuthenticationBaseViewController.h
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthenticationModuleController;

@interface AuthenticationBaseViewController : UIViewController

@property (strong, nonatomic) AuthenticationModuleController *moduleController;
@property (strong, nonatomic) void (^completionBlock)(void);

@end
