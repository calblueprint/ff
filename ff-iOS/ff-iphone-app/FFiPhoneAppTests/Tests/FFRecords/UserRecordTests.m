//
//  UserRecordTests.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "UserRecordTests.h"
#import "Tests.h"

@implementation UserRecordTests

//
// Create a new semaphore before each tests, and invoke [super wait:&semaphore] between tests.
// When the asynchronous test code finishes, invoke dispatch_semaphore_signal(semaphore)
//

- (void)test_Create_Retrieve_Update
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];

    //
    // Test Create
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    long currentTimeInterval = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    NSString *email = [NSString stringWithFormat:@"test_%ld_%d@ff.org", currentTimeInterval, arc4random_uniform(currentTimeInterval)];
    NSString *primary_phone = [NSString stringWithFormat:@"+1%ld", currentTimeInterval+arc4random_uniform(100000)];
    
    FFDataUser *user = [FFDataUser new];
    [user setEmail:email];
    [user setPassword:@"password"];
    [user setFullName:@"test_user"];
    [user setMobilePhoneNumber:primary_phone];
    [user setOrganization:@"test_organization"];
    [user setRole:@"donor"];
    [user setVehicleType:3];

    [[FFRecordUser initWithModelObject:user] createWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([user.email isEqualToString:email],
                     @"Invalid 'email' value");
        STAssertTrue([user.fullName isEqualToString:@"test_user"],
                     @"Invalid 'fullName' value");
        STAssertTrue([user.mobilePhoneNumber isEqualToString:primary_phone],
                     @"Invalid 'mobilePhoneNumber' value");
        STAssertTrue([user.organization isEqualToString:@"test_organization"],
                     @"Invalid 'organization' value");
        STAssertTrue([user.role isEqualToString:@"donor"],
                     @"Invalid 'role' value");
        STAssertTrue(user.vehicleType == 3,
                     @"Invalid 'vehicleType' value");
        
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
    
    [[FFRecordAuthToken initWithEmail:email andPassword:@"password"] createWithCompletion:^(BOOL isSuccess, NSString *authToken, FFError *error) {
        
        self.authToken = authToken;
        
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    [[FFRecordObject sharedAPIClient] setAPIAuthToken:self.authToken];
    
    //
    // Test Retrieve
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [FFRecordUser retrieveWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([user.email isEqualToString:email],
                     @"Invalid 'email' value");
        STAssertTrue([user.fullName isEqualToString:@"test_user"],
                     @"Invalid 'fullName' value");
        STAssertTrue([user.mobilePhoneNumber isEqualToString:primary_phone],
                     @"Invalid 'mobilePhoneNumber' value");
        STAssertTrue([user.organization isEqualToString:@"test_organization"],
                     @"Invalid 'organization' value");
        STAssertTrue([user.role isEqualToString:@"donor"],
                     @"Invalid 'role' value");
        STAssertTrue(user.vehicleType == 3,
                     @"Invalid 'vehicleType' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test Update
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    currentTimeInterval = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    email = [NSString stringWithFormat:@"test_%ld_%d@ff.org", currentTimeInterval, arc4random_uniform(currentTimeInterval)];
    primary_phone = [NSString stringWithFormat:@"+1%ld", currentTimeInterval+arc4random_uniform(100000)];
    
    user = [FFDataUser new];
    [user setEmail:email];
    [user setPassword:@"password_updated"];
    [user setFullName:@"test_user_updated"];
    [user setMobilePhoneNumber:primary_phone];
    [user setOrganization:@"test_organization_updated"];
    [user setVehicleType:2];

    [[FFRecordUser initWithModelObject:user] updateWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([user.email isEqualToString:email],
                     @"Invalid 'email' value");
        STAssertTrue([user.fullName isEqualToString:@"test_user_updated"],
                     @"Invalid 'fullName' value");
        STAssertTrue([user.mobilePhoneNumber isEqualToString:primary_phone],
                     @"Invalid 'mobilePhoneNumber' value");
        STAssertTrue([user.organization isEqualToString:@"test_organization_updated"],
                     @"Invalid 'organization' value");
        STAssertTrue(user.vehicleType == 2,
                     @"Invalid 'vehicleType' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    // Confirm the password is changed
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [[FFRecordAuthToken initWithEmail:email andPassword:@"password_updated"] createWithCompletion:^(BOOL isSuccess, NSString *authToken, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        
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
    // Create an user
    //
    semaphore = dispatch_semaphore_create(0);

    long currentTimeInterval = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    NSString *email = [NSString stringWithFormat:@"test_%ld_%d@ff.org", currentTimeInterval, arc4random_uniform(currentTimeInterval)];

    FFDataUser *user = [FFDataUser new];
    [user setEmail:email];
    [user setPassword:@"password"];
    
    [[FFRecordUser initWithModelObject:user] createWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];

    //
    // Test Create AuthToken
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [[FFRecordAuthToken initWithEmail:email andPassword:@"password"] createWithCompletion:^(BOOL isSuccess, NSString *authToken, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue(authToken != nil,
                     @"Invalid 'authToken' value");
        
        [self setAuthToken:authToken];
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");

    //
    // Test Delete AuthToken
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [[FFRecordAuthToken initWithAuthToken:self.authToken] deleteWithCompletion:^(BOOL isSuccess, FFError *error) {
       
        STAssertTrue(isSuccess,
                     @"API request failed");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    // Confirm the auth token is deleted
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [[FFRecordAuthToken initWithAuthToken:self.authToken] deleteWithCompletion:^(BOOL isSuccess, FFError *error) {
        
        STAssertTrue(isSuccess == NO,
                     @"API request failed");
        STAssertTrue([[error errorDescription] isEqualToString:@"Your authentication token is invalid"],
                     @"Invalid 'errorMessage' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
}

@end
