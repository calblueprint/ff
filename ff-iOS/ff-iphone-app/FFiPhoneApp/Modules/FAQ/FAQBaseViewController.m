//
//  FAQBaseViewController.m
//  FFiPhoneApp
//
//  Created by Tony Wu on 4/16/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import "FAQBaseViewController.h"

@interface FAQBaseViewController ()

@end

@implementation FAQBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setModuleController:self.moduleController];
}

@end
