//
//  LocationRecordTests.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "LocationRecordTests.h"
#import "Tests.h"

@implementation LocationRecordTests

//
// Create a new semaphore before each tests, and invoke [super wait:&semaphore] between tests.
// When the asynchronous test code finishes, invoke dispatch_semaphore_signal(semaphore)
//

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    dispatch_semaphore_t semaphore = nil;
    
    //
    // Create an user
    //
    semaphore = dispatch_semaphore_create(0);
    
    long currentTimeInterval = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    NSString *email = [NSString stringWithFormat:@"test_%ld_%d@ff.org", currentTimeInterval, arc4random_uniform(currentTimeInterval)];
    NSString *password = @"password";
    
    FFDataUser *user = [FFDataUser new];
    [user setEmail:email];
    [user setPassword:password];
    [user setFullName:@"test_user"];
    [user setRole:@"donor"];

    [[FFRecordUser initWithModelObject:user] createWithCompletion:^(BOOL isSuccess, FFDataUser *user, FFError *error) {
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    
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
}

- (void)test_Create_Retrieve_Update_Delete
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];

    //
    // Test Create
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];    
    
    FFDataLocation *location = [FFDataLocation new];
    [location setStreetAddressOne:@"123 Market Street"];
    [location setStreetAddressTwo:@"Apt B"];
    [location setCity:@"San Francisco"];
    [location setState:@"CA"];
    [location setZipCode:@"91234"];
    [location setName:@"test_location"];
    
    [[FFRecordLocation initWithModelObject:location] createWithCompletion:^(BOOL isSuccess, FFDataLocation *location, FFError *error) {
                
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([location.streetAddressOne isEqualToString:@"123 Market Street"],
                     @"Invalid 'streetAddressOne' value");
        STAssertTrue([location.streetAddressTwo isEqualToString:@"Apt B"],
                     @"Invalid 'streetAddressTwo' value");
        STAssertTrue([location.city isEqualToString:@"San Francisco"],
                     @"Invalid 'city' value");
        STAssertTrue([location.state isEqualToString:@"CA"],
                     @"Invalid 'state' value");
        STAssertTrue([location.zipCode isEqualToString:@"91234"],
                     @"Invalid 'zipCode' value");
        STAssertTrue([location.name isEqualToString:@"test_location"],
                     @"Invalid 'name' value");
        
        [self setLocation:location];
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test Retrieve
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [FFRecordLocation retrieveWithCompletion:^(BOOL isSuccess, NSArray *locations, FFError *error) {
        
        FFDataLocation *location = [locations ff_objectAtIndex:0];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([location.streetAddressOne isEqualToString:@"123 Market Street"],
                     @"Invalid 'streetAddressOne' value");
        STAssertTrue([location.streetAddressTwo isEqualToString:@"Apt B"],
                     @"Invalid 'streetAddressTwo' value");
        STAssertTrue([location.city isEqualToString:@"San Francisco"],
                     @"Invalid 'city' value");
        STAssertTrue([location.state isEqualToString:@"CA"],
                     @"Invalid 'state' value");
        STAssertTrue([location.zipCode isEqualToString:@"91234"],
                     @"Invalid 'zipCode' value");
        STAssertTrue([location.name isEqualToString:@"test_location"],
                     @"Invalid 'name' value");
        
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

    location = [FFDataLocation new];
    [location setLocationID:self.location.locationID];
    [location setStreetAddressOne:@"123 Norton Street"];
    [location setStreetAddressTwo:@"Apt C"];
    [location setCity:@"San Jose"];
    [location setState:@"TX"];
    [location setZipCode:@"94321"];
    [location setName:@"test_location_updated"];
    
    [[FFRecordLocation initWithModelObject:location] updateWithCompletion:^(BOOL isSuccess, FFDataLocation *location, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([location.streetAddressOne isEqualToString:@"123 Norton Street"],
                     @"Invalid 'streetAddressOne' value");
        STAssertTrue([location.streetAddressTwo isEqualToString:@"Apt C"],
                     @"Invalid 'streetAddressTwo' value");
        STAssertTrue([location.city isEqualToString:@"San Jose"],
                     @"Invalid 'city' value");
        STAssertTrue([location.state isEqualToString:@"TX"],
                     @"Invalid 'state' value");
        STAssertTrue([location.zipCode isEqualToString:@"94321"],
                     @"Invalid 'zipCode' value");
        STAssertTrue([location.name isEqualToString:@"test_location_updated"],
                     @"Invalid 'name' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test Delete
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [[FFRecordLocation initWithRecordID:self.location.locationID] deleteWithCompletion:^(BOOL isSuccess, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    // Confirm the location is deleted
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    [FFRecordLocation retrieveWithCompletion:^(BOOL isSuccess, NSArray *locations, FFError *error) {

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([locations count] == 0,
                     @"Invalid number of locations returned");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
}

@end
