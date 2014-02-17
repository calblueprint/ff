//
//  FFValue.h
//  FFiPhoneApp
//
//  Created by lee on 7/27/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFValue : NSObject

+ (id)valueWithObject:(id)object;
+ (id)valueWithUnsignedInteger:(NSUInteger)value;
+ (id)valueWithInteger:(NSInteger)value;

@end
