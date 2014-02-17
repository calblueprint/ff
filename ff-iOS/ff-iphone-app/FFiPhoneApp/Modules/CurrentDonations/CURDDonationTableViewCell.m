//
//  CURDDonationTableViewCell.m
//  FFiPhoneApp
//
//  Created by lee on 8/10/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "CURDDonationTableViewCell.h"

@implementation CURDDonationTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self.activityIndicatorView setHidesWhenStopped:YES];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccessoryTypeAsDisclosureIndicator
{
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self.activityIndicatorView stopAnimating];
}

- (void)setAccessoryTypeAsActivityIndicator
{
    [self setAccessoryType:UITableViewCellAccessoryNone];
    [self.activityIndicatorView startAnimating];
}

- (void)setAccessoryTypeAsNone
{
    [self setAccessoryType:UITableViewCellAccessoryNone];
    [self.activityIndicatorView stopAnimating];
}

@end
