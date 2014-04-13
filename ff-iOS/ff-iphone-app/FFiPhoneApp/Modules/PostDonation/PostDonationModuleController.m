//
//  PostDonationModuleController.m
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PostDonationModuleController.h"
#import "PostDonationConstants.h"
#import "PostDonationBaseViewController.h"
#import "POSDNavigationController.h"
#import "AppDelegate.h"
#import "POSDPostDonationViewController.h"

#import "FFKit.h"

@implementation PostDonationModuleController
{
    __weak ModuleCoordinator *_moduleCoordinator;
}

//
// Module protocol methods
//
+ (BOOL)isModuleMemberWithViewController:(id)viewController
{
    return ([viewController isKindOfClass:[PostDonationBaseViewController class]] || [viewController isMemberOfClass:[POSDNavigationController class]]);
}

- (id)initWithModuleCoordinator:(ModuleCoordinator *)moduleCoordinator
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        _moduleCoordinator = moduleCoordinator;
        self.storyboard = [UIStoryboard storyboardWithName:kPostDonationStoryboardName bundle:nil];
    }
    
    return self;
}

// ------------------------

- (UINavigationController *)instantiatePostDonationNavigationViewController
{
    id viewController = [_storyboard instantiateViewControllerWithIdentifier:@"POSDNavigationController"];
    [viewController setModuleController:self];
		self.navigationController = viewController;
	 self.postDonationViewController = [_storyboard instantiateViewControllerWithIdentifier:@"POSDPostDonationViewController"];
	[self.navigationController pushViewController:self.postDonationViewController animated:NO];
    return viewController;
}



- (void)    postDonation:(FFDataDonation *)donation
      andUploadMealPhoto:(UIImage *)mealPhoto
       didCreateLocation:(void (^)(FFDataLocation *location))didCreateLocationBlock
 didFailCreatingLocation:(void (^)(FFError *error))didFailCreatingLocationBlock
             postSuccess:(void (^)(FFDataDonation *donation))postSuccessBlock
             postFailure:(void (^)(FFError *error))postFailureBlock
           uploadSuccess:(void (^)(FFDataDonation *donation, FFDataImage *image))uploadSuccessBlock
           uploadFailure:(void (^)(FFDataDonation *donation, FFError *error))uploadFailureBlock
{
    // Create location
    [[FFRecordLocation initWithModelObject:donation.location] createWithCompletion:^(BOOL isSuccess, FFDataLocation *location, FFError *error) {
        if (isSuccess)
        {
            DebugLog(@"Succeed to create location");
            if (didCreateLocationBlock) { didCreateLocationBlock(location); }
            
            // Create donation
            FFRecordDonation *record = [FFRecordDonation initWithModelObject:donation];
            [record setLocationID:location.locationID];
            [record createWithCompletion:^(BOOL isSuccess, FFDataDonation *donation, FFError *error) {
                if (isSuccess) {
                    DebugLog(@"Succeed to create donation");
                    if (postSuccessBlock) { postSuccessBlock(donation); }
                    
                    // Upload meal photo if user provided one
                    if (mealPhoto)
                    {
                        [[FFRecordMealPhoto initWithImage:mealPhoto andDonation:donation] createWithCompletion:^(BOOL isSuccess, FFDataImage *image, FFError *error) {
                            if (isSuccess) {
                                DebugLog(@"Succeed to upload meal photo");
                                
                                if (uploadSuccessBlock) { uploadSuccessBlock(donation, image); }
                            }
                            else {
                                DebugLog(@"Failed to upload meal photo");
                                if (uploadFailureBlock) { uploadFailureBlock(donation, error); }
                            }
                        }];
                    }
                }
                else {
                    DebugLog(@"Failed to create donation");
                    if (postFailureBlock) { postFailureBlock(error); }
                }
            }];
        }
        else {
            DebugLog(@"Failed to create location");
            if (didFailCreatingLocationBlock) { didFailCreatingLocationBlock(error); }
        }
    }];
}

- (void)willPostDonation:(FFDataDonation *)donation andWillUploadMealPhoto:(UIImage *)mealPhoto
{
    [self.delegate willPostDonation:donation andWillUploadMealPhoto:mealPhoto];
}

- (void)            didPostDonation:(FFDataDonation *)donation
    andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
              andDidUploadMealPhoto:(UIImage *)mealPhoto
   andDidRetrievePersistedMealPhoto:(FFDataImage *)persistedMealPhoto
{
    [self.delegate didPostDonation:donation
     andDidRetrievePersistedDonation:persistedDonation
             andDidUploadMealPhoto:mealPhoto
  andDidRetrievePersistedMealPhoto:persistedMealPhoto];
}

- (void)didFailPostingDonation:(FFDataDonation *)donation andDidFailUploadingMealPhoto:(UIImage *)mealPhoto
{
    [self.delegate didFailPostingDonation:donation andDidFailUploadingMealPhoto:mealPhoto];
}

- (void)        didPostDonation:(FFDataDonation *)donation
andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
   butDidFailUploadingMealPhoto:(UIImage *)mealPhoto
{
    [self.delegate didPostDonation:donation
     andDidRetrievePersistedDonation:persistedDonation
      butDidFailUploadingMealPhoto:mealPhoto];
}

- (void)prefillPostDonationFormWithDonation:(FFDataDonation *)donation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FFPostDonationPrefillPostDonationFormNotification"
                                                        object:nil
                                                      userInfo:@{@"donation": donation}];
}

- (void)saveUserLocationIfNotAlreadyExistedWithLocation:(FFDataLocation *)location
{
    NSInteger locationIndexInUserLocations = [self.userLocations indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ((FFDataLocation *)obj).locationID == location.locationID;
    }];
    
    if (locationIndexInUserLocations == NSNotFound) {
        [(NSMutableArray *)self.userLocations insertObject:location atIndex:0];
    }
}

@end
