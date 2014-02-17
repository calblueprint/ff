//
//  AppSettings.m
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#ifdef DEBUG
NSString * const kAPIEndpointURL = @"https://feedingforward-staging.herokuapp.com/api";
NSString * const kOAuthEndpointURL = @"http://feedingforward-staging.herokuapp.com/api/oauth";
#else
NSString * const kAPIEndpointURL = @"https://feedingforward.herokuapp.com/api";
NSString * const kOAuthEndpointURL = @"http://feedingforward.herokuapp.com/api/oauth";
#endif

NSString * const kStyleNavigationBarBackgroundImage = @"navigationbar_background.png";
NSString * const kStyleDonationTablePlaceholderImage = @"donation_table_placeholder.png";

NSString * const kUserDefaultsAuthTokenKey = @"FFAuthToken";
NSString * const kUserDefaultsShareDonationPopupKey = @"FFSettingShareDonationPopup";