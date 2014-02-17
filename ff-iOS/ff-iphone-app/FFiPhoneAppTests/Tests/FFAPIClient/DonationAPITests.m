//
//  LocationAPITests.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "DonationAPITests.h"
#import "Tests.h"

@implementation DonationAPITests

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
    
    //
    // Create a location
    //
    semaphore = dispatch_semaphore_create(0);
    
    params = @{
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
        [self setLocationID:[[location ff_objectForKey:@"id"] unsignedIntegerValue]];
        
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
}

- (void)test_CreateDonation_GetDonations_UpdateDonation_DeleteDonation
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];

    //
    // Test CreateDonation
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    NSDictionary *params = @{
        @"location_id": [NSNumber numberWithUnsignedInteger:self.locationID],
        @"donation": @{
                @"title": @"Apple",
                @"description": @"Fresh apple",
                @"total_lbs": @10,
                @"available_start_date": @"2033-7-21",
                @"available_start_time": @"10:20",
                @"available_end_date": @"2033-7-25",
                @"available_end_time": @"13:56",
                @"vehicle": @2
        }
    };

    [self.APIClient createDonationWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {

        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *donation = [response ff_objectForKey:@"donation"];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[donation ff_objectForKey:@"title"] isEqualToString:@"Apple"],
                     @"Invalid 'title' value");
        STAssertTrue([[donation ff_objectForKey:@"description"] isEqualToString:@"Fresh apple"],
                     @"Invalid 'description' value");
        STAssertTrue([[donation ff_objectForKey:@"total_lbs"] integerValue] == 10,
                     @"Invalid 'total_lbs' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_start"] substringToIndex:19] isEqualToString:@"2033-07-21T10:20:00"],
                     @"Invalid 'available_start' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_end"] substringToIndex:19] isEqualToString:@"2033-07-25T13:56:00"],
                     @"Invalid 'available_end' value");
        STAssertTrue([[donation ff_objectForKey:@"vehicle"] integerValue] == 2,
                     @"Invalid 'vehicle' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test GetCurrentDonations
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient getCurrentDonationsWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSArray *donations = [response ff_objectForKey:@"donations"];
        NSDictionary *donation = [donations ff_objectAtIndex:0];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[donation ff_objectForKey:@"title"] isEqualToString:@"Apple"],
                     @"Invalid 'title' value");
        STAssertTrue([[donation ff_objectForKey:@"description"] isEqualToString:@"Fresh apple"],
                     @"Invalid 'description' value");
        STAssertTrue([[donation ff_objectForKey:@"total_lbs"] integerValue] == 10,
                     @"Invalid 'total_lbs' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_start"] substringToIndex:19] isEqualToString:@"2033-07-21T10:20:00"],
                     @"Invalid 'available_start' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_end"] substringToIndex:19] isEqualToString:@"2033-07-25T13:56:00"],
                     @"Invalid 'available_end' value");
        STAssertTrue([[donation ff_objectForKey:@"vehicle"] integerValue] == 2,
                     @"Invalid 'vehicle' value");

        [self setDonationID:[[donation ff_objectForKey:@"id"] unsignedIntegerValue]];

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
  
    //
    // Test GetDonationByID
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient getDonationByID:self.donationID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *donation = [response ff_objectForKey:@"donation"];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[donation ff_objectForKey:@"title"] isEqualToString:@"Apple"],
                     @"Invalid 'title' value");
        STAssertTrue([[donation ff_objectForKey:@"description"] isEqualToString:@"Fresh apple"],
                     @"Invalid 'description' value");
        STAssertTrue([[donation ff_objectForKey:@"total_lbs"] integerValue] == 10,
                     @"Invalid 'total_lbs' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_start"] substringToIndex:19] isEqualToString:@"2033-07-21T10:20:00"],
                     @"Invalid 'available_start' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_end"] substringToIndex:19] isEqualToString:@"2033-07-25T13:56:00"],
                     @"Invalid 'available_end' value");
        STAssertTrue([[donation ff_objectForKey:@"vehicle"] integerValue] == 2,
                     @"Invalid 'vehicle' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");

    //
    // Test UpdateDonationByID
    //
    
    // Create a new location
    semaphore = dispatch_semaphore_create(0);
    
    params = @{
               @"location": @{
                       @"street_address_1": @"321 Market Street",
                       @"street_address_2": @"Apt C",
                       @"city": @"San Francisco",
                       @"state": @"CA",
                       @"zip": @"91234",
                       @"name": @"test_location"
                       }
               };
    [self.APIClient createLocationWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *location = [response ff_objectForKey:@"location"];
        [self setLocationID:[[location ff_objectForKey:@"id"] unsignedIntegerValue]];
        
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    
    // Update donation info
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
  
    params = @{
           @"title": @"Orange",
           @"description": @"Fresh orange",
           @"total_lbs": @20,
           @"available_start_date": @"2034-8-22",
           @"available_start_time": @"11:21",
           @"available_end_date": @"2034-8-26",
           @"available_end_time": @"14:57",
           @"vehicle": @3,
           @"location_id":[NSNumber numberWithUnsignedInteger:self.locationID]
     };

    [self.APIClient updateDonationByID:self.donationID parameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *donation = [response ff_objectForKey:@"donation"];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([[donation ff_objectForKey:@"title"] isEqualToString:@"Orange"],
                     @"Invalid 'title' value");
        STAssertTrue([[donation ff_objectForKey:@"description"] isEqualToString:@"Fresh orange"],
                     @"Invalid 'description' value");
        STAssertTrue([[donation ff_objectForKey:@"total_lbs"] integerValue] == 20,
                     @"Invalid 'total_lbs' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_start"] substringToIndex:19] isEqualToString:@"2034-08-22T11:21:00"],
                     @"Invalid 'available_start' value");
        STAssertTrue([[[donation ff_objectForKey:@"available_end"] substringToIndex:19] isEqualToString:@"2034-08-26T14:57:00"],
                     @"Invalid 'available_end' value");
        STAssertTrue([[donation ff_objectForKey:@"vehicle"] integerValue] == 3,
                     @"Invalid 'vehicle' value");
        STAssertTrue([[donation ff_objectForKey:@"location_id"] unsignedIntegerValue] == self.locationID,
                     @"Invalid 'location_id' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test DeleteDonation
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient deleteDonationByID:self.donationID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
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
    
    // Confirm the donation is deleted
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient getCurrentDonationsWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSArray *donations = [response ff_objectForKey:@"donations"];

        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([donations count] == 0,
                     @"Invalid number of donations returned");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
}

@end
