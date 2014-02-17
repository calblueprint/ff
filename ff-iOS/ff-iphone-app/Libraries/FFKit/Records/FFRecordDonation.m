//
//  FFRecordDonation.m
//  FFiPhoneApp
//
//  Created by lee on 7/23/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordDonation.h"

#import "FFDataUser.h"
#import "FFDataDonation.h"
#import "FFDataLocation.h"
#import "FFDataImage.h"
#import "FFDataDelivery.h"

#import "FFRecordUser.h"
#import "FFRecordLocation.h"
#import "FFRecordImage.h"
#import "FFRecordDelivery.h"

#import "NSDate+FFDateUtilities.h"
#import "NSDictionary+FFNull.h"
#import "FFError.h"
#import "FFAPIClient.h"
#import "FFValue.h"

@implementation FFRecordDonation

+ (void)loadDataToModelObject:(FFDataDonation *)modelObject fromJSONObject:(NSDictionary *)jsonObject
{
    FFDataDonation *model = modelObject;
    NSDictionary *json = jsonObject;
    
    [model setDonationID:[[json ff_objectForKey:@"id"] unsignedIntegerValue]];
    [model setDonationTitle:[json ff_objectForKey:@"title"]];
    [model setDonationDescription:[json ff_objectForKey:@"description"]];
    [model setTotalLBS:[[json ff_objectForKey:@"total_lbs"] unsignedIntegerValue]];
    [model setAvailableStart:[NSDate ff_dateFromString:[json ff_objectForKey:@"available_start"]
                                            withFormat:FFRecordDateFormat]];
    [model setAvailableEnd:[NSDate ff_dateFromString:[json ff_objectForKey:@"available_end"]
                                            withFormat:FFRecordDateFormat]];
    [model setStatusCode:[[json ff_objectForKey:@"status"] integerValue]];
    [model setStatusText:[json ff_objectForKey:@"status_text"]];
    [model setVehicleType:[[json ff_objectForKey:@"vehicle"] integerValue]];
    
    // Set meal photo
    if ([[json ff_objectForKey:@"meal_photo"] ff_objectForKey:@"url"]) {
        FFDataImage *image = [FFDataImage new];
        [FFRecordImage loadDataToModelObject:image fromJSONObject:[json ff_objectForKey:@"meal_photo"]];
        [model setMealPhoto:image];
    }

    // Set location
    if ([json ff_objectForKey:@"location"]) {
        FFDataLocation *location = [FFDataLocation new];
        [FFRecordLocation loadDataToModelObject:location fromJSONObject:[json ff_objectForKey:@"location"]];
        [model setLocation:location];
    }

    // Set donor
    if ([json ff_objectForKey:@"donor"]) {
        FFDataUser *donor = [FFDataUser new];
        [FFRecordUser loadDataToModelObject:donor fromJSONObject:[json ff_objectForKey:@"donor"]];
        [model setDonor:donor];
    }

    // Set donee
    if ([json ff_objectForKey:@"donee"]) {
        FFDataUser *donee = [FFDataUser new];
        [FFRecordUser loadDataToModelObject:donee fromJSONObject:[json ff_objectForKey:@"donee"]];
        [model setDonor:donee];
    }
    
    // Set delivery
    if ([json ff_objectForKey:@"delivery"]) {
        FFDataDelivery *delivery = [FFDataDelivery new];
        [FFRecordDelivery loadDataToModelObject:delivery fromJSONObject:[json ff_objectForKey:@"delivery"]];
        [model setDelivery:delivery];
    }
}

+ (instancetype)initWithModelObject:(FFDataDonation *)modelObject
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object loadDataFromModelObject:modelObject];
    }
    
    return object;
}

+ (instancetype)initWithRecordID:(NSUInteger)recordID
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object setRecordID:recordID];
    }

    return object;
}

+ (void)retrieveCurrentDonationsWithCompletion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion
{
    //
    // Retrieve current donations
    //
    [[FFRecordObject sharedAPIClient] getCurrentDonationsWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
 
        [self processRetrievedCurrentDonationsWithResult:isSuccess response:responseObject errorMessage:errorMessage completion:completion];
    }];
}

+ (void)retrieveCurrentDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion
{
    //
    // Retrieve current donations with ID <= maximumID
    //
    [[FFRecordObject sharedAPIClient] getCurrentDonationsWithMaximumID:maximumID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        [self processRetrievedCurrentDonationsWithResult:isSuccess response:responseObject errorMessage:errorMessage completion:completion];
    }];
}

+ (void)retrievePastDonationsWithCompletion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion
{
    //
    // Retrieve current donations
    //
    [[FFRecordObject sharedAPIClient] getPastDonationsWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        [self processRetrievedCurrentDonationsWithResult:isSuccess response:responseObject errorMessage:errorMessage completion:completion];
    }];
}

+ (void)retrievePastDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion
{
    //
    // Retrieve current donations with ID <= maximumID
    //
    [[FFRecordObject sharedAPIClient] getPastDonationsWithMaximumID:maximumID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        [self processRetrievedCurrentDonationsWithResult:isSuccess response:responseObject errorMessage:errorMessage completion:completion];
    }];
}

//
// Helper function to simply code
//
+ (void)processRetrievedCurrentDonationsWithResult:(BOOL)isSuccess response:(NSDictionary *)responseObject errorMessage:(NSString *)errorMessage completion:(void (^)(BOOL isSuccess, NSArray *donations, FFError *error))completion
{
    if ([self isSuccess:responseObject]) {
        NSDictionary *response = [responseObject ff_objectForKey:@"response"];
        NSArray *retrievedDonations = [response ff_objectForKey:@"donations"];
        NSMutableArray *donations = [NSMutableArray array];
        
        [retrievedDonations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FFDataDonation *donation = [FFDataDonation new];
            [FFRecordDonation loadDataToModelObject:donation fromJSONObject:(NSDictionary *)obj];
            [donations addObject:donation];
        }];
        
        completion(YES, donations, nil);
    }
    else {
        completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                        andDescription:[responseObject ff_objectForKey:@"message"]]);
    }
}

- (void)loadDataFromModelObject:(FFDataDonation *)modelObject
{
    FFDataDonation *donation = modelObject;

    [self setRecordID:donation.donationID];
    [self setDonationTitle:donation.donationTitle];
    [self setDonationDescription:donation.donationDescription];
    [self setTotalLBS:donation.totalLBS];
    [self setVehicleType:donation.vehicleType];
    [self setAvailableStartDate:[donation.availableStart ff_stringWithFormat:@"yyyy-MM-dd"]];
    [self setAvailableStartTime:[donation.availableStart ff_stringWithFormat:@"HH:mm"]];
    [self setAvailableEndDate:[donation.availableEnd ff_stringWithFormat:@"yyyy-MM-dd"]];
    [self setAvailableEndTime:[donation.availableEnd ff_stringWithFormat:@"HH:mm"]];
    [self setLocationID:donation.location.locationID];
}

- (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, FFDataDonation *donation, FFError *error))completion
{
    //
    // Retreive a donation by ID
    //
    [[FFRecordObject sharedAPIClient] getDonationByID:self.recordID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {

        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
 
            FFDataDonation *donation = [FFDataDonation new];
            [FFRecordDonation loadDataToModelObject:donation fromJSONObject:[response ff_objectForKey:@"donation"]];
            
            completion(YES, donation, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataDonation *donation, FFError *error))completion
{
    //
    // Create donation
    //
    NSDictionary *params = @{
         @"location_id": [FFValue valueWithUnsignedInteger:self.locationID],
         @"donation": @{
                 @"title": [FFValue valueWithObject:self.donationTitle],
                 @"description": [FFValue valueWithObject:self.donationDescription],
                 @"total_lbs": [FFValue valueWithUnsignedInteger:self.totalLBS],
                 @"available_start_date": [FFValue valueWithObject:self.availableStartDate],
                 @"available_start_time": [FFValue valueWithObject:self.availableStartTime],
                 @"available_end_date": [FFValue valueWithObject:self.availableEndDate],
                 @"available_end_time": [FFValue valueWithObject:self.availableEndTime],
                 @"vehicle": [FFValue valueWithInteger:self.vehicleType]
        }
    };

    [[FFRecordObject sharedAPIClient] createDonationWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            
            FFDataDonation *donation = [FFDataDonation new];
            [FFRecordDonation loadDataToModelObject:donation fromJSONObject:[response ff_objectForKey:@"donation"]];
            
            completion(YES, donation, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)updateWithCompletion:(void (^)(BOOL isSuccess, FFDataDonation *donation, FFError *error))completion
{
    //
    // Update donation
    //
    NSDictionary *params = @{
         @"title": [FFValue valueWithObject:self.donationTitle],
         @"description": [FFValue valueWithObject:self.donationDescription],
         @"total_lbs": [FFValue valueWithUnsignedInteger:self.totalLBS],
         @"available_start_date": [FFValue valueWithObject:self.availableStartDate],
         @"available_start_time": [FFValue valueWithObject:self.availableStartTime],
         @"available_end_date": [FFValue valueWithObject:self.availableEndDate],
         @"available_end_time": [FFValue valueWithObject:self.availableEndTime],
         @"vehicle": [FFValue valueWithInteger:self.vehicleType],
         @"location_id": [FFValue valueWithUnsignedInteger:self.locationID]
    };

    [[FFRecordObject sharedAPIClient] updateDonationByID:self.recordID parameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {

        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            
            FFDataDonation *donation = [FFDataDonation new];
            [FFRecordDonation loadDataToModelObject:donation fromJSONObject:[response ff_objectForKey:@"donation"]];
            
            completion(YES, donation, nil);
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
    // Delete donation
    //
    [[FFRecordObject sharedAPIClient] deleteDonationByID:self.recordID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
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
