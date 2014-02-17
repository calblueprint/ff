//
//  UITextField+FFStyles.m
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "UITextField+FFStyles.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextField (FFStyles)

- (void)ff_styleWithRoundCorners
{    
    [self.layer setCornerRadius:8.0f];
}

- (void)ff_styleWithPadding
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)ff_styleWithShadow
{
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.5f];
    [self.layer setShadowRadius:1.0f];
    [self.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self setClipsToBounds:NO];
    
}

- (void)ff_styleWithBorderColor:(UIColor *)color
{
    [self.layer setBorderColor:[color CGColor]];
}

- (void)ff_styleWithPlaceholderColor:(UIColor *)color
{
    [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.placeholder
                                                                   attributes:@{NSForegroundColorAttributeName: color}]];
}

- (void)ff_styleWithBorderWidth:(float)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

@end
