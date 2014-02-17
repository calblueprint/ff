//
//  APITestObject.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "APITestObject.h"
#import "Tests.h"

@implementation APITestObject

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.

    self.APIClient = [FFAPIClient new];
    [self.APIClient setAPIBaseURL:APIEndpointURL];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)wait:(dispatch_semaphore_t *)semaphore
{
    while (dispatch_semaphore_wait(*semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
