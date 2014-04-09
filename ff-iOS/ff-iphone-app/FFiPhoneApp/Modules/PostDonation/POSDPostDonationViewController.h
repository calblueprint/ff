//
//  POSDPostDonationViewController.h
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PostDonationBaseViewController.h"
#import "POSDChooseLocationViewController.h"

@class FFDataDonation, FFImageStore, AppDelegate, POSDChooseLocationViewController, POSDChooseAmountViewController, POSDChooseTimeViewController, POSDTitleViewController,Dashboard;

@interface POSDPostDonationViewController : PostDonationBaseViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, POSDChooseLocationViewControllerDelegate>

@property (strong, nonatomic) Dashboard *dashboard;

@end