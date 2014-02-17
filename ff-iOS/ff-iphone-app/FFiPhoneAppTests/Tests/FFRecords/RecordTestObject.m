//
//  RecordTestObject.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "RecordTestObject.h"
#import "Tests.h"

@implementation RecordTestObject

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    FFAPIClient *APIClient = [FFAPIClient new];
    [APIClient setAPIBaseURL:APIEndpointURL];
    [FFRecordObject setSharedAPIClient:APIClient];
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
