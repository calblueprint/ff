//
//  CURDDonationDetailsViewController.h
//  FFiPhoneApp
//
//  Created by lee on 8/11/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "CurrentDonationsBaseViewController.h"

@class FFDataDonation, CURDCurrentDonationsViewController;

@interface CURDDonationDetailsViewController : CurrentDonationsBaseViewController

@property (weak, nonatomic) CURDCurrentDonationsViewController *currentDonationsViewController;
@property (strong, nonatomic) FFDataDonation *donation;

@end
