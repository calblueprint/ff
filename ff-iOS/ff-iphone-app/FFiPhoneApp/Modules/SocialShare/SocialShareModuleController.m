//
//  SocialShareModuleController.m
//  FFiPhoneApp
//
//  Created by lee on 8/14/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "SocialShareModuleController.h"
#import "SocialShareBaseViewController.h"
#import "SocialShareConstants.h"

@implementation SocialShareModuleController
{
    __weak ModuleCoordinator *_moduleCoordinator;
}

//
// Module protocol methods
//

+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return [viewController isKindOfClass:[SocialShareBaseViewController class]];
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        _moduleCoordinator = moduleCoordinator;
        self.storyboard = [UIStoryboard storyboardWithName:kSocialShareStoryboardName bundle:nil];
    }

    return self;
}

//----------------------

- (UIViewController *)instantiateShareDonationViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"SOCSShareDonationViewController"];
    [viewController setModuleController:self];
    
    return viewController;
}

@end
