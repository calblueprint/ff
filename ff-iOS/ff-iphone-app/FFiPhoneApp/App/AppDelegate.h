//
//  AppDelegate.h
//  FFiPhoneApp
//
//  Created by lee on 7/21/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) MMDrawerController * drawerController;

@end
