//
//  LocationAPITests.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "LocationAPITests.h"
#import "Tests.h"

@implementation LocationAPITests

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
    NSDictionary *params = @{
         @"email": email,
         @"password": password,
         @"full_name": @"test_user",
         @"role": @"donor"
    };

    [self.APIClient createUserWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    
    //
    // Generate an auth token
    //
    semaphore = dispatch_semaphore_create(0);
    
    [self.APIClient generateAuthTokenWithParameters:@{@"email": email, @"password": password} completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        self.authToken = [response ff_objectForKey:@"auth_token"];

        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    
    [self.APIClient setAPIAuthToken:self.authToken];
}

- (void)test_CreateLocation_GetLocations_UpdateLocation_DeleteLocation
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];

    //
    // Test CreateLocation
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    NSDictionary *params = @{
        @"location": @{
                @"street_address_1": @"123 Market Street",
                @"street_address_2": @"Apt B",
                @"city": @"San Francisco",
                @"state": @"CA",
                @"zip": @"91234",
                @"name": @"test_location"
        }
    };

    [self.APIClient createLocationWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *location = [response ff_objectForKey:@"location"];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[location ff_objectForKey:@"street_address_1"] isEqualToString:@"123 Market Street"],
                     @"Invalid 'street_address_1' value");
        STAssertTrue([[location ff_objectForKey:@"street_address_2"] isEqualToString:@"Apt B"],
                     @"Invalid 'street_address_2' value");
        STAssertTrue([[location ff_objectForKey:@"city"] isEqualToString:@"San Francisco"],
                     @"Invalid 'city' value");
        STAssertTrue([[location ff_objectForKey:@"state"] isEqualToString:@"CA"],
                     @"Invalid 'state' value");
        STAssertTrue([[location ff_objectForKey:@"zip"] isEqualToString:@"91234"],
                     @"Invalid 'zip' value");
        STAssertTrue([[location ff_objectForKey:@"name"] isEqualToString:@"test_location"],
                     @"Invalid 'name' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test GetLocations
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient getLocationsWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSArray *locations = [response ff_objectForKey:@"locations"];
        NSDictionary *location = [locations ff_objectAtIndex:0];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([locations count] == 1,
                     @"Invalid number of locations returned");
        STAssertTrue([[location ff_objectForKey:@"street_address_1"] isEqualToString:@"123 Market Street"],
                     @"Invalid 'street_address_1' value");
        STAssertTrue([[location ff_objectForKey:@"street_address_2"] isEqualToString:@"Apt B"],
                     @"Invalid 'street_address_2' value");
        STAssertTrue([[location ff_objectForKey:@"city"] isEqualToString:@"San Francisco"],
                     @"Invalid 'city' value");
        STAssertTrue([[location ff_objectForKey:@"state"] isEqualToString:@"CA"],
                     @"Invalid 'state' value");
        STAssertTrue([[location ff_objectForKey:@"zip"] isEqualToString:@"91234"],
                     @"Invalid 'zip' value");
        STAssertTrue([[location ff_objectForKey:@"name"] isEqualToString:@"test_location"],
                     @"Invalid 'name' value");

        [self setLocationID:[[location ff_objectForKey:@"id"] unsignedIntegerValue]];
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
  
    //
    // Test GetLocationByID
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient getLocationByID:self.locationID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *location = [response ff_objectForKey:@"location"];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[location ff_objectForKey:@"street_address_1"] isEqualToString:@"123 Market Street"],
                     @"Invalid 'street_address_1' value");
        STAssertTrue([[location ff_objectForKey:@"street_address_2"] isEqualToString:@"Apt B"],
                     @"Invalid 'street_address_2' value");
        STAssertTrue([[location ff_objectForKey:@"city"] isEqualToString:@"San Francisco"],
                     @"Invalid 'city' value");
        STAssertTrue([[location ff_objectForKey:@"state"] isEqualToString:@"CA"],
                     @"Invalid 'state' value");
        STAssertTrue([[location ff_objectForKey:@"zip"] isEqualToString:@"91234"],
                     @"Invalid 'zip' value");
        STAssertTrue([[location ff_objectForKey:@"name"] isEqualToString:@"test_location"],
                     @"Invalid 'name' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");

    //
    // Test UpdateLocation
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    params = @{
         @"street_address_1": @"123 Norton Street",
         @"street_address_2": @"Apt C",
         @"city": @"San Jose",
         @"state": @"TX",
         @"zip": @"94321",
         @"name": @"test_location_updated"
     };

    [self.APIClient updateLocationByID:self.locationID parameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *location = [response ff_objectForKey:@"location"];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[location ff_objectForKey:@"street_address_1"] isEqualToString:@"123 Norton Street"],
                     @"Invalid 'street_address_1' value");
        STAssertTrue([[location ff_objectForKey:@"street_address_2"] isEqualToString:@"Apt C"],
                     @"Invalid 'street_address_2' value");
        STAssertTrue([[location ff_objectForKey:@"city"] isEqualToString:@"San Jose"],
                     @"Invalid 'city' value");
        STAssertTrue([[location ff_objectForKey:@"state"] isEqualToString:@"TX"],
                     @"Invalid 'state' value");
        STAssertTrue([[location ff_objectForKey:@"zip"] isEqualToString:@"94321"],
                     @"Invalid 'zip' value");
        STAssertTrue([[location ff_objectForKey:@"name"] isEqualToString:@"test_location_updated"],
                     @"Invalid 'name' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test DeleteLocation
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient deleteLocationByID:self.locationID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
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
    
    // Confirm the location is deleted
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient getLocationsWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSArray *locations = [response ff_objectForKey:@"locations"];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
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
