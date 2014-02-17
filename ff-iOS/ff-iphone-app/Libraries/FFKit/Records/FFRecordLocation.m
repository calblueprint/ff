//
//  FFRecordLocation.m
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordLocation.h"

#import "FFDataLocation.h"

#import "NSDictionary+FFNull.h"
#import "FFError.h"
#import "FFValue.h"

#import "FFAPIClient.h"

@implementation FFRecordLocation

+ (void)loadDataToModelObject:(FFDataLocation *)modelObject fromJSONObject:(NSDictionary *)jsonObject
{
    FFDataLocation *model = modelObject;
    NSDictionary *json = jsonObject;
    
    [model setLocationID:[[json ff_objectForKey:@"id"] unsignedIntegerValue]];
    [model setAddress:[json ff_objectForKey:@"address"]];
    [model setName:[json ff_objectForKey:@"name"]];
    [model setStreetAddressOne:[json ff_objectForKey:@"street_address_1"]];
    [model setStreetAddressTwo:[json ff_objectForKey:@"street_address_2"]];
    [model setCity:[json ff_objectForKey:@"city"]];
    [model setState:[json ff_objectForKey:@"state"]];
    [model setZipCode:[json ff_objectForKey:@"zip"]];
}

+ (instancetype)initWithModelObject:(FFDataLocation *)modelObject
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object loadDataFromModelObject:modelObject];
    }
    
    return object;
}

+ (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, NSArray *locations, FFError *error))completion
{
    //
    // Retrieve all locations
    //
    [[FFRecordObject sharedAPIClient] getLocationsWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            NSArray *retrievedlocations = [response ff_objectForKey:@"locations"];
            NSMutableArray *locations = [NSMutableArray array];
            
            [retrievedlocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                FFDataLocation *location = [FFDataLocation new];
                [FFRecordLocation loadDataToModelObject:location fromJSONObject:(NSDictionary *)obj];
                [locations addObject:location];
            }];
            
            completion(YES, locations, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
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

- (void)loadDataFromModelObject:(FFDataLocation *)modelObject
{
    FFDataLocation *location = modelObject;
    
    [self setRecordID:location.locationID];
    [self setName:location.name];
    [self setStreetAddressOne:location.streetAddressOne];
    [self setStreetAddressTwo:location.streetAddressTwo];
    [self setCity:location.city];
    [self setState:location.state];
    [self setZipCode:location.zipCode];
}

- (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, FFDataLocation *location, FFError *error))completion
{
    //
    // Retreive a location by ID
    //
    [[FFRecordObject sharedAPIClient] getLocationByID:self.recordID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            
            FFDataLocation *location = [FFDataLocation new];
            [FFRecordLocation loadDataToModelObject:location fromJSONObject:[response ff_objectForKey:@"location"]];
            
            completion(YES, location, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataLocation *location, FFError *error))completion
{
    //
    // Create location
    //
    NSDictionary *params = @{
         @"location": @{
                 @"street_address_1": [FFValue valueWithObject:self.streetAddressOne],
                 @"street_address_2": [FFValue valueWithObject:self.streetAddressTwo],
                 @"city": [FFValue valueWithObject:self.city],
                 @"state": [FFValue valueWithObject:self.state],
                 @"zip": [FFValue valueWithObject:self.zipCode],
                 @"name": [FFValue valueWithObject:self.name]
         },
         @"ignore_duplicate_address": @1
     };

    [[FFRecordObject sharedAPIClient] createLocationWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            
            FFDataLocation *location = [FFDataLocation new];
            [FFRecordLocation loadDataToModelObject:location fromJSONObject:[response ff_objectForKey:@"location"]];
            
            completion(YES, location, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)updateWithCompletion:(void (^)(BOOL isSuccess, FFDataLocation *location, FFError *error))completion
{
    //
    // Update location
    //
    NSDictionary *params = @{
         @"street_address_1": [FFValue valueWithObject:self.streetAddressOne],
         @"street_address_2": [FFValue valueWithObject:self.streetAddressTwo],
         @"city": [FFValue valueWithObject:self.city],
         @"state": [FFValue valueWithObject:self.state],
         @"zip": [FFValue valueWithObject:self.zipCode],
         @"name": [FFValue valueWithObject:self.name]
     };

    [[FFRecordObject sharedAPIClient] updateLocationByID:self.recordID parameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            
            FFDataLocation *location = [FFDataLocation new];
            [FFRecordLocation loadDataToModelObject:location fromJSONObject:[response ff_objectForKey:@"location"]];
            
            completion(YES, location, nil);
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
    // Delete location
    //
    [[FFRecordObject sharedAPIClient] deleteLocationByID:self.recordID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
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
