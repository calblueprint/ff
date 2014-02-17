//
//  AuthenticationModuleController.h
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModuleControllerProtocol.h"

@class FFDataUser, FFError;

@interface AuthenticationModuleController : NSObject <ModuleControllerProtocol>

@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) void (^completion)(BOOL isSuccess, NSString *authToken, FFError *error);

- (UIViewController *)instantiateOptionsViewController;
- (UIViewController *)instantiateLoginViewController;
- (void)didCreateAuthToken:(NSString *)authToken sender:(id)sender;
- (void)didFailCreatingAuthTokenWithError:(FFError *)error sender:(id)sender;

@end
