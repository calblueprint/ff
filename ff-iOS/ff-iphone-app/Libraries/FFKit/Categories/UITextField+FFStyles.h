//
//  UITextField+FFStyles.h
//  FFiPhoneApp
//
//  Created by lee on 7/29/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (FFStyles)

- (void)ff_styleWithRoundCorners;
- (void)ff_styleWithPadding;
- (void)ff_styleWithShadow;
- (void)ff_styleWithPlaceholderColor:(UIColor *)color;
- (void)ff_styleWithBorderColor:(UIColor *)color;
- (void)ff_styleWithBorderWidth:(float)borderWidth;

@end
