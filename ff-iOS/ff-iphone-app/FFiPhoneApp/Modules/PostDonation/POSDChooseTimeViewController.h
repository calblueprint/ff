//
//  POSDChooseTimeViewController.h
//  FFiPhoneApp
//
//  Created by lee on 8/4/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PostDonationBaseViewController.h"

@class FFDataDonation;

@interface POSDChooseTimeViewController : PostDonationBaseViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) FFDataDonation *donation;

@end
