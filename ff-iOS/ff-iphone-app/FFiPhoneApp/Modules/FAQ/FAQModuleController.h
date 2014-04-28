//
//  FAQModuleController.h
//  FFiPhoneApp
//
//  Created by Tony Wu on 4/16/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleControllerProtocol.h"
#import "MMDrawerController.h"

@protocol FAQModuleControllerDelegate <NSObject>
@end

@interface FAQModuleController : NSObject <ModuleControllerProtocol>
@property (weak, nonatomic) id <FAQModuleControllerDelegate> delegate;
@property (strong, nonatomic) MMDrawerController *mmDrawerController;

@property (strong, nonatomic) UIStoryboard *storyboard;
- (UIViewController *)instantiateFAQViewController;
@end
