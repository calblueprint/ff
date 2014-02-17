//
//  PastDonationsModuleController.m
//  FFiPhoneApp
//
//  Created by lee on 8/12/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PastDonationsModuleController.h"
#import "PastDonationsBaseViewController.h"
#import "PastDonationsConstants.h"

#import "FFKit.h"

@implementation PastDonationsModuleController
{
    __weak ModuleCoordinator *_moduleCoordinator;
}

//
// Module protocol methods
//

+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return [viewController isKindOfClass:[PastDonationsBaseViewController class]];
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        _moduleCoordinator = moduleCoordinator;
        self.storyboard = [UIStoryboard storyboardWithName:kPastDonationsStoryboardName bundle:nil];
    }
    
    return self;
}

//----------------------

- (UINavigationController *)instantiatePastDonationsNavigationViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"PASDNavigationController"];
    [viewController setModuleController:self];
    
    return viewController;
}

- (void)setDonationContainerCollectionWithDonations:(NSArray *)donations
{
    self.donationContainerCollection = [NSMutableArray array];
    [self addDonationsToDonationContainerCollectionWithDonations:donations];
}

- (void)addDonationsToDonationContainerCollectionWithDonations:(NSArray *)donations
{
    for (FFDataDonation *donation in donations) {
        [self.donationContainerCollection addObject:[[FFTableCellDataContainer alloc] initWithData:donation configureCellBlock:nil didSelectRowBlock:nil]];
    }
}

- (void)reloadPastDonationsWithSuccess:(void (^)(void))success failure:(void (^)(FFError *error))failure
{
    [FFRecordDonation retrievePastDonationsWithMaximumID:-1 completion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
        if (isSuccess) {
            [self setDonationContainerCollectionWithDonations:donations];
            if (success) { success(); }
        }
        else {
            if (failure) { failure(error); }
        }
    }];
}

- (void)loadMorePastDonationsWithSuccess:(void (^)(BOOL isNoMoreData))success failure:(void (^)(FFError *error))failure
{
    FFTableCellDataContainer *donationContainer = (FFTableCellDataContainer *)[self.donationContainerCollection lastObject];
    NSUInteger maximumID = ((FFDataDonation *)donationContainer.data).donationID - 1;
    
    [FFRecordDonation retrievePastDonationsWithMaximumID:maximumID completion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
        if (isSuccess) {
            [self addDonationsToDonationContainerCollectionWithDonations:donations];
            if (success) { success([donations count] == 0); }
        }
        else {
            if (failure) { failure(error); }
        }
    }];
}

- (void)addDonationWithDataContainer:(FFTableCellDataContainer *)container
{
    [self.donationContainerCollection insertObject:container atIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FFPastDonationsNewDonationNotification"
                                                        object:nil
                                                      userInfo:@{@"indexPath": [NSIndexPath indexPathForRow:0 inSection:0]}];
}

- (void)replaceContainerContainingDonation:(FFDataDonation *)donation withDataContainer:(FFTableCellDataContainer *)container
{
    NSInteger index = [self.donationContainerCollection indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ((FFTableCellDataContainer *)obj).data == donation;
    }];
    
    if (index < 0) { return; }
    
    [self.donationContainerCollection replaceObjectAtIndex:index withObject:container];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FFPastDonationsUpdateDonationNotification"
                                                        object:nil
                                                      userInfo:@{@"indexPath": [NSIndexPath indexPathForRow:index inSection:0]}];
}

- (void)deleteContainerContainingDonation:(FFDataDonation *)donation
{
    NSInteger index = [self.donationContainerCollection indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ((FFTableCellDataContainer *)obj).data == donation;
    }];
    
    if (index < 0) { return; }
    
    [self.donationContainerCollection removeObjectAtIndex:index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FFPastDonationsDeleteDonationNotification"
                                                        object:nil
                                                      userInfo:@{@"indexPath": [NSIndexPath indexPathForRow:index inSection:0]}];
}

- (void)postSimilarDonationWithDonation:(FFDataDonation *)donation
{
    DebugLog(@"postSimilarDonationWithDonation:");
    
    [self.delegate didReceiveRequestToPostSimilarDonationWithDonation:donation];
}

@end
