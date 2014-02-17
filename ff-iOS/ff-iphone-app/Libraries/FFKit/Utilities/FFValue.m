//
//  FFValue.m
//  FFiPhoneApp
//
//  Created by lee on 7/27/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFValue.h"

@implementation FFValue

+ (id)valueWithObject:(id)object
{
    if (object) {
        NSDictionary *temp = [NSDictionary dictionaryWithObjectsAndKeys:object, @"object", nil];
        return [temp valueForKey:@"object"];
    }
    
    return [NSNull null];
}

+ (id)valueWithUnsignedInteger:(NSUInteger)value
{
    return [NSNumber numberWithUnsignedInteger:value];
}

+ (id)valueWithInteger:(NSInteger)value
{
    return [NSNumber numberWithInteger:value];
}

@end
