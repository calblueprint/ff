//
//  AuthenticationBaseViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AuthenticationBaseViewController.h"

@interface AuthenticationBaseViewController ()

@end

@implementation AuthenticationBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    // If there are no presented view controllers
    //  and the current view controller is being dismissed,
    //  invoke the completion block.
    if (self.completionBlock && !self.presentingViewController) {
        self.completionBlock();
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setModuleController:self.moduleController];
}

@end
