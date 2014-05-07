//
//  CURDCurrentDonationsViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "CURDCurrentDonationsViewController.h"
#import "CURDDonationTableViewCell.h"
#import "CURDDonationDetailsViewController.h"

#import "CurrentDonationsModuleController.h"
#import "CurrentDonationsConstants.h"

#import "UIImageView+AFNetworking.h"

#import "FFKit.h"

@interface CURDCurrentDonationsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableViewCurrentDonations;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIView *viewTableViewFooter;

@end

@implementation CURDCurrentDonationsViewController
{
	UITableViewController *_tableViewController;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
		self.edgesForExtendedLayout = UIRectEdgeNone;
	
	// Setup table view footer (for use with inifinite scrolling)
	self.tableViewCurrentDonations.tableFooterView = self.viewTableViewFooter;
	[self.viewTableViewFooter setHidden:YES];
	
	//
	// Setup Refresh Control on tableViewCurrentDonations
	//   (for enabling pull-to-refresh)
	//
	_tableViewController = [[UITableViewController alloc] init];
	_tableViewController.tableView = self.tableViewCurrentDonations;
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refreshControl_onValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self updateRefreshControlLastUpdatedText];
	_tableViewController.refreshControl = self.refreshControl;
	
	// Register to receive notification for newly added active donation
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(didReceiveFFCurrentDonationsNewDonationNotification:)
																							 name:@"FFCurrentDonationsNewDonationNotification" object:nil];
	// Register to receive notification for newly updated donation
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(didReceiveFFCurrentDonationsUpdateDonationNotification:)
																							 name:@"FFCurrentDonationsUpdateDonationNotification" object:nil];
	// Register to receive notification for newly deleted donation
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(didReceiveFFCurrentDonationsDeleteDonationNotification:)
																							 name:@"FFCurrentDonationsDeleteDonationNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)didReceiveFFCurrentDonationsNewDonationNotification:(NSNotification*)notification
{
	DebugLog(@"didReceiveFFCurrentDonationsNewDonationNotification");
	
	NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
	NSArray *indexArray = @[indexPath];
	
	// Scroll table view to the top row
	if ([self.tableViewCurrentDonations numberOfRowsInSection:0] > 0) {
		[self.tableViewCurrentDonations scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
																					atScrollPosition:UITableViewScrollPositionTop
																									animated:NO];
	}
	
	[self.tableViewCurrentDonations insertRowsAtIndexPaths:indexArray withRowAnimation:YES];
}

- (void)didReceiveFFCurrentDonationsUpdateDonationNotification:(NSNotification*)notification
{
	DebugLog(@"didReceiveFFCurrentDonationsUpdateDonationNotification");
	
	NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
	NSArray *indexArray = @[indexPath];
	
	[self.tableViewCurrentDonations reloadRowsAtIndexPaths:indexArray withRowAnimation:NO];
}

- (void)didReceiveFFCurrentDonationsDeleteDonationNotification:(NSNotification*)notification
{
	DebugLog(@"didReceiveFFCurrentDonationsDeleteDonationNotification");
	
	NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
	NSArray *indexArray = @[indexPath];
	
	[self.tableViewCurrentDonations deleteRowsAtIndexPaths:indexArray withRowAnimation:YES];
}

- (void)updateRefreshControlLastUpdatedText
{
	NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [[NSDate date] ff_stringWithFormat:@"MMMM d, h:mm a"]];
	self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

- (void)refreshControl_onValueChanged:(id)sender
{
	[self.moduleController reloadCurrentDonationsWithSuccess:^{
		[self.tableViewCurrentDonations reloadData];
		[self updateRefreshControlLastUpdatedText];
		[self.refreshControl endRefreshing];
		self.tableViewCurrentDonations.tableFooterView = self.viewTableViewFooter;
		[self.viewTableViewFooter setHidden:YES];
	} failure:^(FFError *error) {
		[FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
		[self.refreshControl endRefreshing];
	}];
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView
{
	if (tableView.contentOffset.y > 0)
	{
		[self.viewTableViewFooter setHidden:NO];
		[self.moduleController loadMoreCurrentDonationsWithSuccess:^(BOOL isNoMoreData){
			[self.viewTableViewFooter setHidden:YES];
			[self.tableViewCurrentDonations reloadData];
			if (isNoMoreData) {
//				// Create a label as the table view's footer to inform user
//				//  that there are no more data
//				UIView *v = self.tableViewCurrentDonations.tableFooterView;
//				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(v.frame.origin.x,
//																																	 v.frame.origin.y,
//																																	 v.frame.size.width,
//																																	 v.frame.size.height)];
//				[label setText:@"No more donations"];
//				[label setTextAlignment:NSTextAlignmentCenter];
//				[label setTextColor:[UIColor lightGrayColor]];
//				[label setFont:[UIFont fontWithName:@"Verdana-Bold" size:12.0f]];
//				[label setBackgroundColor:self.tableViewCurrentDonations.tableFooterView.backgroundColor];
//				
//				self.tableViewCurrentDonations.tableFooterView = label;
			}
		} failure:^(FFError *error) {
			[FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
		}];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//
	// Display a placeholder message when the table view is empty
	//
//	if ([self.moduleController.donationContainerCollection count] == 0) {
//		UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kStyleDonationTablePlaceholderImage]];
//		[placeholderImageView setContentMode:UIViewContentModeScaleAspectFill];
//		[self.tableViewCurrentDonations setBackgroundView:placeholderImageView];
//	}
//	else {
//		[self.tableViewCurrentDonations setBackgroundView:nil];
//	}
//	
	return 3;
	//    return [self.moduleController.donationContainerCollection count];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"CURDDonationTableViewCell";
	CURDDonationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 
	FFDataDonation *donation = [self testDonationForIndex:[indexPath row]];
	cell.labelDonationTitle.text = donation.donationTitle;
	cell.imageViewMealPhoto.contentMode = UIViewContentModeScaleAspectFill;
	cell.labelDonationTitle.font = [UIFont fontWithName:@"ProximaNovaA-Regular" size:20.0];
	cell.labelStatusText.font = [UIFont fontWithName:@"ProximaNovaA-Regular" size:16.0];
	cell.labelTotalLBS.font = [UIFont fontWithName:@"ProximaNovaA-Regular" size:14.0];
	[cell.imageViewMealPhoto setImage:[UIImage imageNamed:donation.mealPhoto.imageURL]];
	[cell.imageViewMealPhoto setClipsToBounds:YES];
	
//	FFTableCellDataContainer *donationContainer = [self.moduleController.donationContainerCollection objectAtIndex:indexPath.row];
//	FFDataDonation *donation = (FFDataDonation *)donationContainer.data;
	
	// Configure the data shown in cell
//	[cell.labelDonationTitle setText:donation.donationTitle];
//	[cell.labelStatusText setText:donation.statusText];
//	[cell.labelTotalLBS setText:[NSString stringWithFormat:@"%u pounds", donation.totalLBS]];
	
	// Show meal photo
	// Configure cell's appearance
//	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
//	[cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
//	[cell.selectedBackgroundView setBackgroundColor:[FFUI colorFromHexString:@"#2998B2"]];
//	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
//	[cell setAccessoryTypeAsDisclosureIndicator];
//	[cell setUserInteractionEnabled:YES];
	
	// Apply custom configuration
//	if (donationContainer.configureCell) {
//		donationContainer.configureCell(cell);
//	}
	
	return cell;
}

- (FFDataDonation *) testDonationForIndex:(int)index {
	FFDataDonation *donation = [[FFDataDonation alloc] init];
	FFDataImage *dataImage = [[FFDataImage alloc] init];
	donation.mealPhoto = dataImage;
	switch (index) {
		case 0:
			donation.donationTitle = @"Cake";
			dataImage.imageURL = @"cake.jpg";
			break;
		case 1:
			donation.donationTitle = @"Pie";
			dataImage.imageURL = @"pie.jpeg";
			break;
		case 2:
			donation.donationTitle = @"Cookies";
			dataImage.imageURL = @"cookie.jpg";
			break;
		default:
			break;
	}
	return donation;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	FFTableCellDataContainer *donationContainer = [self.moduleController.donationContainerCollection objectAtIndex:indexPath.row];
//	if (donationContainer.didSelectRowBlock) {
//		donationContainer.didSelectRowBlock(self, tableView, indexPath);
//	}
//	else {
//		[tableView deselectRowAtIndexPath:indexPath animated:YES];
//		
//		// Present donation details
//		CURDDonationDetailsViewController *viewController = [self.moduleController.storyboard instantiateViewControllerWithIdentifier:@"CURDDonationDetailsViewController"];
//		[viewController setModuleController:self.moduleController];
//		[viewController setCurrentDonationsViewController:self];
//		[viewController setDonation:donationContainer.data];
//		[self.navigationController pushViewController:viewController animated:YES];
//	}
}

@end
