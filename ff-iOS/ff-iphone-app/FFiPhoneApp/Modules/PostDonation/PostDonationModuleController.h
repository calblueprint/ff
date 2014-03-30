//
//  PostDonationModuleController.h
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModuleControllerProtocol.h"

@class AppDelegate, FFDataDonation, FFError, FFDataImage, FFDataLocation, POSDPostDonationViewController;

@protocol PostDonationModuleControllerDelegate <NSObject>

- (void)willPostDonation:(FFDataDonation *)donation andWillUploadMealPhoto:(UIImage *)mealPhoto;
- (void)            didPostDonation:(FFDataDonation *)donation
    andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
              andDidUploadMealPhoto:(UIImage *)mealPhoto
   andDidRetrievePersistedMealPhoto:(FFDataImage *)persistedMealPhoto;
- (void)didFailPostingDonation:(FFDataDonation *)donation andDidFailUploadingMealPhoto:(UIImage *)mealPhoto;
- (void)        didPostDonation:(FFDataDonation *)donation
andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
   butDidFailUploadingMealPhoto:(UIImage *)mealPhoto;
@end

@interface PostDonationModuleController : NSObject <ModuleControllerProtocol>

@property (weak, nonatomic) id <PostDonationModuleControllerDelegate> delegate;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) NSArray *userLocations;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) POSDPostDonationViewController *postDonationViewController;

- (UINavigationController *)instantiatePostDonationNavigationViewController;
- (void)    postDonation:(FFDataDonation *)donation
      andUploadMealPhoto:(UIImage *)mealPhoto
       didCreateLocation:(void (^)(FFDataLocation *location))didCreateLocationBlock
 didFailCreatingLocation:(void (^)(FFError *error))didFailCreatingLocationBlock
             postSuccess:(void (^)(FFDataDonation *donation))postSuccessBlock
             postFailure:(void (^)(FFError *error))postFailureBlock
           uploadSuccess:(void (^)(FFDataDonation *donation, FFDataImage *image))uploadSuccessBlock
           uploadFailure:(void (^)(FFDataDonation *donation, FFError *error))uploadFailureBlock;

- (void)willPostDonation:(FFDataDonation *)donation andWillUploadMealPhoto:(UIImage *)mealPhoto;
- (void)            didPostDonation:(FFDataDonation *)donation
    andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
              andDidUploadMealPhoto:(UIImage *)mealPhoto
   andDidRetrievePersistedMealPhoto:(FFDataImage *)persistedMealPhoto;
- (void)didFailPostingDonation:(FFDataDonation *)donation andDidFailUploadingMealPhoto:(UIImage *)mealPhoto;
- (void)        didPostDonation:(FFDataDonation *)donation
andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
   butDidFailUploadingMealPhoto:(UIImage *)mealPhoto;
- (void)prefillPostDonationFormWithDonation:(FFDataDonation *)donation;
- (void)saveUserLocationIfNotAlreadyExistedWithLocation:(FFDataLocation *)location;

@end
