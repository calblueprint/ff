//
//  APITestObject.h
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class FFAPIClient;

@interface APITestObject : SenTestCase

@property (nonatomic, strong) FFAPIClient *APIClient;
@property (nonatomic, copy) NSString *authToken;

- (void)wait:(dispatch_semaphore_t *)semaphore;

@end
