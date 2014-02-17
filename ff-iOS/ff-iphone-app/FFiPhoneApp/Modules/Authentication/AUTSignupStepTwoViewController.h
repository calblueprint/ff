//
//  AUTSignupStepTwoViewController.h
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AuthenticationBaseViewController.h"

@class FFDataUser;

@interface AUTSignupStepTwoViewController : AuthenticationBaseViewController

@property (strong, nonatomic) void (^completionWithSuccess)(FFDataUser *user);
@property (strong, nonatomic) FFDataUser *user;

@end
