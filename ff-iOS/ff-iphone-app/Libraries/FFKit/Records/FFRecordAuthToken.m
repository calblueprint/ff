//
//  FFRecordAuthToken.m
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordAuthToken.h"

#import "NSDictionary+FFNull.h"
#import "FFError.h"
#import "FFValue.h"
#import "FFAPIClient.h"

@implementation FFRecordAuthToken

+ (instancetype)initWithEmail:(NSString *)email andPassword:(NSString *)password
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object setEmail:email];
        [object setPassword:password];
    }
    
    return object;
}

+ (instancetype)initWithAuthToken:(NSString *)authToken
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object setAuthToken:authToken];
    }

    return object;
}

- (void)createWithCompletion:(void (^)(BOOL isSuccess, NSString *authToken, FFError *error))completion
{
    //
    // Generate an auth token
    //
    NSDictionary *params = @{
            @"email": [FFValue valueWithObject:self.email],
            @"password": [FFValue valueWithObject:self.password]
    };

    [[FFRecordObject sharedAPIClient] generateAuthTokenWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            completion(YES, [response ff_objectForKey:@"auth_token"], nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)deleteWithCompletion:(void (^)(BOOL isSuccess, FFError *error))completion
{
    //
    // Destroy auth token
    //
    NSDictionary *params = @{
            @"auth_token": [FFValue valueWithObject:self.authToken]
    };
    
    [[FFRecordObject sharedAPIClient] destroyAuthTokenWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            completion(YES, nil);
        }
        else {
            completion(NO, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                       andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

@end
