//
//  UserAPITests.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "UserAPITests.h"
#import "Tests.h"

@implementation UserAPITests

//
// Create a new semaphore before each tests, and invoke [super wait:&semaphore] between tests.
// When the asynchronous test code finishes, invoke dispatch_semaphore_signal(semaphore)
//

- (void)test_CreateUser_GetUser_UpdateUser
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];

    //
    // Test CreateUser
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    long currentTimeInterval = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    NSString *email = [NSString stringWithFormat:@"test_%ld_%d@ff.org", currentTimeInterval, arc4random_uniform(currentTimeInterval)];
    NSString *primary_phone = [NSString stringWithFormat:@"+1%ld", currentTimeInterval+arc4random_uniform(100000)];
    NSDictionary *params = @{
            @"email": email,
            @"password": @"password",
            @"full_name": @"test_user",
            @"primary_phone": primary_phone,
            @"organization": @"test_organization",
            @"role": @"donor",
            @"vehicle": @3,
            @"default_location_id": @10
    };

    [self.APIClient createUserWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *user = [response ff_objectForKey:@"user"];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[user ff_objectForKey:@"email"] isEqualToString:email],
                     @"Invalid 'email' value");
        STAssertTrue([[user ff_objectForKey:@"full_name"] isEqualToString:@"test_user"],
                     @"Invalid 'full_name' value");
        STAssertTrue([[user ff_objectForKey:@"primary_phone"] isEqualToString:primary_phone],
                     @"Invalid 'primary_phone' value");
        STAssertTrue([[user ff_objectForKey:@"organization"] isEqualToString:@"test_organization"],
                     @"Invalid 'organization' value");
        STAssertTrue([[user ff_objectForKey:@"roles_mask"] integerValue] == 1,
                     @"Invalid 'roles_mask' value");
        STAssertTrue([[user ff_objectForKey:@"vehicle"] integerValue] == 3,
                     @"Invalid 'vehicle' value");
        STAssertTrue([[user ff_objectForKey:@"default_location_id"] integerValue] == 10,
                    @"Invalid 'default_location_id' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Generate an auth token
    //
    semaphore = dispatch_semaphore_create(0);
    
    [self.APIClient generateAuthTokenWithParameters:@{@"email": email, @"password": @"password"} completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        self.authToken = [response ff_objectForKey:@"auth_token"];
        
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    
    //
    // Test GetUser
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient setAPIAuthToken:self.authToken];
    [self.APIClient getUserWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *user = [response ff_objectForKey:@"user"];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[user ff_objectForKey:@"email"] isEqualToString:email],
                     @"Invalid 'email' value");
        STAssertTrue([[user ff_objectForKey:@"full_name"] isEqualToString:@"test_user"],
                     @"Invalid 'full_name' value");
        STAssertTrue([[user ff_objectForKey:@"primary_phone"] isEqualToString:primary_phone],
                     @"Invalid 'primary_phone' value");
        STAssertTrue([[user ff_objectForKey:@"organization"] isEqualToString:@"test_organization"],
                     @"Invalid 'organization' value");
        STAssertTrue([[user ff_objectForKey:@"roles_mask"] integerValue] == 1,
                     @"Invalid 'roles_mask' value");
        STAssertTrue([[user ff_objectForKey:@"vehicle"] integerValue] == 3,
                     @"Invalid 'vehicle' value");
        STAssertTrue([[user ff_objectForKey:@"default_location_id"] integerValue] == 10,
                     @"Invalid 'default_location_id' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test UpdateUser
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    currentTimeInterval = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    email = [NSString stringWithFormat:@"test_%ld_%d@ff.org", currentTimeInterval, arc4random_uniform(currentTimeInterval)];
    primary_phone = [NSString stringWithFormat:@"+1%ld", currentTimeInterval+arc4random_uniform(100000)];
    params = @{
           @"email": email,
           @"password": @"password_updated",
           @"full_name": @"test_user_updated",
           @"primary_phone": primary_phone,
           @"organization": @"test_organization_updated",
           @"vehicle": @2,
           @"default_location_id": @20
    };

    [self.APIClient setAPIAuthToken:self.authToken];
    [self.APIClient updateUserWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *user = [response ff_objectForKey:@"user"];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[user ff_objectForKey:@"email"] isEqualToString:email],
                     @"Invalid 'email' value");
        STAssertTrue([[user ff_objectForKey:@"full_name"] isEqualToString:@"test_user_updated"],
                     @"Invalid 'full_name' value");
        STAssertTrue([[user ff_objectForKey:@"primary_phone"] isEqualToString:primary_phone],
                     @"Invalid 'primary_phone' value");
        STAssertTrue([[user ff_objectForKey:@"organization"] isEqualToString:@"test_organization_updated"],
                     @"Invalid 'organization' value");
        STAssertTrue([[user ff_objectForKey:@"vehicle"] integerValue] == 2,
                     @"Invalid 'vehicle' value");
        STAssertTrue([[user ff_objectForKey:@"default_location_id"] integerValue] == 20,
                     @"Invalid 'default_location_id' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    // Confirm the password is changed
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient generateAuthTokenWithParameters:@{@"email": email, @"password": @"password_updated"} completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
}

- (void)test_GenerateAuthToken_DestroyAuthToken
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];

    //
    // Create a user
    //
    semaphore = dispatch_semaphore_create(0);
    
    long currentTimeInterval = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    NSString *email = [NSString stringWithFormat:@"test_%ld_%d@ff.org", currentTimeInterval, arc4random_uniform(currentTimeInterval)];
    NSString *password = @"password";
    NSDictionary *params = @{
            @"email": email,
            @"password": password
    };
    
    [self.APIClient createUserWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];

    //
    // Test GenerateAuthToken
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient generateAuthTokenWithParameters:@{@"email": email, @"password": password} completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([response ff_objectForKey:@"auth_token"] != nil,
                     @"Invalid 'auth_token' value");

        NSString *authToken = [response ff_objectForKey:@"auth_token"];
        [self setAuthToken:authToken];

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");

    //
    // Test destroyAuthToken
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient destroyAuthTokenWithParameters:@{@"auth_token": self.authToken} completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
}

@end
