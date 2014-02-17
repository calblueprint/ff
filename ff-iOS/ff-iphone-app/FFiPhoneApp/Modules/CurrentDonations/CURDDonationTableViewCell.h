//
//  CURDDonationTableViewCell.h
//  FFiPhoneApp
//
//  Created by lee on 8/10/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CURDDonationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelDonationTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalLBS;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusText;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewMealPhoto;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (void)setAccessoryTypeAsDisclosureIndicator;
- (void)setAccessoryTypeAsActivityIndicator;
- (void)setAccessoryTypeAsNone;

@end
