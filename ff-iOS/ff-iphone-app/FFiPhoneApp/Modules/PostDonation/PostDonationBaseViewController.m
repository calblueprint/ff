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

@end
