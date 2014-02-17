//
//  PastDonationsModuleController.h
//  FFiPhoneApp
//
//  Created by lee on 8/12/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModuleControllerProtocol.h"

@class FFError, FFTableCellDataContainer, FFDataDonation;

@protocol PastDonationsModuleControllerDelegate <NSObject>

- (void)didReceiveRequestToPostSimilarDonationWithDonation:(FFDataDonation *)donation;

@end

@interface PastDonationsModuleController : NSObject <ModuleControllerProtocol>

@property (weak, nonatomic) id <PastDonationsModuleControllerDelegate> delegate;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) NSMutableArray *donationContainerCollection;

- (UINavigationController *)instantiatePastDonationsNavigationViewController;
- (void)setDonationContainerCollectionWithDonations:(NSArray *)donations;
- (void)addDonationsToDonationContainerCollectionWithDonations:(NSArray *)donations;
- (void)reloadPastDonationsWithSuccess:(void (^)(void))success failure:(void (^)(FFError *error))failure;
- (void)loadMorePastDonationsWithSuccess:(void (^)(BOOL isNoMoreData))success failure:(void (^)(FFError *error))failure;
- (void)addDonationWithDataContainer:(FFTableCellDataContainer *)container;
- (void)replaceContainerContainingDonation:(FFDataDonation *)donation withDataContainer:(FFTableCellDataContainer *)container;
- (void)deleteContainerContainingDonation:(FFDataDonation *)donation;
- (void)postSimilarDonationWithDonation:(FFDataDonation *)donation;

@end
