//
//  FFDataLocation.h
//  FFiPhoneApp
//
//  Created by lee on 7/22/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFDataObject.h"

@interface FFDataLocation : FFDataObject

@property (nonatomic) NSUInteger locationID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *streetAddressOne;
@property (nonatomic, copy) NSString *streetAddressTwo;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipCode;

- (NSString *)formattedAddress;

@end
