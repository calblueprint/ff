//
//  MealPhotoRecordTests.m
//  FFiPhoneApp
//
//  Created by lee on 7/26/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "MealPhotoRecordTests.h"
#import "Tests.h"

@implementation MealPhotoRecordTests

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
    
    //
    // Create a location
    //
    semaphore = dispatch_semaphore_create(0);
    
    FFDataLocation *location = [FFDataLocation new];
    [location setStreetAddressOne:@"123 Market Street"];
    [location setStreetAddressTwo:@"Apt B"];
    [location setCity:@"San Francisco"];
    [location setState:@"CA"];
    [location setZipCode:@"91234"];
    [location setName:@"test_location"];
    
    [[FFRecordLocation initWithModelObject:location] createWithCompletion:^(BOOL isSuccess, FFDataLocation *location, FFError *error) {
        
        [self setLocation:location];
        
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    
    //
    // Create a donation
    //
    semaphore = dispatch_semaphore_create(0);
    
    FFDataDonation *donation = [FFDataDonation new];
    [donation setLocation:self.location];
    [donation setDonationTitle:@"Apple"];
    [donation setDonationDescription:@"Fresh apple"];
    [donation setTotalLBS:10];
    [donation setAvailableStart:[NSDate ff_dateFromString:@"2013-7-21 10:20" withFormat:@"yyyy-MM-dd HH:mm"]];
    [donation setAvailableEnd:[NSDate ff_dateFromString:@"2013-7-25 13:56" withFormat:@"yyyy-MM-dd HH:mm"]];
    [donation setVehicleType:2];
    
    [[FFRecordDonation initWithModelObject:donation] createWithCompletion:^(BOOL isSuccess, FFDataDonation *donation, FFError *error) {
        
        [self setDonation:donation];
        
        // Done
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
}

- (void)test_Create_Delete
{
    dispatch_semaphore_t semaphore = nil;
    NSMutableString *testState = [NSMutableString stringWithString:@""];
    
    //
    // Test Create
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];

    [[FFRecordMealPhoto initWithImage:[UIImage imageNamed:@"test.jpg"] andDonation:self.donation] createWithCompletion:^(BOOL isSuccess, FFDataImage *image, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue(image.imageURL != nil,
                     @"Invalid 'imageURL' value");
        
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
    
    [[FFRecordMealPhoto initWithDonation:self.donation] deleteWithCompletion:^(BOOL isSuccess, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    // Confirm the meal photo is deleted
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [[FFRecordDonation initWithRecordID:self.donation.donationID] retrieveWithCompletion:^(BOOL isSuccess, FFDataDonation *donation, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue(donation.mealPhoto.imageURL == nil,
                     @"Invalid 'imageURL' value");
        
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
}

@end
