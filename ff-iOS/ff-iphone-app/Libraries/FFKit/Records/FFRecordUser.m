//
//  FFRecordUser.m
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordUser.h"

#import "FFDataUser.h"
#import "FFDataLocation.h"

#import "FFRecordLocation.h"

#import "NSDictionary+FFNull.h"
#import "FFValue.h"
#import "FFError.h"
#import "FFAPIClient.h"

@implementation FFRecordUser

typedef enum RoleType : NSInteger RoleType;
enum RoleType : NSInteger {
    Donor = 1,
    Donee = 2
};

+ (void)loadDataToModelObject:(FFDataUser *)modelObject fromJSONObject:(NSDictionary *)jsonObject
{
    FFDataUser *model = modelObject;
    NSDictionary *json = jsonObject;
    
    [model setUserID:[[json ff_objectForKey:@"id"] unsignedIntegerValue]];
    [model setFullName:[json ff_objectForKey:@"full_name"]];
    [model setEmail:[json ff_objectForKey:@"email"]];
    [model setMobilePhoneNumber:[json ff_objectForKey:@"primary_phone"]];
    [model setOrganization:[json ff_objectForKey:@"organization"]];
    [model setVehicleType:[[json ff_objectForKey:@"vehicle"] integerValue]];
    
    // Set role according to role mask
    NSNumber *roleMask = [json ff_objectForKey:@"roles_mask"];
    if ([roleMask integerValue] == Donor) {
        [model setRole:@"donor"];
    }
    else if ([roleMask integerValue] == Donee) {
        [model setRole:@"donee"];
    }

    // Set default location
    if ([json ff_objectForKey:@"default_location"]) {
        FFDataLocation *location = [FFDataLocation new];
        [FFRecordLocation loadDataToModelObject:location fromJSONObject:[json ff_objectForKey:@"default_location"]];
        [model setDefaultLocation:location];
    }
}

+ (instancetype)initWithModelObject:(FFDataUser *)modelObject
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object loadDataFromModelObject:modelObject];
    }
    
    return object;
}

+ (void)retrieveWithCompletion:(void (^)(BOOL isSuccess, FFDataUser *user, FFError *error))completion
{
    [[FFRecordObject sharedAPIClient] getUserWithCompletion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            
            FFDataUser *user = [FFDataUser new];
            [FFRecordUser loadDataToModelObject:user fromJSONObject:[response ff_objectForKey:@"user"]];
            
            completion(YES, user, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)loadDataFromModelObject:(FFDataUser *)modelObject
{
    FFDataUser *user = modelObject;
    
    [self setRecordID:user.userID];
    [self setFullName:user.fullName];
    [self setEmail:user.email];
    [self setPassword:user.password];
    [self setMobilePhoneNumber:user.mobilePhoneNumber];
    [self setOrganization:user.organization];
    [self setRole:user.role];
    [self setVehicleType:user.vehicleType];
    [self setDefaultLocationID:user.defaultLocation.locationID];
}

- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataUser *user, FFError *error))completion
{
    //
    // Create user
    //
    NSDictionary *params = @{
         @"email": [FFValue valueWithObject:self.email],
         @"password": [FFValue valueWithObject:self.password],
         @"full_name": [FFValue valueWithObject:self.fullName],
         @"primary_phone": [FFValue valueWithObject:self.mobilePhoneNumber],
         @"organization": [FFValue valueWithObject:self.organization],
         @"role": [FFValue valueWithObject:self.role],
         @"vehicle": [FFValue valueWithInteger:self.vehicleType],
         @"default_location_id": [FFValue valueWithUnsignedInteger:self.defaultLocationID]
    };

    [[FFRecordObject sharedAPIClient] createUserWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];

            FFDataUser *user = [FFDataUser new];
            [FFRecordUser loadDataToModelObject:user fromJSONObject:[response ff_objectForKey:@"user"]];
            
            completion(YES, user, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)updateWithCompletion:(void (^)(BOOL isSuccess, FFDataUser *user, FFError *error))completion
{
    //
    // Update user
    //
    NSDictionary *params = @{
         @"email": [FFValue valueWithObject:self.email],
         @"password": [FFValue valueWithObject:self.password],
         @"full_name": [FFValue valueWithObject:self.fullName],
         @"primary_phone": [FFValue valueWithObject:self.mobilePhoneNumber],
         @"organization": [FFValue valueWithObject:self.organization],
         @"vehicle": [FFValue valueWithInteger:self.vehicleType],
         @"default_location_id": [FFValue valueWithUnsignedInteger:self.defaultLocationID]
    };

    [[FFRecordObject sharedAPIClient] updateUserWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            
            FFDataUser *user = [FFDataUser new];
            [FFRecordUser loadDataToModelObject:user fromJSONObject:[response ff_objectForKey:@"user"]];

            completion(YES, user, nil);
        }
        else {
            completion(NO, nil, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                            andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

- (void)sendResetPasswordInstructionsWithCompletion:(void (^)(BOOL isSuccess, FFError *error))completion
{
    //
    //  Send Reset Password Instructions to current user
    //
    NSDictionary *params = @{
         @"email": [FFValue valueWithObject:self.email]
    };
    
    [[FFRecordObject sharedAPIClient] sendResetPasswordInstructionsWithParameters:params completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([FFRecordObject isSuccess:responseObject]) {
            completion(YES, nil);
        }
        else {
            completion(NO, [FFError initWithErrorType:[responseObject ff_objectForKey:@"type"]
                                       andDescription:[responseObject ff_objectForKey:@"message"]]);
        }
    }];
}

@end
