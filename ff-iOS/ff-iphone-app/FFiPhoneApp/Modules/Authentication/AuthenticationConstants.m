//
//  AuthenticationConstants.m
//  FFiPhoneApp
//
//  Created by lee on 8/2/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

NSString * const kAuthenticationStoryboardName = @"AuthenticationStoryboard";

NSString * const kOAuthRequestPath = @"/facebook?role=donor&callback_url=feedingforward://@auth_token@";
NSString * const kOAuthTokenPassingURLScheme = @"feedingforward";

//REST API URLS
NSString * const kAuthRequestBaseURL = @"http://feedingforward.apiary.io";
NSString * const kAuthRequestAuthPath = @"/api/session";