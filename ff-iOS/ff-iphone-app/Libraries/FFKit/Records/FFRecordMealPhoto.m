//
//  FFRecordMealPhoto.m
//  FFiPhoneApp
//
//  Created by lee on 7/24/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFRecordMealPhoto.h"

#import "FFDataDonation.h"
#import "FFDataImage.h"

#import "NSDictionary+FFNull.h"
#import "FFError.h"
#import "FFAPIClient.h"

@implementation FFRecordMealPhoto

+ (instancetype)initWithImage:(UIImage *)imageObject andDonation:(FFDataDonation *)donationObject
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object loadDataFromImage:imageObject andDonation:donationObject];
    }
    
    return object;
}

+ (instancetype)initWithDonation:(FFDataDonation *)donationObject
{
    id object = [[super alloc] init];
    
    if (object)
    {
        [object setDonation:donationObject];
    }

    return object;
}

- (void)loadDataFromImage:(UIImage *)imageObject andDonation:(FFDataDonation *)donationObject
{
    [self setImage:imageObject];
    [self setDonation:donationObject];
}

- (void)createWithCompletion:(void (^)(BOOL isSuccess, FFDataImage *image, FFError *error))completion
{
    //
    // Create meal photo
    //
    [[FFRecordObject sharedAPIClient] createMealPhotoByDonationID:self.donation.donationID image:self.image completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
        if ([self isSuccess:responseObject]) {
            NSDictionary *response = [responseObject ff_objectForKey:@"response"];
            NSDictionary *donation = [response ff_objectForKey:@"donation"];
            
            FFDataImage *mealPhoto = [FFDataImage new];
            [FFRecordImage loadDataToModelObject:mealPhoto fromJSONObject:[donation ff_objectForKey:@"meal_photo"]];

            completion(YES, mealPhoto, nil);
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
    // Delete meal photo
    //
    [[FFRecordObject sharedAPIClient] deleteMealPhotoByDonationID:self.donation.donationID completion:^(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage) {
        
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
