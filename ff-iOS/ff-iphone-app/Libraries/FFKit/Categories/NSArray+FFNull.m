//
//  NSArray+FFNull.m
//  FFiPhoneApp
//
//  Created by lee on 7/26/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "NSArray+FFNull.h"

@implementation NSArray (FFNull)

- (id)ff_objectAtIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }

    return [self objectAtIndex:index];
}

@end
