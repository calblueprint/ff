//
//  FFRecordMealPhoto.h
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRecordObject.h"
#import "FFDataImage.h"
#import "FFDataDonation.h"
#import "FFRecordImage.h"

@class FFError;

@interface FFRecordMealPhoto : FFRecordObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) FFDataDonation *donation;

+ (instancetype)initWithImage:(UIImage *)imageObject andDonation:(FFDataDonation *)donationObject;
+ (instancetype)initWithDonation:(FFDataDonation *)donationObject;
- (void)loadDataFromImage:(UIImage *)imageObject andDonation:(FFDataDonation *)donationObject;
- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataImage *image, FFError *error))completion;
- (void)deleteWithCompletion:(void (^)(BOOL isSuccess, FFError *error))completion;

@end
