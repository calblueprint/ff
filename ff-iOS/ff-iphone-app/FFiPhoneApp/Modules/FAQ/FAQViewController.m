//
//  FAQViewController.m
//  FFiPhoneApp
//
//  Created by Tony Wu on 4/16/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import "FAQViewController.h"
#import "FAQModuleController.h"

@interface FAQViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;

@end

@implementation FAQViewController


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
    // Configure button appearances
    [self.menuButton setImage:[UIImage imageNamed:@"menu.png"]];
    [self.menuButton setTintColor:[UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:0.65]];
    UIImage *pawImage = [self.class resizeImage:[UIImage imageNamed:@"ic_blueprint_paw.png"] withWidth:80 withHeight:80];
    [self.linkButton setImage:pawImage forState:UIControlStateNormal];
    
    // Configure label fonts
    [self.aboutLabel setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:25.0]];
    [self.textLabel setFont:[UIFont fontWithName:@"ProximaNovaA-light" size:18.0]];
    [self.createdByLabel setFont:[UIFont fontWithName:@"ProximaNovaA-light" size:17.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (IBAction)menuButtonPressed:(id)sender
{
    [self.moduleController.mmDrawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)pawButtonPressed:(id)sender
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://calblueprint.org"];
    [[UIApplication sharedApplication] openURL:url];
}

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(int)width withHeight:(int)height
{
    CGSize newSize = CGSizeMake(width, height);
    float widthRatio = newSize.width/image.size.width;
    float heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
