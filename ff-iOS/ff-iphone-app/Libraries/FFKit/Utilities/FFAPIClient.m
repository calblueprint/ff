//
//  FFAPIClient.m
//  FFiPhoneApp
//
//  Created by lee on 7/21/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

// HTTP header for keeping Auth Token
NSString * const APIAuthTokenHeaderName = @"FF-AUTH-TOKEN";

//
// API requests
//
// Authentication APIs
NSString * const APIRequest_GenerateAuthToken = @"POST auth/generate_token";
NSString * const APIRequest_DestroyAuthToken = @"POST auth/destroy_token";
NSString * const APIRequest_SendResetPasswordInstructions = @"POST auth/send_reset_password_instructions";
// User APIs
NSString * const APIRequest_GetUser = @"GET user";
NSString * const APIRequest_CreateUser = @"POST auth";
NSString * const APIRequest_UpdateUser = @"PUT user";
// Location APIs
NSString * const APIRequest_GetLocationByID = @"GET locations/$id$";
NSString * const APIRequest_GetLocations = @"GET locations";
NSString * const APIRequest_CreateLocation = @"POST locations";
NSString * const APIRequest_UpdateLocationByID = @"PUT locations/$id$";
NSString * const APIRequest_DeleteLocationByID = @"DELETE locations/$id$";
// Donation APIs
NSString * const APIRequest_GetDonationByID = @"GET donations/$id$";
NSString * const APIRequest_GetCurrentDonations = @"GET donations/current";
NSString * const APIRequest_GetPastDonations = @"GET donations/past";
NSString * const APIRequest_CreateDonation = @"POST donations";
NSString * const APIRequest_UpdateDonationByID = @"PUT donations/$id$";
NSString * const APIRequest_DeleteDonationByID = @"DELETE donations/$id$";
// Meal photo APIs
NSString * const APIRequest_CreateMealPhotoByDonationID = @"POST donations/$id$/meal_photo";
NSString * const APIRequest_DeleteMealPhotoByDonationID = @"DELETE donations/$id$/meal_photo";

@implementation FFAPIClient

+ (instancetype)sharedClient
{
    static FFAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });

    return sharedClient;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        [self setAPICallNumOfRetryOnError:3];
        [self setAPICallRetryTimeInterval:1];
        [self setIsEnableInterceptionHandler:NO];
    }

    return self;
}

//
// @param numOfRetry Number of retry on error
// @param retryTimeInterval Time interval (seconds) between each retrys
// @param interceptionHandler Block for handling intercepted response
// @param completion Block that would be executed whenever a response is received
//                  except when the interceptionHandler return YES
//
- (void)sendAsynchronousRequest:(NSMutableURLRequest *)request
                     numOfRetry:(NSInteger)numOfRetry
              retryTimeInterval:(NSInteger)retryTimeInterval
            interceptionHandler:(BOOL (^)(BOOL isSuccess, NSHTTPURLResponse *response, NSDictionary *responseJSON, NSString *errorMessage, void (^redoOperation)(void), void (^completionBlock)(BOOL isSuccess, NSDictionary *responseJSON, NSString *errorMessage)))interceptionHandler
                     completion:(void (^)(BOOL isSuccess, NSDictionary *responseJSON, NSString *errorMessage))completion
{
    // Define a weak self to prevent retain cycle when using 'self' in blocks
    __weak __typeof(&*self)weakSelf = self;

    // Create a block for re-doing the current call conveniently
    void (^redoOperation)(void) = ^{
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        
        [strongSelf sendAsynchronousRequest:request
                           numOfRetry:numOfRetry
                    retryTimeInterval:retryTimeInterval
                  interceptionHandler:interceptionHandler
                           completion:completion];
    };

    // Set Auth Token header
    if (self.APIAuthToken) {
        [request setValue:self.APIAuthToken forHTTPHeaderField:APIAuthTokenHeaderName];
    }

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        // Request succeeded
        NSDictionary *responseJSON = (NSDictionary *)JSON;
        
        DebugLog(@"%@", responseJSON);
        
        // Intercept response if interceptionHandler returns YES
        if (interceptionHandler && interceptionHandler(YES, response, responseJSON, nil, redoOperation, completion)) {
            return;
        }

        // Execute completion block if the response is not intercepted
        completion(YES, responseJSON, nil);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        if (numOfRetry > 0) {
            // Retry after 'APICallRetryTimeInterval' seconds
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, retryTimeInterval * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                __strong __typeof(&*weakSelf)strongSelf = weakSelf;

                [strongSelf sendAsynchronousRequest:request
                                       numOfRetry:numOfRetry-1
                                retryTimeInterval:retryTimeInterval
                              interceptionHandler:interceptionHandler
                                       completion:completion];
            });
        }
        else {
            // Request failed
            NSString *errorMessage = [NSString stringWithFormat:@"%@: [%@]",
                                      [error localizedDescription], [error localizedRecoverySuggestion]];
            
            // Intercept response if interceptionHandler returns YES
            if (interceptionHandler && interceptionHandler(NO, response, nil, errorMessage, redoOperation, completion)) {
                return;
            }

            // Execute completion block if the response is not intercepted
            completion(NO, nil, errorMessage);
        }
    }];

    // Give more time (10 mins) to the current operation to finish before being suspended
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:nil];
    
    [operation start];
}

- (void)sendJSONWithAPIRequest:(NSString *)APIRequest parameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    // Configure AFHTTPClient
    NSURL *baseURL = [NSURL URLWithString:self.APIBaseURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;

    // Parse APIRequest parameters
    NSArray *requestParams = [APIRequest componentsSeparatedByString:@" "];
    NSString *requestMethod = [requestParams objectAtIndex:0];
    NSString *requestPath = [requestParams objectAtIndex:1];
    
    // Prepare request
    NSMutableURLRequest *request = [httpClient requestWithMethod:requestMethod path:requestPath parameters:params];
    
    // Check if we need to enable interception handler
    id interceptionHandler = nil;
    if (self.isEnableInterceptionHandler) {
        interceptionHandler = self.responseInterceptionHandler;
    }
    
    // Send request
    [self sendAsynchronousRequest:request
                       numOfRetry:self.APICallNumOfRetryOnError
                retryTimeInterval:self.APICallRetryTimeInterval
              interceptionHandler:interceptionHandler
                       completion:completion];
}

- (void)sendMultipartFormWithAPIRequest:(NSString *)APIRequest
                             parameters:(NSDictionary *)params
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    // Configure AFHTTPClient
    NSURL *baseURL = [NSURL URLWithString:self.APIBaseURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    
    // Parse APIRequest parameters
    NSArray *requestParams = [APIRequest componentsSeparatedByString:@" "];
    NSString *requestMethod = [requestParams objectAtIndex:0];
    NSString *requestPath = [requestParams objectAtIndex:1];
    
    // Prepare request
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:requestMethod path:requestPath parameters:params constructingBodyWithBlock:block];

    // Send request
    [self sendAsynchronousRequest:request
                       numOfRetry:self.APICallNumOfRetryOnError
                retryTimeInterval:self.APICallRetryTimeInterval
              interceptionHandler:self.responseInterceptionHandler
                       completion:completion];
}

// Authentication APIs
- (void)generateAuthTokenWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_GenerateAuthToken parameters:params completion:completion];
}

- (void)destroyAuthTokenWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_DestroyAuthToken parameters:params completion:completion];
}

- (void)sendResetPasswordInstructionsWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_SendResetPasswordInstructions parameters:params completion:completion];
}

// User APIs
- (void)getUserWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_GetUser parameters:nil completion:completion];
}

- (void)createUserWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_CreateUser parameters:params completion:completion];
}

- (void)updateUserWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_UpdateUser parameters:params completion:completion];
}

// Location APIs
- (void)getLocationByID:(NSUInteger)locationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_GetLocationByID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                 withString:[NSString stringWithFormat:@"%u", locationID]];
    [self sendJSONWithAPIRequest:APIRequest parameters:nil completion:completion];
}

- (void)getLocationsWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_GetLocations parameters:nil completion:completion];
}

- (void)createLocationWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_CreateLocation parameters:params completion:completion];
}

- (void)updateLocationByID:(NSUInteger)locationID parameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_UpdateLocationByID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                    withString:[NSString stringWithFormat:@"%u", locationID]];
    [self sendJSONWithAPIRequest:APIRequest parameters:params completion:completion];
}

- (void)deleteLocationByID:(NSUInteger)locationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_DeleteLocationByID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                    withString:[NSString stringWithFormat:@"%u", locationID]];
    [self sendJSONWithAPIRequest:APIRequest parameters:nil completion:completion];
}

// Donation APIs
- (void)getDonationByID:(NSUInteger)donationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_GetDonationByID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                 withString:[NSString stringWithFormat:@"%u", donationID]];
    [self sendJSONWithAPIRequest:APIRequest parameters:nil completion:completion];
}

- (void)getCurrentDonationsWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_GetCurrentDonations parameters:nil completion:completion];
}

- (void)getCurrentDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_GetCurrentDonations parameters:@{
            @"max_id": [NSNumber numberWithInteger:maximumID],
            @"time_zone_utc_offset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]]
     } completion:completion];
}

- (void)getPastDonationsWithCompletion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_GetPastDonations parameters:nil completion:completion];
}

- (void)getPastDonationsWithMaximumID:(NSInteger)maximumID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_GetPastDonations parameters:@{
     @"max_id": [NSNumber numberWithInteger:maximumID],
     @"time_zone_utc_offset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]]
     } completion:completion];
}

- (void)createDonationWithParameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    [self sendJSONWithAPIRequest:APIRequest_CreateDonation parameters:params completion:completion];
}

- (void)updateDonationByID:(NSUInteger)donationID parameters:(NSDictionary *)params completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_UpdateDonationByID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                    withString:[NSString stringWithFormat:@"%u", donationID]];
    [self sendJSONWithAPIRequest:APIRequest parameters:params completion:completion];
}

- (void)deleteDonationByID:(NSUInteger)donationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_DeleteDonationByID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                    withString:[NSString stringWithFormat:@"%u", donationID]];
    [self sendJSONWithAPIRequest:APIRequest parameters:nil completion:completion];
}

// Meal photo APIs
- (void)createMealPhotoByDonationID:(NSUInteger)donationID image:(UIImage *)image completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_CreateMealPhotoByDonationID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                             withString:[NSString stringWithFormat:@"%u", donationID]];
    [self sendMultipartFormWithAPIRequest:APIRequest parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.9f) name:@"meal_photo" fileName:@"meal_photo.jpg" mimeType:@"image/jpeg"];
    } completion:completion];
}

- (void)deleteMealPhotoByDonationID:(NSUInteger)donationID completion:(void (^)(BOOL isSuccess, NSDictionary *responseObject, NSString *errorMessage))completion
{
    NSString *APIRequest = [APIRequest_DeleteMealPhotoByDonationID stringByReplacingOccurrencesOfString:@"$id$"
                                                                                             withString:[NSString stringWithFormat:@"%u", donationID]];
    [self sendJSONWithAPIRequest:APIRequest parameters:nil completion:completion];
}

@end
