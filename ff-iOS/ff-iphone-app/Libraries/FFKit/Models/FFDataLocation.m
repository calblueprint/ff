//
//  FFDataLocation.m
//  FFiPhoneApp
//
//  Created by lee on 7/22/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFDataLocation.h"

@implementation FFDataLocation

- (NSString *)formattedAddress
{
    NSMutableString *mutableFormattedAddress = [NSMutableString string];
    
    if (self.streetAddressOne) {
        [mutableFormattedAddress appendString:[NSString stringWithFormat:@", %@", self.streetAddressOne]];
    }
    if (self.streetAddressTwo) {
        [mutableFormattedAddress appendString:[NSString stringWithFormat:@", %@", self.streetAddressTwo]];
    }
    if (self.city) {
        [mutableFormattedAddress appendString:[NSString stringWithFormat:@", %@", self.city]];
    }
    if (self.state) {
        [mutableFormattedAddress appendString:[NSString stringWithFormat:@", %@", self.state]];
    }
    if (self.zipCode) {
        [mutableFormattedAddress appendString:[NSString stringWithFormat:@" %@", self.zipCode]];
    }
    
    NSString *formattedAddress = [mutableFormattedAddress stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
    
    return formattedAddress;
}

@end
