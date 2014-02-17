//
//  FFUI.h
//  FFiPhoneApp
//
//  Created by lee on 7/30/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFUI : NSObject

+ (void)scrollUpView:(UIView *)view withDirectionUp:(BOOL)isUp distance:(int)movementDistance;
+ (void)showPopupMessageWithTitle:(NSString *)title message:(NSString *)message;
+ (UIToolbar *)keyboardToolbarWithDoneButtonOnView:(UIView *)view buttonActionTarget:(id)buttonActionTarget buttonAction:(SEL)buttonAction;
+ (void)showLoadingViewOnView:(UIView *)view visible:(bool)visible;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

@end
