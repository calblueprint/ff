//
//  POSDChooseLocationViewController.h
//  FFiPhoneApp
//
//  Created by lee on 8/3/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PostDonationBaseViewController.h"

#import <CoreLocation/CoreLocation.h>

@class MKMapView, FFDataLocation, POSDChooseLocationViewController;

@protocol POSDChooseLocationViewControllerDelegate <NSObject>

- (void)chooseLocationViewController:(POSDChooseLocationViewController *)controller didSelectLocation:(FFDataLocation *) location;

@end

@interface POSDChooseLocationViewController : PostDonationBaseViewController <CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) FFDataLocation *location;
@property (weak, nonatomic) id <POSDChooseLocationViewControllerDelegate> delegate;

@end
