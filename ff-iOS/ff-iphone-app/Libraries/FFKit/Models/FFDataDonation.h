//
//  FFDataDonation.h
//  FFiPhoneApp
//
//  Created by lee on 7/22/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFDataObject.h"

@class FFDataImage, FFDataLocation, FFDataUser, FFDataDelivery;

@interface FFDataDonation : FFDataObject

@property (nonatomic) NSUInteger donationID;
@property (nonatomic, copy) NSString *donationTitle;
@property (nonatomic, copy) NSString *donationDescription;
@property (nonatomic) NSUInteger totalLBS;
@property (nonatomic, strong) FFDataImage *mealPhoto;
@property (nonatomic, strong) NSDate *availableStart;
@property (nonatomic, strong) NSDate *availableEnd;
@property (nonatomic) NSInteger statusCode;
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic) NSInteger vehicleType;
@property (nonatomic, strong) FFDataLocation *location;
@property (nonatomic, strong) FFDataUser *donee;
@property (nonatomic, strong) FFDataUser *donor;
@property (nonatomic, strong) FFDataDelivery *delivery;

@end
