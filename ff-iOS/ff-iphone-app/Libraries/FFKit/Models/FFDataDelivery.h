//
//  FFDataDelivery.h
//  FFiPhoneApp
//
//  Created by lee on 8/11/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFDataObject.h"

@class FFDataUser;

@interface FFDataDelivery : FFDataObject

@property (nonatomic) NSUInteger deliveryID;
@property (nonatomic) NSUInteger donationID;
@property (nonatomic, strong) FFDataUser *donee;
@property (nonatomic, strong) FFDataUser *recoveryOrg;
@property (nonatomic, strong) NSDate *pickupTime;

@end
