//
//  CurrentDonationsModuleController.m
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "CurrentDonationsModuleController.h"
#import "CurrentDonationsBaseViewController.h"
#import "CurrentDonationsConstants.h"

#import "FFKit.h"

@implementation CurrentDonationsModuleController
{
    __weak ModuleCoordinator *_moduleCoordinator;
}

//
// Module protocol methods
//

+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return [viewController isKindOfClass:[CurrentDonationsBaseViewController class]];
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.

        _moduleCoordinator = moduleCoordinator;
         self.storyboard = [UIStoryboard storyboardWithName:kCurrentDonationsStoryboardName bundle:nil];
    }

    return self;
}

//----------------------

- (UINavigationController *)instantiateCurrentDonationsNavigationViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"CURDNavigationController"];
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

- (void)reloadCurrentDonationsWithSuccess:(void (^)(void))success failure:(void (^)(FFError *error))failure
{
    [FFRecordDonation retrieveCurrentDonationsWithMaximumID:-1 completion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
        if (isSuccess) {
            [self setDonationContainerCollectionWithDonations:donations];
            if (success) { success(); }
        }
        else {
            if (failure) { failure(error); }
        }
    }];
}

- (void)loadMoreCurrentDonationsWithSuccess:(void (^)(BOOL isNoMoreData))success failure:(void (^)(FFError *error))failure
{
    FFTableCellDataContainer *donationContainer = (FFTableCellDataContainer *)[self.donationContainerCollection lastObject];
    NSUInteger maximumID = ((FFDataDonation *)donationContainer.data).donationID - 1;
    
    [FFRecordDonation retrieveCurrentDonationsWithMaximumID:maximumID completion:^(BOOL isSuccess, NSArray *donations, FFError *error) {
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FFCurrentDonationsNewDonationNotification"
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FFCurrentDonationsUpdateDonationNotification"
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FFCurrentDonationsDeleteDonationNotification"
                                                        object:nil
                                                      userInfo:@{@"indexPath": [NSIndexPath indexPathForRow:index inSection:0]}];
}

@end
