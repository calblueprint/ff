//
//  POSDTitleViewController.m
//  FFiPhoneApp
//
//  Created by Alton Zheng-Xie on 3/8/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import "POSDTitleViewController.h"

@interface POSDTitleViewController ()

@end

@implementation POSDTitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init {
	self = [super init];
	if (self) {
		self.identifier = @"POSDTitleViewController";
	}
	return self;
}

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

@end
