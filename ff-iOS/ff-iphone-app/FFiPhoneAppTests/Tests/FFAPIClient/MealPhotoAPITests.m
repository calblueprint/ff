//
//  MealPhotoAPITests.m
//  FFiPhoneApp
//
//  Created by lee on 7/26/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "MealPhotoAPITests.h"
#import "Tests.h"

@implementation MealPhotoAPITests

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
    
    //
    // Create a donation
    //
    semaphore = dispatch_semaphore_create(0);
    
    params = @{
         @"location_id": [NSNumber numberWithUnsignedInteger:self.locationID],
         @"donation": @{
                 @"title": @"Apple",
                 @"total_lbs": @10,
                 @"available_start_date": @"2013-7-21",
                 @"available_start_time": @"10:20",
                 @"available_end_date": @"2013-7-25",
                 @"available_end_time": @"13:56",
                 @"vehicle": @2
         }
     };

    [self.APIClient createDonationWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *donation = [response ff_objectForKey:@"donation"];
        [self setDonationID:[[donation ff_objectForKey:@"id"] unsignedIntegerValue]];
        
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
}

- (void)test_CreateMealPhotoByDonationID_DeleteMealPhotoByDonationID
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];
    
    //
    // Test CreateMealPhotoByDonationID
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    [self.APIClient createMealPhotoByDonationID:self.donationID image:[UIImage imageNamed:@"test.jpg"] completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSDictionary *donation = [response ff_objectForKey:@"donation"];
        NSDictionary *mealPhoto = [donation ff_objectForKey:@"meal_photo"];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([mealPhoto ff_objectForKey:@"url"] != nil,
                     @"Invalid 'url' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    //
    // Test DeleteMealPhotoByDonationID
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [self.APIClient deleteMealPhotoByDonationID:self.donationID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        NSDictionary *response = [responseObject ff_objectForKey:@"response"]; 
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([[responseObject ff_objectForKey:@"result"] isEqualToString:@"success"],
                     @"Invalid 'result' value");
        STAssertTrue([response ff_objectForKey:@"meal_photo"] == nil,
                     @"Invalid 'meal_photo' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
}

@end
