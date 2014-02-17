//
//  ModuleControllerProtocol.h
//  FFiPhoneApp
//
//  Created by lee on 8/2/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModuleCoordinator;

@protocol ModuleControllerProtocol <NSObject>

+ (BOOL)isModuleMemberWithViewController:(id)viewController;
- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator;

@end
