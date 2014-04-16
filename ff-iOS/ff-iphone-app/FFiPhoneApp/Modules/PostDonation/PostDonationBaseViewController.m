//
//  PostDonationBaseViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PostDonationBaseViewController.h"

#import "POSDNavigationController.h"

@interface PostDonationBaseViewController ()

@end

@implementation PostDonationBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *navDrawerButton = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:@"menu.png"]
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(menuButtonPressed:)];
    [navDrawerButton setTintColor:[UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:0.65]];
    self.navigationItem.leftBarButtonItem = navDrawerButton;
    
	if (!_moduleController) {
		   [self setModuleController:((POSDNavigationController *)self.navigationController).moduleController];
	}

	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)menuButtonPressed: (id)selector {
    NSLog(@"MENU BUTTON PRESSEd: %@", self.moduleController.mmDrawerController);
    //open up left drawer of MMDrawerController
    [self.moduleController.mmDrawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

@end
