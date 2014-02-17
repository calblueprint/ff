//
//  APPLLoaderViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "APPLLoaderViewController.h"
#import "AppLoaderConstants.h"
#import "AppLoaderModuleController.h"
#import "UIImage+animatedGIF.h"
#import "FFKit.h"

@interface APPLLoaderViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *activityIndicatorImageView;

@end

@implementation APPLLoaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   // [self configureAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureAppearance
{
    // Activity Indicator (using annimated gif)
    NSString *activityIndicatorImagePath = [[NSBundle mainBundle] pathForResource:[kAppLoaderActivityIndicatorImage stringByDeletingPathExtension] ofType:[kAppLoaderActivityIndicatorImage pathExtension]];
    NSData *activityIndicatorImageData = [NSData dataWithContentsOfFile:activityIndicatorImagePath];
    
    [self.activityIndicatorImageView setImage:[UIImage animatedImageWithAnimatedGIFData:activityIndicatorImageData]];
}

@end
