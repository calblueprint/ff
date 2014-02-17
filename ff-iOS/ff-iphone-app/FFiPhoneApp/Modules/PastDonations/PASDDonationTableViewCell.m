//
//  PASDDonationTableViewCell.m
//  FFiPhoneApp
//
//  Created by lee on 8/12/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PASDDonationTableViewCell.h"

#import "FFKit.h"

@implementation PASDDonationTableViewCell

- (void)drawRect:(CGRect)rect
{
    [self.viewCellBackground ff_styleWithShadow];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
