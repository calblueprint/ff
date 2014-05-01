//
//  AccountModuleController.h
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleControllerProtocol.h"
#import "MMDrawerController.h"


@class FFDataUser;

@protocol AccountModuleControllerDelegate <NSObject>

- (void)didReceiveRequestToLogoutUserWithSender:(id)sender;

@end

@interface AccountModuleController : NSObject <ModuleControllerProtocol>

@property (weak, nonatomic) id <AccountModuleControllerDelegate> delegate;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) FFDataUser *user;
@property (strong, nonatomic) MMDrawerController *mmDrawerController;


- (UIViewController *)instantiateProfileViewController;
- (void)logoutUser;

@end
