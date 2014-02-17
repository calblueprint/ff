//
//  UIView+FFStyles.m
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "UIView+FFStyles.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (FFStyles)

- (void)ff_styleWithRoundCorners
{
    [self.layer setCornerRadius:10.0f];
}

- (void)ff_styleWithShadow
{
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.2f];
    [self.layer setShadowRadius:1.0f];
    [self.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    
    // Improve performance when styling elements in UITableViewCell
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale:[UIScreen mainScreen].scale];
}

@end
