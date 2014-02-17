//
//  LocationRecordTests.m
//  FFiPhoneApp
//
//  Created by lee on 7/25/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "DonationRecordTests.h"
#import "Tests.h"


@implementation DonationRecordTests

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

    FFDataDonation *donation = [FFDataDonation new];
    [donation setLocation:self.location];
    [donation setDonationTitle:@"Apple"];
    [donation setDonationDescription:@"Fresh apple"];
    [donation setTotalLBS:10];
    [donation setAvailableStart:[NSDate ff_dateFromString:@"2033-7-21 10:20" withFormat:@"yyyy-MM-dd HH:mm"]];
    [donation setAvailableEnd:[NSDate ff_dateFromString:@"2033-7-25 13:56" withFormat:@"yyyy-MM-dd HH:mm"]];
    [donation setVehicleType:2];
    
    [[FFRecordDonation initWithModelObject:donation] createWithCompletion:^(BOOL isSuccess, FFDataDonation *donation, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([donation.donationTitle isEqualToString:@"Apple"],
                     @"Invalid 'donationTitle' value");
        STAssertTrue([donation.donationDescription isEqualToString:@"Fresh apple"],
                     @"Invalid 'donationDescription' value");
        STAssertTrue(donation.totalLBS == 10,
                     @"Invalid 'totalLBS' value");
        STAssertTrue([[donation.availableStart ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2033-07-21 10:20"],
                     @"Invalid 'availableStart' value");
        STAssertTrue([[donation.availableEnd ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2033-07-25 13:56"],
                     @"Invalid 'availableEnd' value");
        STAssertTrue(donation.vehicleType == 2,
                     @"Invalid 'vehicleType' value");

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");

    //
    // Test Retrieve Active Donations
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [FFRecordDonation retrieveCurrentDonationsWithCompletion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
       
        FFDataDonation *donation = [donations ff_objectAtIndex:0];
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([donation.donationTitle isEqualToString:@"Apple"],
                     @"Invalid 'donationTitle' value");
        STAssertTrue([donation.donationDescription isEqualToString:@"Fresh apple"],
                     @"Invalid 'donationDescription' value");
        STAssertTrue(donation.totalLBS == 10,
                     @"Invalid 'totalLBS' value");
        STAssertTrue([[donation.availableStart ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2033-07-21 10:20"],
                     @"Invalid 'availableStart' value");
        STAssertTrue([[donation.availableEnd ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2033-07-25 13:56"],
                     @"Invalid 'availableEnd' value");
        STAssertTrue(donation.vehicleType == 2,
                     @"Invalid 'vehicleType' value");
        
        [self setDonation:donation];

        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
  
    //
    // Test Retrieve by ID
    //
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [[FFRecordDonation initWithRecordID:self.donation.donationID] retrieveWithCompletion:^(BOOL isSuccess, FFDataDonation *donation, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([donation.donationTitle isEqualToString:@"Apple"],
                     @"Invalid 'donationTitle' value");
        STAssertTrue(donation.totalLBS == 10,
                     @"Invalid 'totalLBS' value");
        STAssertTrue([[donation.availableStart ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2033-07-21 10:20"],
                     @"Invalid 'availableStart' value");
        STAssertTrue([[donation.availableEnd ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2033-07-25 13:56"],
                     @"Invalid 'availableEnd' value");
        STAssertTrue(donation.vehicleType == 2,
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
    
    // Create a new location
    semaphore = dispatch_semaphore_create(0);
    
    FFDataLocation *location = [FFDataLocation new];
    [location setStreetAddressOne:@"321 Market Street"];
    [location setStreetAddressTwo:@"Apt C"];
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
    
    // Update donation info
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    donation = [FFDataDonation new];
    [donation setDonationID:self.donation.donationID];
    [donation setDonationTitle:@"Orange"];
    [donation setDonationDescription:@"Fresh orange"];
    [donation setTotalLBS:20];
    [donation setAvailableStart:[NSDate ff_dateFromString:@"2034-8-22 11:21" withFormat:@"yyyy-MM-dd HH:mm"]];
    [donation setAvailableEnd:[NSDate ff_dateFromString:@"2034-8-26 14:57" withFormat:@"yyyy-MM-dd HH:mm"]];
    [donation setVehicleType:3];
    [donation setLocation:self.location];
    
    [[FFRecordDonation initWithModelObject:donation] updateWithCompletion:^(BOOL isSuccess, FFDataDonation *donation, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
        STAssertTrue([donation.donationTitle isEqualToString:@"Orange"],
                     @"Invalid 'donationTitle' value");
        STAssertTrue([donation.donationDescription isEqualToString:@"Fresh orange"],
                     @"Invalid 'donationDescription' value");
        STAssertTrue(donation.totalLBS == 20,
                     @"Invalid 'totalLBS' value");
        STAssertTrue([[donation.availableStart ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2034-08-22 11:21"],
                     @"Invalid 'availableStart' value");
        STAssertTrue([[donation.availableEnd ff_stringWithFormat:@"yyyy-MM-dd HH:mm"] isEqualToString:@"2034-08-26 14:57"],
                     @"Invalid 'availableEnd' value");
        STAssertTrue(donation.vehicleType == 3,
                     @"Invalid 'vehicleType' value");
        STAssertTrue(donation.location.locationID == self.location.locationID,
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
    
    [[FFRecordDonation initWithRecordID:self.donation.donationID] deleteWithCompletion:^(BOOL isSuccess, FFError *error) {
        STAssertTrue(isSuccess,
                     @"API request failed");
        // Done
        [testState setString:@"done"];
        dispatch_semaphore_signal(semaphore);
    }];

    [super wait:&semaphore];
    STAssertTrue([testState isEqualToString:@"done"], @"Test not executed");
    
    // Confirm the donation is deleted
    semaphore = dispatch_semaphore_create(0);
    [testState setString:@""];
    
    [FFRecordDonation retrieveCurrentDonationsWithCompletion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
        
        STAssertTrue(isSuccess,
                     @"API request failed");
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
