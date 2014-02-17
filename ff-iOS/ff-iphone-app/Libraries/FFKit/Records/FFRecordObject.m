//
//  FFRecordObject.m
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordObject.h"
#import "FFAPIClient.h"
#import "NSDictionary+FFNull.h"

NSString * const FFRecordDateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";

// Shared APIClient
static FFAPIClient *sharedAPIClient = nil;

@implementation FFRecordObject

+ (BOOL)isSuccess:(NSDictionary *)responseJSON
{
    return [[responseJSON ff_objectForKey:@"result"] isEqualToString:@"success"];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        [FFRecordObject sharedAPIClient];
    }

    return self;
}

+ (FFAPIClient *)sharedAPIClient
{
    if (!sharedAPIClient) {
        [NSException raise:@"Invalid 'sharedAPIClient' object" format:@"Uninitialized 'sharedAPIClient' variable"];
    }

    return sharedAPIClient;
}

+ (void)setSharedAPIClient:(FFAPIClient *)client
{
    sharedAPIClient = client;
}

- (BOOL)isSuccess:(NSDictionary *)responseJSON
{
    return [FFRecordObject isSuccess:responseJSON];
}

@end
