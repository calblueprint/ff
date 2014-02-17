//
//  SOCSShareDonationViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/14/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "SOCSShareDonationViewController.h"

#import "SocialShareModuleController.h"
#import "SocialShareConstants.h"

#import "FFKit.h"

@interface SOCSShareDonationViewController ()

@property (strong, nonatomic) IBOutlet UILabel *labelMessage;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPicture;
@property (strong, nonatomic) IBOutlet UIView *viewMessageBackground;
@property (weak, nonatomic) FFDataDonation *donation;
@property (weak, nonatomic) UIImage *mealPhoto;
@property (copy, nonatomic) NSString *message;

- (IBAction)buttonShare_onTouchUpInside:(id)sender;
- (IBAction)buttonCancel_onTouchUpInside:(id)sender;
- (IBAction)buttonExit_onTouchUpInside:(id)sender;

@end

@implementation SOCSShareDonationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureAppearance];
    
    [self setDonation:self.moduleController.donation];
    [self setMealPhoto:self.moduleController.mealPhoto];
    
    // Set picture
    if (!self.mealPhoto) {
        [self setMealPhoto:[UIImage imageNamed:kSocialShareShareDonationDefaultPicture]];
    }
    [self.imageViewPicture setImage:self.mealPhoto];
    
    // Set message
    self.message = [kSocialShareShareDonationDefaultMessage stringByReplacingOccurrencesOfString:@"%total_lbs%"
                                                                                      withString:[NSString stringWithFormat:@"%u", self.donation.totalLBS]];
    self.message = [self.message stringByReplacingOccurrencesOfString:@"%donation_title%" withString:self.donation.donationTitle];
    [self.labelMessage setText:self.message];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonShare_onTouchUpInside:(id)sender
{
    [self share];
}

- (IBAction)buttonCancel_onTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonExit_onTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)share
{
    NSArray* dataToShare = @[self.message, self.mealPhoto];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeMail];
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
        if (completed) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];

    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)configureAppearance
{
    [self.viewMessageBackground ff_styleWithRoundCorners];
}

@end
