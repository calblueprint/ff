//
//  PostDonationCongratulationsViewController.m
//  FFiPhoneApp
//
//  Created by Alton Zheng-Xie on 5/6/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import "PostDonationCongratulationsViewController.h"

@interface PostDonationCongratulationsViewController ()
- (IBAction)seeDonations:(id)sender;
- (IBAction)shareOnFacebook:(id)sender;

@end

@implementation PostDonationCongratulationsViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)seeDonations:(id)sender {
	
}

- (IBAction)shareOnFacebook:(id)sender {
}
@end
