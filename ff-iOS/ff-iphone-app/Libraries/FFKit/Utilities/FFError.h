//
//  FFError.h
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFError : NSObject

@property (nonatomic, copy) NSString *errorType;
@property (nonatomic, copy) NSString *errorDescription;

+ (instancetype)initWithErrorType:(NSString *)errorType andDescription:(NSString *)errorDescription;

@end
