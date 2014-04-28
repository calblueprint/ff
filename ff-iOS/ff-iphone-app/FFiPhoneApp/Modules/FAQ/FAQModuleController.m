//
//  FAQModuleController.m
//  FFiPhoneApp
//
//  Created by Tony Wu on 4/16/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import "FAQModuleController.h"
#import "FAQBaseViewController.h"
#import "FAQConstants.h"

#import "ModuleControllerProtocol.h"

@implementation FAQModuleController
{
    __weak ModuleCoordinator *_moduleCoordinator;
}

//
// Module protocol methods
//

+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return [viewController isKindOfClass:[FAQBaseViewController class]];
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        _moduleCoordinator = moduleCoordinator;
        self.storyboard = [UIStoryboard storyboardWithName:kFAQStoryboardName bundle:nil];
    }
    
    return self;
}

- (UIViewController *)instantiateFAQViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"FAQViewController"];
//    [viewController setModuleController:self];
    
    return viewController;
}

@end
