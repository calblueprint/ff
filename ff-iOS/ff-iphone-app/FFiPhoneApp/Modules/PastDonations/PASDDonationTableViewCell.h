//
//  PASDDonationTableViewCell.h
//  FFiPhoneApp
//
//  Created by lee on 8/12/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASDDonationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelDonationTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalLBSAndAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelStatusText;
@property (strong, nonatomic) IBOutlet UILabel *labelAvailableDate;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewMealPhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UIView *viewCellBackground;

@end
