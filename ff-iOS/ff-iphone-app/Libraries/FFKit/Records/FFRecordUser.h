//
//  FFRecordUser.h
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRecordObject.h"

@class FFDataUser, FFError;

@interface FFRecordUser : FFRecordObject

@property (nonatomic) NSUInteger recordID;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *mobilePhoneNumber;
@property (nonatomic, copy) NSString *organization;
@property (nonatomic, copy) NSString *role;
@property (nonatomic) NSInteger vehicleType;
@property (nonatomic) NSUInteger defaultLocationID;

+ (void)loadDataToModelObject:(FFDataUser *)modelObject fromJSONObject:(NSDictionary *)jsonObject;
+ (instancetype)initWithModelObject:(FFDataUser *)modelObject;
+ (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, FFDataUser *user, FFError *error))completion;
- (void)loadDataFromModelObject:(FFDataUser *)modelObject;
- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataUser *user, FFError *error))completion;
- (void)updateWithCompletion:(void (^)(BOOL isSuccess, FFDataUser *user, FFError *error))completion;
- (void)sendResetPasswordInstructionsWithCompletion:(void (^)(BOOL isSuccess, FFError *error))completion;

@end
