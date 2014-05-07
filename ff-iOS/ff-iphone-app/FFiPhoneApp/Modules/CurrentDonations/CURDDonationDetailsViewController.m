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
@property (strong, nonatomic) IBOutlet UIImageView *iconForStatusAwaitingDriver;
@property (strong, nonatomic) IBOutlet UIImageView *iconForStatusAwaitingPickup;
@property (strong, nonatomic) IBOutlet UIImageView *iconForStatusPickedUp;
@property (strong, nonatomic) IBOutlet UIImageView *iconForStatusCanceled;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusAwaitingDriverAssignment;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusAwaitingPickup;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusPickedUp;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusCanceled;
@property (strong, nonatomic) IBOutlet UIButton *buttonCancelDonation;

- (IBAction)buttonCancelDonation_onTouchUpInsde:(id)sender;

@end

@implementation CURDDonationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    [self.labelDonationTitle setText:self.donation.donationTitle];
    [self.labelDonationTitle setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:25]];
    [self.labelStatusText setText:self.donation.statusText];
    [self.labelStatusText setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16]];
    [self.labelTotalLBS setText:[NSString stringWithFormat:@"%u pounds", self.donation.totalLBS]];
    [self.labelTotalLBS setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16]];
    
    // Show meal photo
    self.imageViewMealPhoto.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewMealPhoto.clipsToBounds = YES;
    [self.imageViewMealPhoto setImage:[UIImage imageNamed:self.donation.mealPhoto.imageURL]];
    

    [self.labelAddress setText:[self.donation.location formattedAddress]];
    [self.labelAvailableDate setText:[self.donation.availableStart ff_stringWithFormat:@"LLLL d"]];
    [self.labelAvailableTime setText:[NSString stringWithFormat:@"%@ - %@", [self.donation.availableStart ff_stringWithFormat:@"hh:mm a"], [self.donation.availableEnd ff_stringWithFormat:@"hh:mm a"]]];
    
    [self.buttonCancelDonation.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:18]];
    
    //Set Donation status icons and labels
    [self.labelStatusAwaitingDriverAssignment setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16]];
    [self.labelStatusAwaitingDriverAssignment setTextColor:[UIColor lightGrayColor]];
    [self.labelStatusAwaitingPickup setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16]];
    [self.labelStatusAwaitingPickup setTextColor:[UIColor lightGrayColor]];
    [self.labelStatusPickedUp setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16]];
    [self.labelStatusPickedUp setTextColor:[UIColor lightGrayColor]];
    [self.labelStatusCanceled setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16]];
    [self.labelStatusCanceled setTextColor:[UIColor lightGrayColor]];
    
    [self.iconForStatusAwaitingDriver setImage:[[UIImage imageNamed:@"find_user-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.iconForStatusAwaitingDriver setTintColor:[UIColor lightGrayColor]];
    [self.iconForStatusAwaitingPickup setImage:[[UIImage imageNamed:@"cars-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.iconForStatusAwaitingPickup setTintColor:[UIColor lightGrayColor]];
    [self.iconForStatusPickedUp setImage:[[UIImage imageNamed:@"checkmark-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.iconForStatusPickedUp setTintColor:[UIColor lightGrayColor]];
    [self.iconForStatusCanceled setImage:[[UIImage imageNamed:@"cancel-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.iconForStatusCanceled setTintColor:[UIColor lightGrayColor]];
    
    
    // Donation status
    int donationStatus = self.donation.statusCode;
    NSLog(@"Donation status: %d", donationStatus);
    //FFDataDelivery *delivery = self.donation.delivery;
    
    /**
     Donation Statuses:
     1 = awaiting driver assignment
     2 = awaiting pickup
     3 = picked up
     4 = canceled
     */
    
    switch (donationStatus) {
        case 1:
            [self.class setTintBlue:self.iconForStatusAwaitingDriver];
            [self.class setTextBlue:self.labelStatusAwaitingDriverAssignment];
            break;
        case 2:
            [self.class setTintBlue:self.iconForStatusAwaitingPickup];
            [self.class setTextBlue:self.labelStatusAwaitingPickup];
            break;
        case 3:
            [self.class setTintBlue:self.iconForStatusPickedUp];
            [self.class setTextBlue:self.labelStatusPickedUp];
            break;
        case 4:
            [self.class setTintBlue:self.iconForStatusCanceled];
            [self.class setTextBlue:self.labelStatusCanceled];
            break;
        default:
            break;
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

+ (void)setTintBlue:(UIImageView *)imageView
{
    UIColor *bpBlue = [UIColor colorWithRed:27.0/255 green:117.0/255 blue:188.0/255 alpha:1.0];
    [imageView setTintColor:bpBlue];
}

+ (void)setTextBlue:(UILabel *)label
{
    UIColor *bpBlue = [UIColor colorWithRed:27.0/255 green:117.0/255 blue:188.0/255 alpha:1.0];
    [label setTextColor:bpBlue];
}


@end
