//
//  FFRecordDelivery.h
//  FFiPhoneApp
//
//  Created by lee on 8/11/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRecordObject.h"

@class FFDataUser, FFDataDelivery;

@interface FFRecordDelivery : FFRecordObject

@property (nonatomic) NSUInteger recordID;
@property (nonatomic) NSUInteger donationID;
@property (nonatomic, strong) FFDataUser *donee;
@property (nonatomic, strong) FFDataUser *recoveryOrg;

+ (void)loadDataToModelObject:(FFDataDelivery *)modelObject fromJSONObject:(NSDictionary *)jsonObject;
+ (instancetype)initWithModelObject:(FFDataDelivery *)modelObject;
- (void)loadDataFromModelObject:(FFDataDelivery *)modelObject;

@end
