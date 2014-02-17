//
//  FFRecordAuthToken.h
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRecordObject.h"

@class FFError;

@interface FFRecordAuthToken : FFRecordObject

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *authToken;

+ (instancetype)initWithEmail:(NSString *)email andPassword:(NSString *)password;
+ (instancetype)initWithAuthToken:(NSString *)authToken;
- (void)createWithCompletion:(void (^)(BOOL isSuccess, NSString *authToken, FFError *error))completion;
- (void)deleteWithCompletion:(void (^)(BOOL isSuccess, FFError *error))completion;

@end
