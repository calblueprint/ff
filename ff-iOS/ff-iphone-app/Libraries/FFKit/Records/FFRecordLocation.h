//
//  FFRecordLocation.h
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRecordObject.h"

@class FFDataLocation, FFError;

@interface FFRecordLocation : FFRecordObject

@property (nonatomic) NSUInteger recordID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *streetAddressOne;
@property (nonatomic, copy) NSString *streetAddressTwo;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipCode;

+ (void)loadDataToModelObject:(FFDataLocation *)modelObject fromJSONObject:(NSDictionary *)jsonObject;
+ (instancetype)initWithModelObject:(FFDataLocation *)modelObject;
+ (instancetype)initWithRecordID:(NSUInteger)recordID;
+ (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, NSArray *locations, FFError *error))completion;
- (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, FFDataLocation *location, FFError *error))completion;
- (void)loadDataFromModelObject:(FFDataLocation *)modelObject;
- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataLocation *location, FFError *error))completion;
- (void)updateWithCompletion:(void (^)(BOOL isSuccess, FFDataLocation *location, FFError *error))completion;
- (void)deleteWithCompletion:(void (^)(BOOL isSuccess, FFError *error))completion;

@end
