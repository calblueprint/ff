//
//  AUTOptionsViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/30/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "AUTOptionsViewController.h"

#import "FFKit.h"

@interface AUTOptionsViewController ()

@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttonSignup;
@property (strong, nonatomic) IBOutlet UIButton *buttonLoginFacebook;
@property (strong, nonatomic) IBOutlet UILabel *labelHeaderTitle;

@end

@implementation AUTOptionsViewController

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

- (void)configureAppearance
{
    [self.buttonLoginFacebook ff_styleWithRoundCorners];
}

@end
