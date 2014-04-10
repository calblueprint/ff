//
//  ModuleCoordinator.m
//  FFiPhoneApp
//
//  Created by lee on 7/28/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "ModuleCoordinator.h"

#import "AppDelegate.h"
#import "AppLoaderModuleController.h"
#import "AuthenticationModuleController.h"
#import "PostDonationModuleController.h"
#import "CurrentDonationsModuleController.h"
#import "PastDonationsModuleController.h"
#import "CURDDonationTableViewCell.h"
#import "AccountModuleController.h"
#import "SocialShareModuleController.h"

#import "Dashboard.h"

#import "FFKit.h"

@implementation ModuleCoordinator

+ (instancetype)initSharedCoordinator
{
    static ModuleCoordinator *sharedCoordinator = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedCoordinator = [[self alloc] init];
    });
    
    return sharedCoordinator;
}

+ (instancetype)sharedCoordinator
{
    return [self initSharedCoordinator];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        [self configureAppearance];
        
        // Keep a reference to app delegate
        [self setAppDelegate:[[UIApplication sharedApplication] delegate]];
        
        // Keep a reference to NSUserDefaults
        [self setUserDefaults:[NSUserDefaults standardUserDefaults]];
        
        // Initialize NSUserDefaults settings
        if (![self.userDefaults objectForKey:kUserDefaultsShareDonationPopupKey]) {
            [self.userDefaults setBool:YES forKey:kUserDefaultsShareDonationPopupKey];
            [self.userDefaults synchronize];
        }

        // Configure FFAPIClient and FFRecordObject
        [[FFAPIClient sharedClient] setAPIBaseURL:kAPIEndpointURL];
        [[FFAPIClient sharedClient] setAPIAuthToken:[self.userDefaults objectForKey:kUserDefaultsAuthTokenKey]];
        [FFRecordObject setSharedAPIClient:[FFAPIClient sharedClient]];
        
        //
        // Configure a response interception handler for FFAPIClient
        //
        [[FFAPIClient sharedClient] setIsEnableInterceptionHandler:YES];
        [[FFAPIClient sharedClient] setResponseInterceptionHandler:^BOOL(BOOL isSuccess, NSHTTPURLResponse *response, NSDictionary *responseJSON, NSString *errorMessage, void (^redoOperation)(void), void (^completionBlock)(BOOL isSuccess, NSDictionary *responseJSON, NSString *errorMessage)) {
            
            //
            // If the response is an unauthorized access message, present login view
            //
            if (isSuccess)
            {
                NSString *result = [responseJSON ff_objectForKey:@"result"];
                NSString *errorType = [responseJSON ff_objectForKey:@"type"];
                
                // Do nothing if the response is not what we expected
                if ([result isEqualToString:@"error"] == NO || [errorType isEqualToString:@"unauthorized_access"] == NO) {
                    return NO;
                }
                
                //
                // Skip certain modules
                //
                UIViewController *topMostViewController = [FFUI topViewControllerWithRootViewController:self.appDelegate.window.rootViewController];
                // Do nothing if the response is for AppLoader module
                if ([AppLoaderModuleController isModuleMemberWithViewController:topMostViewController]) {
                    return NO;
                }
                // Do nothing if the response is for Authentication module
                if ([AuthenticationModuleController isModuleMemberWithViewController:topMostViewController]) {
                    return NO;
                }

                /* Received unauthorized access message */
                
                //
                // Configure completion block for login view
                //
                AuthenticationModuleController *authenticationModuleController = [[AuthenticationModuleController alloc] initWithModuleCoordinator:self];
                [authenticationModuleController setCompletion:^(BOOL isSuccess, NSString *authToken, FFError *error) {

                    if (isSuccess) {
                        
                        /* User logged in */

                        // Save auth token
                        [self.userDefaults setValue:authToken forKey:kUserDefaultsAuthTokenKey];
                        [self.userDefaults synchronize];
                        
                        // Load user data
                        [self loadUserDataWithCompletion:^(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations) {
                            
                            // Configure dashbaord
                            self.tabBarController = [[Dashboard sharedDashboard] tabBarControllerWithUpdatedUser:user];

                            // Dismiss login view
                            [self.appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                                // Re-do current operation
                                redoOperation();
                            }];
                        }];
                    }
                    else {
                        
                        /* User not logged in */
                        
                        if (completionBlock)
                        {
                            NSString *errorDescription = error.errorDescription;
                            if (!errorDescription) {
                                errorDescription = @"You are not logged in. Please login and try again.";
                            }
                            completionBlock(YES, @{
                                    @"result": @"error",
                                    @"message": errorDescription
                            }, nil);
                        }
    
                        // Dismiss login view
                        [self.appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];

                // Present login view
                UIViewController *loginViewController = [authenticationModuleController instantiateLoginViewController];
                [self.appDelegate.window.rootViewController presentViewController:loginViewController animated:YES completion:nil];
                
                // Do not pass response back to the caller
                return YES;
            }
            else
            {
                /* Potential network errors occurred */
                
                if  (completionBlock)
                {
                    completionBlock(YES, @{
                            @"result": @"error",
                            @"message": @"A network error occurred. Please try again later."
                    }, nil);
                }

                // Do not pass response back to the caller
                return YES;
            }

            // Pass response back to the caller
            return NO;
        }];

        // Make AppLoader as the initial view
        AppLoaderModuleController *appLoaderModuleController = [[AppLoaderModuleController alloc] initWithModuleCoordinator:self];
        self.appDelegate.window.rootViewController = [appLoaderModuleController instantiateLoaderViewController];
        [self.appDelegate.window makeKeyAndVisible];

        // Load user data
        [self loadUserDataWithCompletion:^(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations) {
            
            // Configure dashbaord
            self.tabBarController = [[Dashboard sharedDashboard] instantiateTabBarControllerWithUser:user];

            // Change rootViewController to dashbaord with animation
            [UIView transitionFromView:self.appDelegate.window.rootViewController.view
                                toView:self.tabBarController.view
                              duration:0.65
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            completion:^(BOOL finished) {
                                self.appDelegate.window.rootViewController = self.tabBarController;
                            }];
        }];
    }

    return self;
}

- (void)configureAppearance
{
    // Set Navigation bar background image
//    [[UINavigationBar appearance]  setBackgroundImage:[UIImage imageNamed:kStyleNavigationBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
}

- (void)loadUserDataWithCompletion:(void (^)(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations))completion
{
    AppLoaderModuleController *appLoaderModuleController = [[AppLoaderModuleController alloc] initWithModuleCoordinator:self];
    [appLoaderModuleController loadUserDataWithCompletion:^(FFDataUser *user, NSArray *locations, NSArray *currentDonations, NSArray *pastDonations) {
        
        // The completion block should be invoked before other
        //   callbacks, so that changes within the block would
        //   be visible to the callbacks.
        if (completion) { completion(user, locations, currentDonations, pastDonations); }
        
        // Other callbacks
        if (user) { [self didRetrieveUser:user]; }
        if (locations) { [self didRetrieveLocations:locations]; }
        if (currentDonations) { [self didRetrieveCurrentDonations:currentDonations]; }
        if (pastDonations) { [self didRetrievePastDonations:pastDonations]; }
        
    }];
}

- (void)didRetrieveUser:(FFDataUser *)user
{
    DebugLog(@"Did retrieve user info");
    
    // Pass user to Account module
    Dashboard *dashboard = [Dashboard sharedDashboard];
    [dashboard.accountModuleController setUser:user];
}

- (void)didRetrieveLocations:(NSArray *)locations
{
    DebugLog(@"Did retrieve user locations");
    
    // Pass locations to PostDonation module
    Dashboard *dashboard = [Dashboard sharedDashboard];
    [dashboard.postDonationModuleController setUserLocations:locations];
}

- (void)didRetrieveCurrentDonations:(NSArray *)currentDonations;
{
    DebugLog(@"Did retrieve current donations");
    
    // Pass donations to CurrentDonations module
    Dashboard *dashboard = [Dashboard sharedDashboard];
    [dashboard.currentDonationsModuleController setDonationContainerCollectionWithDonations:currentDonations];
}

- (void)didRetrievePastDonations:(NSArray *)pastDonations;
{
    DebugLog(@"Did retrieve past donations");
    
    // Pass donations to PastDonations module
    Dashboard *dashboard = [Dashboard sharedDashboard];
    [dashboard.pastDonationsModuleController setDonationContainerCollectionWithDonations:pastDonations];
}

#pragma mark - AccountModuleControllerDelegate

- (void)didReceiveRequestToLogoutUserWithSender:(id)sender
{
    DebugLog(@"Did receive request to logout user");
    
    Dashboard *dashboard = [Dashboard sharedDashboard];
    
    [self.userDefaults removeObjectForKey:kUserDefaultsAuthTokenKey];
    [self.userDefaults synchronize];
    [[FFAPIClient sharedClient] setAPIAuthToken:nil];
    
    self.tabBarController = [dashboard tabBarControllerWithUpdatedUser:nil];
}

#pragma mark - AuthenticationModuleController called methods

- (void)didCreateAuthToken:(NSString *)authToken sender:(id)sender
{
    DebugLog(@"Did create auth token: %@", authToken);

    // Configure FFAPIClient to use authToken for API calls
    [[FFAPIClient sharedClient] setAPIAuthToken:authToken];
}

- (void)didFailCreatingAuthTokenWithError:(FFError *)error sender:(id)sender
{
    DebugLog(@"Did fail creating auth token");
}

- (void)didReceiveRequestToRemoveAuthToken:(NSString *)authToken sender:(id)sender
{
    DebugLog(@"Did receive request to remove auth token");
    
    [[FFAPIClient sharedClient] setAPIAuthToken:nil];
}

#pragma mark - PostDonationModuleControllerDelegate

- (void)willPostDonation:(FFDataDonation *)donation andWillUploadMealPhoto:(UIImage *)mealPhoto
{
    DebugLog(@"willPostDonation: andWillUploadMealPhoto:");
    
    FFTableCellDataContainer *donationConatiner = [[FFTableCellDataContainer alloc] initWithData:donation configureCellBlock:^(UITableViewCell *cell) {
        //
        // Configure cell's appearance
        //
        CURDDonationTableViewCell *donationCell = (CURDDonationTableViewCell *)cell;
        
        // Set cell's background color to light yellow
        [donationCell.contentView setBackgroundColor:[FFUI colorFromHexString:@"#FFFED4"]];
        
        // Show activity indicator
        [donationCell setAccessoryTypeAsActivityIndicator];
        
        // Disable selection style
        [donationCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Set status text to Pending
        [donationCell.labelStatusText setText:@"Pending"];
        
        // Set meal photo image if user provided one
        if (mealPhoto) {
            [donationCell.imageViewMealPhoto setImage:mealPhoto];
        }

    } didSelectRowBlock:^(UIViewController *viewController, UITableView *tableView, NSIndexPath *indexPath) {
        // Do nothing
    }];
    
    Dashboard *dashboard = [Dashboard sharedDashboard];
    
    // Switch tab to Active Donations
    dashboard.tabBarController.selectedIndex = 1;

    // Delay adding new donation to allow row animation on Active Donations's table view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        [dashboard.currentDonationsModuleController addDonationWithDataContainer:donationConatiner];
    });
    
    // Reset Post Donation form
    self.tabBarController = [dashboard tabBarControllerWithReloadedPostDonationView];
}

- (void)            didPostDonation:(FFDataDonation *)donation
    andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
              andDidUploadMealPhoto:(UIImage *)mealPhoto
   andDidRetrievePersistedMealPhoto:(FFDataImage *)persistedMealPhoto
{
    DebugLog(@"didPostDonation: andDidUploadMealPhoto:");
    
    // Donation and meal photo were created seperately, so persistedDonation won't
    //  contain any meal photo. Here we add persistedMealPhoto to persistedDonation
    //  to create a complete donation entry.
    [persistedDonation setMealPhoto:persistedMealPhoto];

    FFTableCellDataContainer *donationConatiner = [[FFTableCellDataContainer alloc] initWithData:persistedDonation configureCellBlock:nil didSelectRowBlock:nil];

    Dashboard *dashboard = [Dashboard sharedDashboard];
    
    // Replace existing donation with the one returned from backend (persistedDonation)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        // Delay current operation to make sure addDonationWithDataContainer is called first.
        [dashboard.currentDonationsModuleController replaceContainerContainingDonation:donation
                                                                    withDataContainer:donationConatiner];
    });
    
    // Save location
    [dashboard.postDonationModuleController saveUserLocationIfNotAlreadyExistedWithLocation:persistedDonation.location];
    
    // Show Share Donation view
    if ([[self.userDefaults objectForKey:kUserDefaultsShareDonationPopupKey] boolValue])
    {
        SocialShareModuleController *socialShareModuleController = [[SocialShareModuleController alloc] initWithModuleCoordinator:self];
        [socialShareModuleController setDonation:donation];
        [socialShareModuleController setMealPhoto:mealPhoto];
        UIViewController *shareDonationViewController = [socialShareModuleController instantiateShareDonationViewController];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
            [dashboard.tabBarController presentViewController:shareDonationViewController animated:YES completion:nil];
        });
    }
}

- (void)didFailPostingDonation:(FFDataDonation *)donation andDidFailUploadingMealPhoto:(UIImage *)mealPhoto
{
    DebugLog(@"didFailPostingDonation: andDidFailUploadingMealPhoto:");
    
    Dashboard *dashboard = [Dashboard sharedDashboard];
    
    FFTableCellDataContainer *donationConatiner = [[FFTableCellDataContainer alloc] initWithData:donation configureCellBlock:^(UITableViewCell *cell) {
        //
        // Configure cell's appearance
        //
        CURDDonationTableViewCell *donationCell = (CURDDonationTableViewCell *)cell;
        
        // Set cell's background color to light red
        [donationCell.contentView setBackgroundColor:[FFUI colorFromHexString:@"#FFD4D4"]];
        
        // Do not show any cell accessory
        [donationCell setAccessoryTypeAsNone];
        
        // Disable selection style
        [donationCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Set status text
        [donationCell.labelStatusText setText:@"Failed to post donation, tap to retry"];
        
        [donationCell setUserInteractionEnabled:YES];
        
    } didSelectRowBlock:^(UIViewController *viewController, UITableView *tableView, NSIndexPath *indexPath) {
        //
        // Re-post donation
        //
        CURDDonationTableViewCell *donationCell = (CURDDonationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

        // Set cell's background color to light yellow
        [donationCell.contentView setBackgroundColor:[FFUI colorFromHexString:@"#FFFED4"]];
        
        // Show activity indicator
        [donationCell setAccessoryTypeAsActivityIndicator];

        // Set status text to Pending
        [donationCell.labelStatusText setText:@"Pending"];

        // Prevent multiple taps
        [donationCell setUserInteractionEnabled:NO];
        
        if (mealPhoto)
        {
            [dashboard.postDonationModuleController postDonation:donation andUploadMealPhoto:mealPhoto
             didCreateLocation:nil
             didFailCreatingLocation:^(FFError *error) {
                 [self didFailPostingDonation:          donation
                       andDidFailUploadingMealPhoto:    mealPhoto];
             }
             postSuccess:nil
             postFailure:^(FFError *error) {
                 [self didFailPostingDonation:          donation
                       andDidFailUploadingMealPhoto:    mealPhoto];
             }
             uploadSuccess:^(FFDataDonation *persistedDonation, FFDataImage *persistedMealPhoto) {
                 [self didPostDonation:                     donation
                       andDidRetrievePersistedDonation:     persistedDonation
                       andDidUploadMealPhoto:               mealPhoto
                       andDidRetrievePersistedMealPhoto:    persistedMealPhoto];
             }
             uploadFailure:^(FFDataDonation *persistedDonation, FFError *error) {
                 [self didPostDonation:                     donation
                       andDidRetrievePersistedDonation:     persistedDonation
                       butDidFailUploadingMealPhoto:        mealPhoto];
           }];
        }
        else
        {
            [dashboard.postDonationModuleController postDonation:donation andUploadMealPhoto:nil
             didCreateLocation:nil
             didFailCreatingLocation:^(FFError *error) {
                 [self didFailPostingDonation:donation
                       andDidFailUploadingMealPhoto:nil];
             }
             postSuccess:^(FFDataDonation *persistedDonation) {
                 [self didPostDonation:                     donation
                       andDidRetrievePersistedDonation:     persistedDonation
                       andDidUploadMealPhoto:               nil
                       andDidRetrievePersistedMealPhoto:    nil];
             }
             postFailure:^(FFError *error) {
                 [self didFailPostingDonation:          donation
                       andDidFailUploadingMealPhoto:    nil];
             }
             uploadSuccess:nil
             uploadFailure:nil];
        }
    }];

    // Change donation cell's appearance to reflect its failed status
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        // Delay current operation to make sure addDonationWithDataContainer is called first.
        //
        // Note: if it failed to create location for the donation,
        //       "willPostDonation: andWillUploadMealPhoto:" won't be called (so is addDonationWithDataContainer).
        //       In that case, 'donation' won't exist in currentDonations' donationContainerCollection,
        //       and thus replaceContainerContainingDonation would do nothing.
        [dashboard.currentDonationsModuleController replaceContainerContainingDonation:donation
                                                                    withDataContainer:donationConatiner];
    });
}

- (void)        didPostDonation:(FFDataDonation *)donation
andDidRetrievePersistedDonation:(FFDataDonation *)persistedDonation
   butDidFailUploadingMealPhoto:(UIImage *)mealPhoto
{
    DebugLog(@"didPostDonation: butDidFailUploadingMealPhoto:");
    
    // If failed to upload meal photo, we ignore it and move on.
    [self           didPostDonation:donation
    andDidRetrievePersistedDonation:persistedDonation
              andDidUploadMealPhoto:nil
   andDidRetrievePersistedMealPhoto:nil];
}

#pragma mark - PastDonationsModuleControllerDelegate

- (void)didReceiveRequestToPostSimilarDonationWithDonation:(FFDataDonation *)donation
{
    DebugLog(@"didReceiveRequestToPostSimilarDonationWithDonation:");
    
    Dashboard *dashboard = [Dashboard sharedDashboard];

    // Remove donationDescription's default text if needed
    if ([donation.donationDescription isEqualToString:@"No Description"]) {
        // "No Description" is the default text generated by backend when
        //  user did not enter any description.
        [donation setDonationDescription:@""];
    }

    // Prefill Post Donation form
    //[dashboard.postDonationModuleController prefillPostDonationFormWithDonation:donation];
    
    // Switch to Post Donation view
    self.tabBarController.selectedIndex = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        [dashboard.postDonationModuleController prefillPostDonationFormWithDonation:donation];
    });
}

@end
