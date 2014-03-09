//
//  POSDPostDonationViewController.h
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PostDonationBaseViewController.h"

@class FFDataDonation;

@class FFDataDonation, FFImageStore, AppDelegate, POSDChooseLocationViewController, POSDChooseAmountViewController, POSDChooseTimeViewController, POSDTitleViewController;

@interface POSDPostDonationViewController : PostDonationBaseViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPageViewControllerDataSource>

@end