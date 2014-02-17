//
//  RecordTestObject.h
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface RecordTestObject : SenTestCase

@property (nonatomic, copy) NSString *authToken;

- (void)wait:(dispatch_semaphore_t *)semaphore;

@end
