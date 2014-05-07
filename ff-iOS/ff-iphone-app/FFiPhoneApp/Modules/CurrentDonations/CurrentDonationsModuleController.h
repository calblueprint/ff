//
//  CurrentDonationsModuleController.h
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModuleControllerProtocol.h"
#import "MMDrawerController.h"

@class FFError, FFTableCellDataContainer, FFDataDonation;

@interface CurrentDonationsModuleController : NSObject <ModuleControllerProtocol>

@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) NSMutableArray *donationContainerCollection;
@property (strong, nonatomic) MMDrawerController *mmDrawerController;


- (UINavigationController *)instantiateCurrentDonationsNavigationViewController;
- (void)setDonationContainerCollectionWithDonations:(NSArray *)donations;
- (void)addDonationsToDonationContainerCollectionWithDonations:(NSArray *)donations;
- (void)reloadCurrentDonationsWithSuccess:(void (^)(void))success failure:(void (^)(FFError *error))failure;
- (void)loadMoreCurrentDonationsWithSuccess:(void (^)(BOOL isNoMoreData))success failure:(void (^)(FFError *error))failure;
- (void)addDonationWithDataContainer:(FFTableCellDataContainer *)container;
- (void)replaceContainerContainingDonation:(FFDataDonation *)donation withDataContainer:(FFTableCellDataContainer *)container;
- (void)deleteContainerContainingDonation:(FFDataDonation *)donation;

@end
