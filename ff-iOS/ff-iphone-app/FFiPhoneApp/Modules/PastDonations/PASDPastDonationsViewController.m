//
//  PASDPastDonationsViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/12/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "PASDPastDonationsViewController.h"
#import "PASDDonationTableViewCell.h"

#import "PastDonationsModuleController.h"
#import "PastDonationsConstants.h"

#import "UIImageView+AFNetworking.h"

#import "FFKit.h"

@interface PASDPastDonationsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableViewPastDonations;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIView *viewTableViewFooter;

- (IBAction)buttonPostSimilar_onTouchUpInside:(id)sender;

@end

@implementation PASDPastDonationsViewController
{
    UITableViewController *_tableViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Setup table view footer (for use with inifinite scrolling)
    self.tableViewPastDonations.tableFooterView = self.viewTableViewFooter;
    [self.viewTableViewFooter setHidden:YES];
    
    //
    // Setup Refresh Control on tableViewPastDonations
    //   (for enabling pull-to-refresh)
    //
    _tableViewController = [[UITableViewController alloc] init];
    _tableViewController.tableView = self.tableViewPastDonations;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControl_onValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self updateRefreshControlLastUpdatedText];
    _tableViewController.refreshControl = self.refreshControl;
    
    // Register to receive notification for newly added active donation
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveFFPastDonationsNewDonationNotification:)
                                                 name:@"FFPastDonationsNewDonationNotification" object:nil];
    // Register to receive notification for newly updated donation
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveFFPastDonationsUpdateDonationNotification:)
                                                 name:@"FFPastDonationsUpdateDonationNotification" object:nil];
    // Register to receive notification for newly deleted donation
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveFFPastDonationsDeleteDonationNotification:)
                                                 name:@"FFPastDonationsDeleteDonationNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPostSimilar_onTouchUpInside:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewPastDonations];
    NSIndexPath *indexPath = [self.tableViewPastDonations indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        FFTableCellDataContainer *donationContainer = [self.moduleController.donationContainerCollection objectAtIndex:indexPath.row];
        [self.moduleController postSimilarDonationWithDonation:donationContainer.data];
    }
}

- (void)didReceiveFFPastDonationsNewDonationNotification:(NSNotification*)notification
{
    DebugLog(@"didReceiveFFPastDonationsNewDonationNotification");
    
    NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
    NSArray *indexArray = @[indexPath];
    
    [self.tableViewPastDonations insertRowsAtIndexPaths:indexArray withRowAnimation:YES];
}

- (void)didReceiveFFPastDonationsUpdateDonationNotification:(NSNotification*)notification
{
    DebugLog(@"didReceiveFFPastDonationsUpdateDonationNotification");
    
    NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
    NSArray *indexArray = @[indexPath];
    
    [self.tableViewPastDonations reloadRowsAtIndexPaths:indexArray withRowAnimation:NO];
}

- (void)didReceiveFFPastDonationsDeleteDonationNotification:(NSNotification*)notification
{
    DebugLog(@"didReceiveFFPastDonationsDeleteDonationNotification");
    
    NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
    NSArray *indexArray = @[indexPath];
    
    [self.tableViewPastDonations deleteRowsAtIndexPaths:indexArray withRowAnimation:YES];
}

- (void)updateRefreshControlLastUpdatedText
{
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [[NSDate date] ff_stringWithFormat:@"MMMM d, h:mm a"]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

- (void)refreshControl_onValueChanged:(id)sender
{
    [self.moduleController reloadPastDonationsWithSuccess:^{
        [self.tableViewPastDonations reloadData];
        [self updateRefreshControlLastUpdatedText];
        [self.refreshControl endRefreshing];
        // Reset table view footer
        self.tableViewPastDonations.tableFooterView = self.viewTableViewFooter;
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
        [self.moduleController loadMorePastDonationsWithSuccess:^(BOOL isNoMoreData){
            [self.viewTableViewFooter setHidden:YES];
            [self.tableViewPastDonations reloadData];
            if (isNoMoreData) {
                // Create a label as the table view's footer to inform user
                //  that there are no more data
                UIView *v = self.tableViewPastDonations.tableFooterView;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(v.frame.origin.x,
                                                                           v.frame.origin.y,
                                                                           v.frame.size.width,
                                                                           v.frame.size.height)];
                [label setText:@"No more donations"];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setTextColor:[UIColor lightGrayColor]];
                [label setFont:[UIFont fontWithName:@"Verdana-Bold" size:12.0f]];
                [label setBackgroundColor:self.tableViewPastDonations.tableFooterView.backgroundColor];

                self.tableViewPastDonations.tableFooterView = label;
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
    if ([self.moduleController.donationContainerCollection count] == 0) {
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kStyleDonationTablePlaceholderImage]];
        [placeholderImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.tableViewPastDonations setBackgroundView:placeholderImageView];
    }
    else {
        [self.tableViewPastDonations setBackgroundView:nil];
    }

    return [self.moduleController.donationContainerCollection count];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PASDDonationTableViewCell";
    PASDDonationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    FFTableCellDataContainer *donationContainer = [self.moduleController.donationContainerCollection objectAtIndex:indexPath.row];
    FFDataDonation *donation = (FFDataDonation *)donationContainer.data;
    
    // Configure the data shown in cell
    [cell.labelDonationTitle setText:donation.donationTitle];
    if (donation.statusCode == 2) {
        [cell.labelStatusText setText:donation.statusText];
    }
    else {
        [cell.labelStatusText setText:@"Expired"];
    }
    [cell.labelTotalLBSAndAddress setText:[NSString stringWithFormat:@"%u lbs at %@", donation.totalLBS, [donation.location formattedAddress]]];
    [cell.labelAvailableDate setText:[donation.availableStart ff_stringWithFormat:@"MMM d"]];
    [cell.labelDescription setText:donation.donationDescription];
    
    // Show meal photo
    if (donation.mealPhoto)
    {
        // Try to load meal photo from image store
        UIImage *mealPhotoLargeImage = [[FFImageStore sharedStore] imageForKey:donation.mealPhoto.imageURL];
        
        // If the image store doesn't have it, download it asynchronously.
        if (!mealPhotoLargeImage)
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:donation.mealPhoto.imageURL]];
            __weak __typeof(&*cell)weakCell = cell;
            [cell.imageViewMealPhoto setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                __strong __typeof(&*weakCell)strongCell = weakCell;
                
                // Save the downloaded image into image store
                [[FFImageStore sharedStore] setImage:image forKey:donation.mealPhoto.imageURL];
                // Show meal photo
                [strongCell.imageViewMealPhoto setImage:image];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                __strong __typeof(&*weakCell)strongCell = weakCell;
                /* Failed to download image */
                
                // Use default image
                [strongCell.imageViewMealPhoto setImage:[UIImage imageNamed:kPastDonationsDefaultMealPhoto]];
            }];
        }
        else {
            [cell.imageViewMealPhoto setImage:mealPhotoLargeImage];
        }
    }
    else {
        // Use default image
        [cell.imageViewMealPhoto setImage:[UIImage imageNamed:kPastDonationsDefaultMealPhoto]];
    }
    
    // Configure cell's appearance
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setUserInteractionEnabled:YES];

    // Apply custom configuration
    if (donationContainer.configureCell) {
        donationContainer.configureCell(cell);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFTableCellDataContainer *donationContainer = [self.moduleController.donationContainerCollection objectAtIndex:indexPath.row];
    if (donationContainer.didSelectRowBlock) {
        donationContainer.didSelectRowBlock(self, tableView, indexPath);
    }
}

@end
