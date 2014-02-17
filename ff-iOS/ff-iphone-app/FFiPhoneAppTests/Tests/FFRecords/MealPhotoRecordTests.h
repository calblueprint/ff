//
//  MealPhotoRecordTests.h
//  FFiPhoneApp
//
//  Created by lee on 7/26/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RecordTestObject.h"

@class FFDataDonation, FFDataLocation;

@interface MealPhotoRecordTests : RecordTestObject

@property (nonatomic, strong) FFDataDonation *donation;
@property (nonatomic, strong) FFDataLocation *location;

@end
