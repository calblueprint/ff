//
//  POSDPostDonationViewController.m
//  FFiPhoneApp
//
//  Created by lee on 7/31/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "POSDPostDonationViewController.h"
#import "POSDChooseLocationViewController.h"
#import "POSDChooseAmountViewController.h"
#import "POSDChooseTimeViewController.h"

#import "PostDonationConstants.h"
#import "PostDonationModuleController.h"
#import "AppDelegate.h"
#import "Dashboard.h"
#import "FFKit.h"

#import "UIImage+Resize.h"


static NSString * const kDonationDescriptionPlaceholder = @"Add A Description Or Special Instructions";

@interface POSDPostDonationViewController ()

@property (weak, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) FFDataDonation *donation;
@property (strong, nonatomic) UIImage *imageMealPhoto;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) POSDChooseLocationViewController *chooseLocationViewController;
@property (strong, nonatomic) POSDChooseAmountViewController *chooseAmountViewController;
@property (strong, nonatomic) POSDChooseTimeViewController *chooseTimeViewController;
@property (strong, nonatomic) POSDTitleViewController *chooseTitleViewController;
@property (strong, nonatomic) NSMutableDictionary *buttonLabelCollection;
@property (strong, nonatomic) NSMutableDictionary *buttonImageViewCollection;
@property (nonatomic) BOOL isPostDonationInProcess;

// NEW STUFF
- (IBAction)selectAddress:(id)sender;
- (IBAction)selectPickupBy:(id)sender;
- (IBAction)buttonDone:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *selectPickupByButton;

@property (weak, nonatomic) IBOutlet UIButton *selectKindButton;
@property (weak, nonatomic) IBOutlet UITextField *selectKindField;

@property (weak, nonatomic) IBOutlet UIButton *selectAddressButton;

@property (weak, nonatomic) IBOutlet UIButton *selectWeightButton;
@property (weak, nonatomic) IBOutlet UITextField *selectDonationAmountField;


@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIView *datePickerContainer;
@property (strong, nonatomic) UIButton *datePickerConfirm;

@property (strong, nonatomic) NSArray *donationControllers;
@property (strong, nonatomic) NSArray *viewControllers;
@property int currentIndex;

@end

@implementation POSDPostDonationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    DebugLog(@"viewDidLoad");
    
    [self configureAppearance];
    
    [self setIsPostDonationInProcess:NO];
    [self setAppDelegate:[[UIApplication sharedApplication] delegate]];
    [self setDonation:[FFDataDonation new]];
    [self.donation setLocation:[FFDataLocation new]];
    // Meta data for configuring buttons' appearance
  
		[self.selectKindButton setTag:0];
		[self.selectWeightButton setTag:1];
		[self.selectPickupByButton setTag:2];
		[self.selectAddressButton setTag:3];
  
	
		self.selectKindField.delegate = self;
		self.selectDonationAmountField.delegate = self;
		self.selectDonationAmountField.keyboardType = UIKeyboardTypeDecimalPad;
    // Register to receive notification for prefilling the post donation form
	
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//
//    DebugLog(@"viewWillAppear");
//    
//    //
//    // Configure buttons appearance
//    //
//    
//    if (self.isPostDonationInProcess) {
//        // Do nothing if a donation is already in process
//        return;
//    }
//
    // Where?
    NSString *addressWithoutStreetAddressOne = [[self.donation.location formattedAddress]
                                                substringFromIndex:self.donation.location.streetAddressOne.length];
    addressWithoutStreetAddressOne = [addressWithoutStreetAddressOne
                                      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
    if (self.donation.location.streetAddressOne)
    {
        [self setTextOnButton:self.selectAddressButton
                        title:self.donation.location.streetAddressOne
                titleFontSize:18.0
                  description:addressWithoutStreetAddressOne
          descriptionFontSize:13.0];
//			self.selectAddressButton.titleLabel.text = self.donation.location.streetAddressOne;
    }
	[self configurePostDonationButtonStatus];
}

- (void)configurePostDonationButtonStatus
{

}

// Add attributed text to target button
//
// @param button Target button
// @param title Text with bold style, and black color
// @param titleFontSize Text font size for title
// @param description Gray colored text that appears right below the title text
// @param descriptionFontSize Text font size for description
//
- (void)setTextOnButton:(UIButton *)button title:(NSString *)title titleFontSize:(float)titleFontSize description:(NSString *)description descriptionFontSize:(float)descriptionFontSize
{
	UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:titleFontSize];
	UIFont *descriptionFont = [UIFont fontWithName:@"HelveticaNeue" size:descriptionFontSize];
	
	// Create attributed string for title
	NSMutableAttributedString *buttonTitleText = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: titleFont}];
	
	// Set title's text color
	[buttonTitleText addAttribute:NSForegroundColorAttributeName
													value:[UIColor colorWithRed:35.0/255 green:135.0/255 blue:162.0/255 alpha:1.0]
													range:NSMakeRange(0, buttonTitleText.length)];
	
	// Create attributed string for description
	NSMutableAttributedString *buttonDescriptionText = [[NSMutableAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName: descriptionFont}];
	
	// Set description's text color
	[buttonDescriptionText addAttribute:NSForegroundColorAttributeName
																value:[UIColor darkGrayColor]
																range:NSMakeRange(0, buttonDescriptionText.length)];
	//
	// Create a label containing the stylized title and description
	//
	
	if (!self.buttonLabelCollection) {
		self.buttonLabelCollection = [NSMutableDictionary dictionary];
	}
	
	NSString *buttonTag = [NSString stringWithFormat:@"%d", button.tag];
	UILabel *label = [self.buttonLabelCollection objectForKey:buttonTag];
	
	if (!label) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
																											CGRectGetWidth(button.bounds),
																											CGRectGetHeight(button.bounds))];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		[self.buttonLabelCollection setObject:label forKey:buttonTag];
		
		// Put the label on top of target button
		[button addSubview:label];
	}
	
	NSMutableAttributedString *buttonWholeText = [[NSMutableAttributedString alloc] init];
	
	[buttonWholeText appendAttributedString:buttonTitleText];
	[buttonWholeText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
	[buttonWholeText appendAttributedString:buttonDescriptionText];
	
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextAlignment:NSTextAlignmentRight];
	[label setAttributedText:buttonWholeText];
	[label setNumberOfLines:0];
	[label setUserInteractionEnabled:NO];
	
	// Change target button's images to reflect its new state
	[button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateHighlighted];
	[button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateNormal];
}

- (void)configureAppearance
{
	self.selectPickupByButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
	self.selectPickupByButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
// Send donation information to backend
//
- (void)postDonationWithSuccess:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //
        // Post donation and upload meal photo
        //
        if (self.imageMealPhoto)
        {
            // Resize meal photo
            UIImage *resizedImage = [self.imageMealPhoto resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                                              bounds:CGSizeMake(kMealPhotoResizeMaximumWidth, kMealPhotoResizeMaximumHeight)
                                                                interpolationQuality:1.0f];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.moduleController postDonation:self.donation andUploadMealPhoto:resizedImage
                didCreateLocation:^(FFDataLocation *location) {
                    [self.moduleController willPostDonation:        self.donation
                                           andWillUploadMealPhoto:  resizedImage];
                }
                didFailCreatingLocation:^(FFError *error) {
                    [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
                    [self.moduleController didFailPostingDonation:          self.donation
                                           andDidFailUploadingMealPhoto:    resizedImage];
                    if (failureBlock) { failureBlock(); }
                }
                postSuccess:^(FFDataDonation *donation) {
                    if (successBlock) { successBlock(); }
                } 
                postFailure:^(FFError *error) {
                    [self.moduleController didFailPostingDonation:          self.donation
                                           andDidFailUploadingMealPhoto:    resizedImage];
                    if (failureBlock) { failureBlock(); }
                }
                uploadSuccess:^(FFDataDonation *donation, FFDataImage *image) {
                    [self.moduleController didPostDonation:                   self.donation
                                           andDidRetrievePersistedDonation:   donation
                                           andDidUploadMealPhoto:             resizedImage
                                           andDidRetrievePersistedMealPhoto:  image];
                }
                uploadFailure:^(FFDataDonation *donation, FFError *error) {
                    [self.moduleController didPostDonation:                   self.donation
                                           andDidRetrievePersistedDonation:   donation
                                           butDidFailUploadingMealPhoto:      resizedImage];
                }];
            });
        }
        else
        //
        // Post donation without meal photo
        //
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.moduleController postDonation:self.donation andUploadMealPhoto:nil
                didCreateLocation:^(FFDataLocation *location) {
                    [self.moduleController willPostDonation:        self.donation
                                           andWillUploadMealPhoto:  nil];
                }
                didFailCreatingLocation:^(FFError *error) {
                    [FFUI showPopupMessageWithTitle:@"Error" message:error.errorDescription];
                    [self.moduleController didFailPostingDonation:          self.donation
                                           andDidFailUploadingMealPhoto:    nil];
                    if (failureBlock) { failureBlock(); }
                }
                postSuccess:^(FFDataDonation *donation) {
                    [self.moduleController didPostDonation:                     self.donation
                                           andDidRetrievePersistedDonation:     donation
                                           andDidUploadMealPhoto:               nil
                                           andDidRetrievePersistedMealPhoto:    nil];
                     if (successBlock) { successBlock(); }
                }
                postFailure:^(FFError *error) {
                    [self.moduleController didFailPostingDonation:          self.donation
                                           andDidFailUploadingMealPhoto:    nil];
                    if (failureBlock) { failureBlock(); }
                }
                uploadSuccess:nil
                uploadFailure:nil];
            });
        }
    });
}

//
// Methods for handling picture
//
- (void)presentPictureSourceOptions
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setDelegate:self];
    self.imagePicker.allowsEditing = YES;
    
    // If camera is available, make it an option
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:(id)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        
        [actionSheet showInView:self.appDelegate.window.rootViewController.view];
    }
    else
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

// UIImagePickerController delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self setImageMealPhoto:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self dismissViewControllerAnimated:YES completion:nil];

}
//---------------------------------------------

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [self animateView:textField up: YES];
  
    // Disable user interaction on all buttons
	if (textField == self.selectKindField) {
    textField.text = self.selectKindButton.titleLabel.text;
	} else if (textField == self.selectDonationAmountField) {
		textField.text = self.selectWeightButton.titleLabel.text;
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Enable user interaction on all buttons

    if (textField == self.selectKindField) {
			[self setTextOnButton:self.selectKindButton
											title:textField.text
							titleFontSize:18.0
								description:@""
				descriptionFontSize:13.0];
    } else if (textField == self.selectDonationAmountField) {
			[self setTextOnButton:self.selectWeightButton
											title:textField.text
							titleFontSize:18.0
								description:@"pounds"
				descriptionFontSize:13.0];
		}
	textField.text = @"";
	[textField resignFirstResponder];
}


- (IBAction)selectAddress:(id)sender {
	NSLog(@"selecting location");
	self.chooseLocationViewController = [self.moduleController.storyboard instantiateViewControllerWithIdentifier:@"POSDChooseLocationViewController"];
	self.chooseLocationViewController.delegate = self;
	self.chooseLocationViewController.location = self.donation.location;
	[self.navigationController pushViewController:self.chooseLocationViewController animated:YES];
}

- (IBAction)selectPickupBy:(id)sender {
	NSInteger datePickerConfirmButtonHeight = 50;
	if (!self.datePicker) {

		self.datePickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		UIGestureRecognizer *tapParent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDatePicker)];
		[self.datePickerContainer	addGestureRecognizer:tapParent];

		self.datePicker = [[UIDatePicker alloc] init];
		[self.datePicker setBackgroundColor:[UIColor whiteColor]];
		self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
		
		self.datePickerConfirm = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, datePickerConfirmButtonHeight)];
		self.datePickerConfirm.backgroundColor = [UIColor colorWithRed:35.0/255 green:135.0/255 blue:162.0/255 alpha:1.0];
		[self.datePickerConfirm setTitle:@"CONFIRM DATE" forState:UIControlStateNormal];
		self.datePickerConfirm.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
		[self.datePickerConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self.datePickerConfirm setTitleColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:UIControlStateHighlighted];

		[self.datePickerConfirm addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview: self.datePickerContainer];
		[self.view addSubview:self.datePicker];
		[self.view addSubview:self.datePickerConfirm];
	}
	self.datePickerContainer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	NSInteger tabBarHeight = 50;
	[UIView animateWithDuration:0.4 animations:^{
		[self.datePickerContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
		self.datePicker.frame = CGRectMake(0, self.view.frame.size.height - self.datePicker.frame.size.height - tabBarHeight, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
		self.datePickerConfirm.frame = CGRectMake(0, self.datePicker.frame.origin.y - datePickerConfirmButtonHeight, self.view.frame.size.width, datePickerConfirmButtonHeight);
	} completion:^(BOOL finished) {
	}];
}

- (void) dateSelected {
	[self closeDatePicker];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEE, hh:mm a"];
	NSString *title = [formatter stringFromDate:self.datePicker.date];
	[formatter setDateFormat:@"MMMM d"];
	NSString *desc = [formatter stringFromDate:self.datePicker.date];

	[self setTextOnButton:self.selectPickupByButton
									title:title
					titleFontSize:18.0
						description:desc
		descriptionFontSize:13.0];
	[self.datePicker date];
}

- (void) closeDatePicker {
	[UIView animateWithDuration:0.4 animations:^{
		[self.datePickerContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
		self.datePicker.frame = CGRectMake(0, self.view.frame.size.height, self.datePicker.frame.size.width, self.datePicker.frame.size.height);
		self.datePickerConfirm.frame = CGRectMake(0, self.view.frame.size.height, self.datePickerConfirm.frame.size.width, self.datePickerConfirm.frame.size.height);
	} completion:^(BOOL finished) {
		self.datePickerContainer.frame = CGRectMake(0, self.view.frame.size.height, self.datePickerConfirm.frame.size.width, self.datePickerConfirm.frame.size.height);

	}];
}

- (IBAction)selectWeight:(id)sender {
}

- (IBAction)selectKind:(id)sender {
	
}

- (IBAction)buttonDone:(id)sender {
	NSLog(@"Submit button clicked.");
}


#pragma mark - POSDChooseLocationViewController delegate

- (void)chooseLocationViewController:(POSDChooseLocationViewController *)controller didSelectLocation:(FFDataLocation *) location {
	self.donation.location = location;
}

@end
