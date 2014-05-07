//
//  POSDChooseLocationViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/3/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "POSDChooseLocationViewController.h"

#import "PostDonationModuleController.h"

#import "FFKit.h"

#import <MapKit/MapKit.h>

@interface POSDChooseLocationViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarDisplayController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonUseThisLocation;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonLocateMe;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *currentLocationAddressDictionary;

- (IBAction)buttonLocateMe_selector:(id)sender;
- (IBAction)buttonUseThisLocation_selector:(id)sender;
- (IBAction)buttonBack_onTouchUpInside:(id)sender;

@end

@implementation POSDChooseLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // Set up map view
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];

    // Setup location manager
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDelegate:self];
    
    // Setup search display controller
    [self setSearchBarDisplayController:[[UISearchDisplayController alloc]
                                         initWithSearchBar:self.searchBar contentsController:self]];
    [self.searchBarDisplayController setDelegate:self];
    [self.searchBarDisplayController setSearchResultsDataSource:(id)self];
    [self.searchBarDisplayController setSearchResultsDelegate:(id)self];
  
    // Start locating the user immeidately
    if (!self.currentLocationAddressDictionary) {
        [self.locationManager startUpdatingLocation];
    }
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLocateMe_selector:(id)sender
{
    [self.locationManager startUpdatingLocation];
}

- (IBAction)buttonUseThisLocation_selector:(id)sender
{
    // If the current address does not contain 'Street' field, we treat it as invalid.
    if (![self.currentLocationAddressDictionary ff_objectForKey:@"Street"]) {
        [FFUI showPopupMessageWithTitle:@"Invalid Address" message:@"Address should include street name and street number"];
        return;
    }
    
    [self setLocationWithAddressDictionary:self.currentLocationAddressDictionary];
		[self.delegate chooseLocationViewController:self didSelectLocation:self.location];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonBack_onTouchUpInside:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
}

//
// Retrieve address infomration from addressDictionary and save it into self.location
//
// @param addressDictionary The dictionary returned by [CLPlacemark addressDictionary], and we assume the address is in U.S. format.
//
- (void)setLocationWithAddressDictionary:(NSDictionary *)addressDictionary
{
    NSArray *addressLines = [addressDictionary ff_objectForKey:@"FormattedAddressLines"];
    NSString *streetAddressOne = [addressDictionary ff_objectForKey:@"Street"];
    NSString *streetAddressTwo = nil;
    NSString *city = [addressDictionary ff_objectForKey:@"City"];
    NSString *state = [addressDictionary ff_objectForKey:@"State"];
    NSString *zipCode = [addressDictionary ff_objectForKey:@"ZIP"];
    
    //
    // Get Street Address 2 from addressLines if it exists
    //
    for (int i=0; i<[addressLines count]; i++) {
        
        // If addressLines[i] is street address 1 and there are more than 2 address lines after it,
        //  then we assume addressLines[i+1] is street address 2. (Note: this assumption is only
        //  valid for addresses in U.S. format.)
        if ([addressLines[i] isEqualToString:streetAddressOne] && ([addressLines count]-(i+1)) > 2) {
            streetAddressTwo = addressLines[i+1];
            break;
        }
    }

    //
    // Save address into self.location
    //
    [self.location setStreetAddressOne:streetAddressOne];
    [self.location setStreetAddressTwo:streetAddressTwo];
    [self.location setCity:city];
    [self.location setState:state];
    [self.location setZipCode:zipCode];
}

//
// Create a MKPointAnnotation from address dictionary
//
// @param addressDictionary The dictionary returned by [CLPlacemark addressDictionary], and we assume the address is in U.S. format.
//
- (MKPointAnnotation *)annotationWithAddressDictionary:(NSDictionary *)addressDictionary
{
    NSArray *addressLines = [addressDictionary ff_objectForKey:@"FormattedAddressLines"];
    
    if ([addressLines count] < 2) {
        // Address is probably not in U.S. format
        return nil;
    }

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    // Use street address 1 as title
    [annotation setTitle:[addressLines ff_objectAtIndex:0]];
    
    //
    // Construct the address string by concatenating all lines but the first and last one in addressLines
    //
    NSMutableString *addressWithoutStreetOneAndCountry =[NSMutableString stringWithString:[addressLines ff_objectAtIndex:1]];
    for (int i=2; i<[addressLines count]-1; i++) {
        [addressWithoutStreetOneAndCountry appendString:[NSString stringWithFormat:@", %@", addressLines[i]]];
    }

    [annotation setSubtitle:addressWithoutStreetOneAndCountry];

    return annotation;
}

//
// Search for a location by text
//
- (void)searchAddressByText:(NSString *)text
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:text completionHandler:^(NSArray *placemarks, NSError *error) {

        if (!error)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            MKCoordinateRegion region = { {0.0,0.0}, {0.0,0.0} };
            
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span.latitudeDelta = 0.007f;
            region.span.longitudeDelta = 0.007f;
            
            [self.mapView setRegion:region animated:YES];
            [self setCurrentLocationAddressDictionary:placemark.addressDictionary];
            
            DebugLog(@"placemark.addressDictionary: %@", placemark.addressDictionary);
            
            // Display placemark's address on map with an annotation
            MKPointAnnotation *annotation = [self annotationWithAddressDictionary:placemark.addressDictionary];
            if (annotation) {
                [annotation setCoordinate:placemark.location.coordinate];
                [self.mapView removeAnnotations:self.mapView.annotations];
                [self.mapView addAnnotation:annotation];
                [self.mapView selectAnnotation:annotation animated:YES];
            }
        }
        else {
            DebugLog(@"geocodeAddressString failed.");
        }
    }];
}


#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    MKCoordinateRegion region = { {0.0,0.0}, {0.0,0.0} };
    
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.latitudeDelta = 0.007f;
    region.span.longitudeDelta = 0.007f;
    
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];

    //
    // Display the current address on map
    //
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            [self setCurrentLocationAddressDictionary:placemark.addressDictionary];
            
            DebugLog(@"placemark.addressDictionary: %@", placemark.addressDictionary);
            
            // Display placemark's address on map with an annotation
            MKPointAnnotation *annotation = [self annotationWithAddressDictionary:placemark.addressDictionary];
            if (annotation) {
                [annotation setCoordinate:placemark.location.coordinate];
                [self.mapView removeAnnotations:self.mapView.annotations];
                [self.mapView addAnnotation:annotation];
                [self.mapView selectAnnotation:annotation animated:YES];
            }
        }
        else {
            DebugLog(@"reverseGeocodeLocation failed.");
        }
        
    }];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchBarDisplayController.searchResultsTableView) {
        return [self.moduleController.userLocations count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LocationSearchBarTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
    }

    FFDataLocation *location = [self.moduleController.userLocations ff_objectAtIndex:indexPath.row];
    [cell.textLabel setText:[location formattedAddress]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFDataLocation *location = [self.moduleController.userLocations ff_objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar setText:[location formattedAddress]];
    [self.searchBar.delegate searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchAddressByText:[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\0"]]];

    [searchBar resignFirstResponder];
    [self.searchBarDisplayController setActive:NO animated:YES];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    // Set text to trigger result table view to be shown
    [controller.searchBar setText:@"\0"];
}

@end
