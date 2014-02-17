//
//  NSDictionary+FFNull.m
//  FFiPhoneApp
//
//  Created by lee on 7/23/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "NSDictionary+FFNull.h"

@implementation NSDictionary (FFNull)

- (id)ff_objectForKey:(id)key
{
    id object = [self objectForKey:key];
    
    if (object == [NSNull null]) {
        return nil;
    }

    return object;
}

@end
