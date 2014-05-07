//
//  CURDDonationDetailsViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/11/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "CURDDonationDetailsViewController.h"
#import "CURDCurrentDonationsViewController.h"

#import "CurrentDonationsConstants.h"
#import "CurrentDonationsModuleController.h"

#import "FFKit.h"

#import "UIImageView+AFNetworking.h"

@interface CURDDonationDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageViewMealPhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelDonationTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalLBS;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusText;
@property (strong, nonatomic) IBOutlet UILabel *labelAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelAvailableDate;
@property (strong, nonatomic) IBOutlet UILabel *labelAvailableTime;
@property (strong, nonatomic) IBOutlet UIView *iconForStatusClaimed;
@property (strong, nonatomic) IBOutlet UIView *iconForStatusPickedUp;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusClaimed;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoForStatusClaimed;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusPickedUp;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoForStatusPickedUp;
@property (strong, nonatomic) IBOutlet UIButton *buttonCancelDonation;

- (IBAction)buttonCancelDonation_onTouchUpInsde:(id)sender;
- (IBAction)buttonBack_onTouchUpInside:(id)sender;

@end

@implementation CURDDonationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.labelDonationTitle setText:self.donation.donationTitle];
    [self.labelStatusText setText:self.donation.statusText];
    [self.labelTotalLBS setText:[NSString stringWithFormat:@"%u pounds", self.donation.totalLBS]];
    
    // Show meal photo
    if (self.donation.mealPhoto)
    {
        // Try to load meal photo from image store
        UIImage *mealPhotoThumbImage = [[FFImageStore sharedStore] imageForKey:self.donation.mealPhoto.thumbnailURL];
        
        // If the image store doesn't have it, download it asynchronously.
        if (!mealPhotoThumbImage)
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.donation.mealPhoto.thumbnailURL]];
            __weak __typeof(&*self)weakSelf = self;
            [self.imageViewMealPhoto setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                __strong __typeof(&*weakSelf)strongSelf = weakSelf;
                
                // Save the downloaded image into image store
                [[FFImageStore sharedStore] setImage:image forKey:strongSelf.donation.mealPhoto.thumbnailURL];
                // Show meal photo
                [strongSelf.imageViewMealPhoto setImage:image];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                __strong __typeof(&*weakSelf)strongSelf = weakSelf;
                /* Failed to download image */
                
                // Use default image
                [strongSelf.imageViewMealPhoto setImage:[UIImage imageNamed:kCurrentDonationsDefaultMealPhoto]];
            }];
        }
        else {
            [self.imageViewMealPhoto setImage:mealPhotoThumbImage];
        }
    }
    else {
        // Use default image
        [self.imageViewMealPhoto setImage:[UIImage imageNamed:kCurrentDonationsDefaultMealPhoto]];
    }
    
    [self.labelAddress setText:[self.donation.location formattedAddress]];
    [self.labelAvailableDate setText:[self.donation.availableStart ff_stringWithFormat:@"LLLL d"]];
    [self.labelAvailableTime setText:[NSString stringWithFormat:@"%@ - %@", [self.donation.availableStart ff_stringWithFormat:@"hh:mm a"], [self.donation.availableEnd ff_stringWithFormat:@"hh:mm a"]]];
    
    //
    // Donation status
    //
    // Hide the Cancel Donation button by default, show it only if donationStatus == 0
    [self.buttonCancelDonation setHidden:YES];
    int donationStatus = self.donation.statusCode;
    FFDataDelivery *delivery = self.donation.delivery;
    //  Donation claimed?
    if (donationStatus == 0)
    {
        [self.labelStatusClaimed setText:@"Waiting to assign driver for pick up"];
        [self.labelInfoForStatusClaimed setText:@"Once assigned, you'll be given contact info and the estimated arrival time of the driver."];
        [self setBgOrange:self.iconForStatusClaimed];
        [self.buttonCancelDonation setHidden:NO];
    }
    else
    {
        FFDataUser *recoveryOrg = delivery.recoveryOrg;
        
        [self.labelStatusClaimed setText:@"Driver assigned"];
        [self.labelInfoForStatusClaimed setText:[NSString stringWithFormat:@"%@ (%@)", recoveryOrg.fullName, recoveryOrg.mobilePhoneNumber]];
        [self setBgGreen:self.iconForStatusClaimed];
    }
    // Donation picked up?
    if (donationStatus < 1)
    {
        [self.labelStatusPickedUp setText:@"Awaiting Pick Up"];
        [self.labelInfoForStatusPickedUp setText:@"Once your donation is picked up, it will be taken to a nearby recipient organization."];
    }
    else if (donationStatus == 1)
    {
        // pickup date/time
        if (!delivery.pickupTime) {
            [self.labelInfoForStatusPickedUp setText:@""];
        }
        else {
            [self.labelInfoForStatusPickedUp setText:[NSString stringWithFormat:@"Estimated arrival time: %@ at %@", [delivery.pickupTime ff_stringWithFormat:@"MMMM dd"], [delivery.pickupTime ff_stringWithFormat:@"hh:mm a"]]];
        }
        [self.labelStatusPickedUp setText:@"Awaiting Pick-up and Delivery"];
        [self setBgOrange:self.iconForStatusPickedUp];
    }
    else
    {
        [self.labelStatusPickedUp setText:@"Delivery Confirmed"];
        [self.labelInfoForStatusPickedUp setText:@""];
        [self setBgGreen:self.iconForStatusPickedUp];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonBack_onTouchUpInside:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonCancelDonation_onTouchUpInsde:(id)sender
{
    [self.buttonCancelDonation setEnabled:NO];
    
    // Prompt to ask user if he wants to delete the current donation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                    message:@"Are you sure you want to cancel this donation?"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Yes", @"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        /* Yes */
        [FFUI showLoadingViewOnView:self.view visible:YES];
        [self cancelDonationWithSuccess:^{
            [FFUI showLoadingViewOnView:self.view visible:NO];
            [self.currentDonationsViewController.didViewAppearOneTimeEventsQueue addObject:^{
                [self.moduleController deleteContainerContainingDonation:self.donation];
            }];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^{
            [self.buttonCancelDonation setEnabled:YES];
            [FFUI showLoadingViewOnView:self.view visible:NO];
        }];
    } else {
        /* No */
        [self.buttonCancelDonation setEnabled:YES];
    }
}


- (void)cancelDonationWithSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    [[FFRecordDonation initWithRecordID:self.donation.donationID] deleteWithCompletion:^(BOOL isSuccess, FFError *error) {
        if (isSuccess) {
            if (success) { success(); }
        }
        else {
            [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
            if (failure) { failure(); }
        }
    }];
}

- (void)setBgGreen:(UIView *)view
{
    [view setBackgroundColor:[FFUI colorFromHexString:@"#00BE56"]];
}

- (void)setBgOrange:(UIView *)view
{
    [view setBackgroundColor:[FFUI colorFromHexString:@"#F98200"]];
}


@end
