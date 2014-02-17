//
//  FFUI.m
//  FFiPhoneApp
//
//  Created by lee on 7/30/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFUI.h"
#import <QuartzCore/QuartzCore.h>

@implementation FFUI

//
// Method to handle issue of keyboard covering up UITextFields
//
+ (void)scrollUpView:(UIView *)view withDirectionUp:(BOOL)isUp distance:(int)movementDistance
{    
    float movementDuration = 0.3f; // tweak as needed
    int movement = (isUp ? -movementDistance : movementDistance);

    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
}

+ (void)showPopupMessageWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alert show];
}

+ (UIToolbar *)keyboardToolbarWithDoneButtonOnView:(UIView *)view buttonActionTarget:(id)buttonActionTarget buttonAction:(SEL)buttonAction
{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 44)];
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                             style:UIBarButtonItemStyleDone
                                                            target:buttonActionTarget
                                                            action:buttonAction];

    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, done, nil]];

    return keyboardToolbar;
}

+ (void)showLoadingViewOnView:(UIView *)view visible:(bool)visible
{
    __weak UIActivityIndicatorView *existingIndicator = [[view subviews] lastObject];

    if (existingIndicator.tag == -NSIntegerMax) {
        if (!visible) {
            [existingIndicator removeFromSuperview];
            [view setUserInteractionEnabled:YES];
        }
    }
    else
    {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGRect b = view.bounds;
        // Center indicator in the view
        indicator.frame = CGRectMake((b.size.width - 60) / 2, (b.size.height - 60) / 2, 60, 60);
        indicator.layer.cornerRadius = 5;
        indicator.hidesWhenStopped = YES;
        indicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        indicator.tag = -NSIntegerMax;
        [indicator startAnimating];
        [view addSubview:indicator];
        [view setUserInteractionEnabled:NO];
    }
}

// Create UIColor from hex string
// Source: http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

// Return the topmost view controller
// Source: http://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}

@end
