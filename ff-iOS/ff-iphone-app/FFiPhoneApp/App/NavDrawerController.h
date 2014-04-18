//
//  NavDrawerController.h
//  FFiPhoneApp
//
//  Created by William Tang on 4/1/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface NavDrawerController : UITableViewController

@property (nonatomic) NSArray *viewControllers;
@property (nonatomic) NSArray *navCellNames;
@property (nonatomic) NSArray *drawerIcons;
@property (nonatomic) NSInteger *selectedIndex;

@property (nonatomic) MMDrawerController *mmDrawerController;

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(int)width withHeight:(int)height;

@end
