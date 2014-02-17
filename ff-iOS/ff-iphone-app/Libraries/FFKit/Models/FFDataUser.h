//
//  FFDataUser.h
//  FFiPhoneApp
//
//  Created by lee on 7/22/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFDataObject.h"

@class FFDataLocation;

@interface FFDataUser : FFDataObject

@property (nonatomic) NSUInteger userID;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *mobilePhoneNumber;
@property (nonatomic, copy) NSString *organization;
@property (nonatomic, copy) NSString *role;
@property (nonatomic) NSInteger vehicleType;
@property (nonatomic, strong) FFDataLocation *defaultLocation;

@end
