//
//  FFRecordDonation.h
//  FFiPhoneApp
//
//  Created by lee on 7/23/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRecordObject.h"

@class FFDataDonation, FFError;

@interface FFRecordDonation : FFRecordObject

@property (nonatomic) NSUInteger recordID;
@property (nonatomic, copy) NSString *donationTitle;
@property (nonatomic, copy) NSString *donationDescription;
@property (nonatomic,) NSUInteger totalLBS;
@property (nonatomic, copy) NSString *availableStartDate;
@property (nonatomic, copy) NSString *availableStartTime;
@property (nonatomic, copy) NSString *availableEndDate;
@property (nonatomic, copy) NSString *availableEndTime;
@property (nonatomic) NSInteger vehicleType;
@property (nonatomic) NSInteger locationID;

+ (void)loadDataToModelObject:(FFDataDonation *)modelObject fromJSONObject:(NSDictionary *)jsonObject;
+ (instancetype)initWithModelObject:(FFDataDonation *)modelObject;
+ (instancetype)initWithRecordID:(NSUInteger)recordID;
+ (void)retrieveCurrentDonationsWithCompletion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion;
+ (void)retrieveCurrentDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion;
+ (void)retrievePastDonationsWithCompletion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion;
+ (void)retrievePastDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion;
- (void)loadDataFromModelObject:(FFDataDonation *)modelObject;
- (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, FFDataDonation *donation, FFError *error))completion;
- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataDonation *donation, FFError *error))completion;
- (void)updateWithCompletion:(void (^)(BOOL isSuccess, FFDataDonation *donation, FFError *error))completion;
- (void)deleteWithCompletion:(void (^)(BOOL isSuccess, FFError *error))completion;

@end
