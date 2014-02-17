//
//  FFAPIClient.h
//  FFiPhoneApp
//
//  Created by lee on 7/21/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface FFAPIClient : NSObject

@property (nonatomic, copy) NSString *APIBaseURL;
@property (nonatomic, copy) NSString *APIAuthToken;
@property (nonatomic) NSInteger APICallNumOfRetryOnError;
@property (nonatomic) NSInteger APICallRetryTimeInterval;
@property (nonatomic, copy) BOOL (^responseInterceptionHandler)(BOOL isSuccess, NSHTTPURLResponse *response, NSDictionary *responseJSON, NSString *errorMessage, void (^redoOperation)(void), void(^completionBlock)(BOOL isSuccess, NSDictionary *responseJSON, NSString *errorMessage));
@property (nonatomic) BOOL isEnableInterceptionHandler;

+ (FFAPIClient *)sharedClient;

// Genetic methods for making API calls
- (void)sendAsynchronousRequest:(NSURLRequest *)request
                     numOfRetry:(NSInteger)numOfRetry
              retryTimeInterval:(NSInteger)retryTimeInterval
            interceptionHandler:(BOOL (^)(BOOL isSuccess, NSHTTPURLResponse *response, NSDictionary *responseJSON, NSString *errorMessage, void (^redoOperation)(void), void(^completionBlock)(BOOL isSuccess, NSDictionary *responseJSON, NSString *errorMessage)))interceptionHandler
                     completion:(void (^)(BOOL isSuccess, NSDictionary *responseJSON, NSString *errorMessage))completion;

- (void)sendJSONWithAPIRequest:(NSString *)APIRequest parameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;

- (void)sendMultipartFormWithAPIRequest:(NSString *)APIRequest
                             parameters:(NSDictionary *)params
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;

// Authentication APIs
- (void)generateAuthTokenWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)destroyAuthTokenWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)sendResetPasswordInstructionsWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;

// User APIs
- (void)getUserWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)createUserWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)updateUserWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;

// Location APIs
- (void)getLocationByID:(NSUInteger)locationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)getLocationsWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)createLocationWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)updateLocationByID:(NSUInteger)locationID parameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)deleteLocationByID:(NSUInteger)locationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;

// Donation APIs
- (void)getDonationByID:(NSUInteger)donationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)getCurrentDonationsWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)getCurrentDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)getPastDonationsWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)getPastDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)createDonationWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)updateDonationByID:(NSUInteger)donationID parameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)deleteDonationByID:(NSUInteger)donationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;

// Meal photo APIs
- (void)createMealPhotoByDonationID:(NSUInteger)donationID image:(UIImage *)image completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;
- (void)deleteMealPhotoByDonationID:(NSUInteger)donationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion;

@end
