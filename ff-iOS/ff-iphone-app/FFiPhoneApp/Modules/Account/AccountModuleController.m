//
//  AccountModuleController.m
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AccountModuleController.h"
#import "AccountBaseViewController.h"
#import "AccountConstants.h"

#import "ModuleControllerProtocol.h"

@implementation AccountModuleController
{
    __weak ModuleCoordinator *_moduleCoordinator;
}

//
// Module protocol methods
//

+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return [viewController isKindOfClass:[AccountBaseViewController class]];
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        _moduleCoordinator = moduleCoordinator;
        self.storyboard = [UIStoryboard storyboardWithName:kAccountStoryboardName bundle:nil];
    }

    return self;
}

//----------------------

- (UIViewController *)instantiateProfileViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"ACCProfileViewController"];
    [viewController setModuleController:self];

    return viewController;
}

- (void)logoutUser
{
    [self.delegate didReceiveRequestToLogoutUserWithSender:self];
}

@end
