//
//  FAQModuleController.h
//  FFiPhoneApp
//
//  Created by Tony Wu on 4/16/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleControllerProtocol.h"


@interface FAQModuleController : NSObject <ModuleControllerProtocol>
@property (strong, nonatomic) UIStoryboard *storyboard;

- (UIViewController *)instantiateFAQViewController;
@end
