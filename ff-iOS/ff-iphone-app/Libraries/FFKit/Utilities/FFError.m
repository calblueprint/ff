//
//  FFError.m
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFError.h"

@implementation FFError

+ (instancetype)initWithErrorType:(NSString *)errorType andDescription:(NSString *)errorDescription
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object setErrorType:errorType];
        [object setErrorDescription:errorDescription];
    }

    return object;
}

@end
