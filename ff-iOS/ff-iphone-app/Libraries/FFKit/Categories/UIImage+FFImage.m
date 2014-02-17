//
//  UIImage+FFImage.m
//  FFiPhoneApp
//
//  Created by lee on 8/1/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "UIImage+FFImage.h"

@implementation UIImage (FFImage)

+ (UIImage *)ff_imageNamed:(NSString *)imageFileName
{
    UIImage *image = nil;
    
    if ([UIScreen mainScreen].bounds.size.height == 568.0f && [UIScreen mainScreen].scale == 2.f && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-568h@2x.%@", [imageFileName stringByDeletingPathExtension], [imageFileName pathExtension]]];
        if (image == nil) {
            image = [UIImage imageNamed:imageFileName];
        }
    }
    else {
        image = [UIImage imageNamed:imageFileName];
    }

    return image;
}

@end
