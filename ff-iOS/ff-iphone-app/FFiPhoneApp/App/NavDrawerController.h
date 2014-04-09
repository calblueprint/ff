//
//  NavDrawerController.h
//  FFiPhoneApp
//
//  Created by William Tang on 4/1/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavDrawerController : UITableViewController

@property (nonatomic) NSArray *viewControllers;
@property (nonatomic) NSInteger *selectedIndex;
@property (nonatomic) UINavigationController *navigationController;

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;

@end
