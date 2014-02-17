//
//  FFRecordObject.h
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const FFRecordDateFormat;

@class FFAPIClient;

@interface FFRecordObject : NSObject

+ (BOOL)isSuccess:(NSDictionary *)responseJSON;
+ (FFAPIClient *)sharedAPIClient;
+ (void)setSharedAPIClient:(FFAPIClient *)client;
- (BOOL)isSuccess:(NSDictionary *)responseJSON;

@end
