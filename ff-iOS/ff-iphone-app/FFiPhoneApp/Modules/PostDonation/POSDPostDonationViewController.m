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

#import "FFKit.h"

#import "UIImage+Resize.h"

static NSString * const kDonationDescriptionPlaceholder = @"Add A Description Or Special Instructions";

@interface POSDPostDonationViewController ()

@property (weak, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UITextField *textFieldDonationTitle;
@property (strong, nonatomic) IBOutlet UITextView *textViewDonationDescription;
@property (strong, nonatomic) IBOutlet UIView *viewTitleAndDescriptionBackground;
@property (strong, nonatomic) IBOutlet UIButton *buttonPicture;
@property (strong, nonatomic) IBOutlet UIButton *buttonWhere;
@property (strong, nonatomic) IBOutlet UIButton *buttonHowMuch;
@property (strong, nonatomic) IBOutlet UIButton *buttonWhen;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostDonation;
@property (strong, nonatomic) IBOutlet UIView *viewButtonsBackground;
@property (strong, nonatomic) IBOutlet UIButton *buttonCross;

@property (strong, nonatomic) FFDataDonation *donation;
@property (strong, nonatomic) UIImage *imageMealPhoto;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) POSDChooseLocationViewController *chooseLocationViewController;
@property (strong, nonatomic) POSDChooseAmountViewController *chooseAmountViewController;
@property (strong, nonatomic) POSDChooseTimeViewController *chooseTimeViewController;

@property (strong, nonatomic) NSMutableDictionary *buttonLabelCollection;
@property (strong, nonatomic) NSMutableDictionary *buttonImageViewCollection;

@property (nonatomic) BOOL isPostDonationInProcess;

- (IBAction)buttonPicture_onTouchUpInside:(id)sender;
- (IBAction)buttonCross_onTouchUpInside:(id)sender;
- (IBAction)donationTitle_onEditingChanged:(id)sender;

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
    [self.buttonPicture setTag:0];
    [self.buttonWhere setTag:1];
    [self.buttonWhen setTag:2];
    [self.buttonHowMuch setTag:3];
    
    // Set placehold for description field
    [self setPlaceholderWithTextView:self.textViewDonationDescription text:kDonationDescriptionPlaceholder];
    // Hide description field's cross button
    [self.buttonCross setHidden:YES];
    
    // Register to receive notification for prefilling the post donation form
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveFFPostDonationPrefillPostDonationFormNotification:)
                                                 name:@"FFPostDonationPrefillPostDonationFormNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    DebugLog(@"viewWillAppear");
    
    //
    // Configure buttons appearance
    //
    
    if (self.isPostDonationInProcess) {
        // Do nothing if a donation is already in process
        return;
    }

    // Where?
    NSString *addressWithoutStreetAddressOne = [[self.donation.location formattedAddress]
                                                substringFromIndex:self.donation.location.streetAddressOne.length];
    addressWithoutStreetAddressOne = [addressWithoutStreetAddressOne
                                      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
    if (self.donation.location.streetAddressOne)
    {
        [self setTextOnButton:self.buttonWhere
                        title:self.donation.location.streetAddressOne
                titleFontSize:18.0
                  description:addressWithoutStreetAddressOne
          descriptionFontSize:13.0];
    }
    // How Much?
    if (self.donation.totalLBS)
    {
        NSString *vehicleTypeDescription = nil;
        switch (self.donation.vehicleType) {
            case 0:
                vehicleTypeDescription = @"can be carried";
                break;
            case 1:
                vehicleTypeDescription = @"will fit in small vehicle";
                break;
            case 2:
                vehicleTypeDescription = @"will fit in medium vehicle";
                break;
            case 3:
                vehicleTypeDescription = @"will fit in large vehicle";
                break;
            default:
                vehicleTypeDescription = @"";
                
                DebugLog(@"Invalid vehicle type.");
                break;
        }
        [self setTextOnButton:self.buttonHowMuch
                        title:[NSString stringWithFormat:@"%u pounds", self.donation.totalLBS]
                titleFontSize:18.0
                  description:[NSString stringWithFormat:@"that %@", vehicleTypeDescription]
          descriptionFontSize:13.0];
    }
    // When?
    if (self.donation.availableStart && self.donation.availableEnd)
    {
        NSString *buttonTitle = nil;
        
        if ([self.donation.availableStart ff_isToday]) {
            buttonTitle = @"Today";
        }
        else if ([self.donation.availableStart ff_isTomorrow]) {
            buttonTitle = @"Tomorrow";
        }
        else {
            buttonTitle = [self.donation.availableStart ff_stringWithFormat:@"EEE, LLL d"];
        }

        NSString *buttonDescription = [NSString stringWithFormat:@"from %@ \nto %@",
                             [self.donation.availableStart ff_stringWithFormat:@"hh:mm a"],
                             [self.donation.availableEnd ff_stringWithFormat:@"hh:mm a"]];

        [self setTextOnButton:self.buttonWhen
                        title:buttonTitle
                titleFontSize:20.0
                  description:buttonDescription
          descriptionFontSize:13.0];
    }
    
    [self configurePostDonationButtonStatus];
}

- (void)configurePostDonationButtonStatus
{
    if (self.donation.location.streetAddressOne
        && self.donation.totalLBS
        && self.donation.availableStart && self.donation.availableEnd
        && self.donation.donationTitle.length)
    {
        [self.buttonPostDonation setEnabled:YES];
    }
    else {
        [self.buttonPostDonation setEnabled:NO];
    }
}

- (void)configureAppearance
{
    [self.buttonPicture setImage:[UIImage ff_imageNamed:kPostDonationButtonPictureForStateNormal] forState:UIControlStateNormal];
    [self.buttonPicture setImage:[UIImage ff_imageNamed:kPostDonationButtonPictureForStateHighlighted] forState:UIControlStateHighlighted];
    [self.buttonPicture setImage:[UIImage ff_imageNamed:kPostDonationButtonPictureForStateSelected] forState:UIControlStateSelected];
    
    [self.buttonWhere setImage:[UIImage ff_imageNamed:kPostDonationButtonWhereForStateNormal] forState:UIControlStateNormal];
    [self.buttonWhere setImage:[UIImage ff_imageNamed:kPostDonationButtonWhereForStateHighlighted] forState:UIControlStateHighlighted];
    [self.buttonWhere setImage:[UIImage ff_imageNamed:kPostDonationButtonWhereForStateSelected] forState:UIControlStateSelected];
    
    [self.buttonHowMuch setImage:[UIImage ff_imageNamed:kPostDonationButtonHowMuchForStateNormal] forState:UIControlStateNormal];
    [self.buttonHowMuch setImage:[UIImage ff_imageNamed:kPostDonationButtonHowMuchForStateHighlighted] forState:UIControlStateHighlighted];
    [self.buttonHowMuch setImage:[UIImage ff_imageNamed:kPostDonationButtonHowMuchForStateSelected] forState:UIControlStateSelected];
    
    [self.buttonWhen setImage:[UIImage ff_imageNamed:kPostDonationButtonWhenForStateNormal] forState:UIControlStateNormal];
    [self.buttonWhen setImage:[UIImage ff_imageNamed:kPostDonationButtonWhenForStateHighlighted] forState:UIControlStateHighlighted];
    [self.buttonWhen setImage:[UIImage ff_imageNamed:kPostDonationButtonWhenForStateSelected] forState:UIControlStateSelected];

    [self.textFieldDonationTitle ff_styleWithPadding];
    [self.viewButtonsBackground ff_styleWithShadow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveFFPostDonationPrefillPostDonationFormNotification:(id)sender
{
    // Go back to main screen
    [self.navigationController popToRootViewControllerAnimated:YES];

    // Reset buttons appearance
    [self configureAppearance];

    FFDataDonation *donation = [[sender userInfo] ff_objectForKey:@"donation"];
    
    // Meal photo
    UIImage *mealPhoto = [[FFImageStore sharedStore] imageForKey:donation.mealPhoto.imageURL];
    [self setImageMealPhoto:mealPhoto];
    [self setImageOnButton:self.buttonPicture image:mealPhoto];
    // Location
    [self.donation setLocation:donation.location];
    // Total pounds
    [self.donation setTotalLBS:donation.totalLBS];
    // Title
    [self.donation setDonationTitle:donation.donationTitle];
    [self.textFieldDonationTitle setText:donation.donationTitle];
    // Description
    [self.donation setDonationDescription:donation.donationDescription];
    if ([donation.donationDescription length] == 0) {
        [self setPlaceholderWithTextView:self.textViewDonationDescription text:kDonationDescriptionPlaceholder];
    }
    else {
        [self clearPlaceholderWithTextView:self.textViewDonationDescription];
        [self.textViewDonationDescription setText:donation.donationDescription];
    }
    [self.donation setVehicleType:donation.vehicleType];

    [self viewWillAppear:NO];
}

- (void)animateView:(UIView *)view up:(BOOL)up
{
    [FFUI scrollUpView:self.view withDirectionUp:up distance:165];
}

//
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
    UIFont *titleFont = [UIFont fontWithName:@"Verdana-Bold" size:titleFontSize];
    UIFont *descriptionFont = [UIFont fontWithName:@"Verdana" size:descriptionFontSize];

    // Create attributed string for title
    NSMutableAttributedString *buttonTitleText = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: titleFont}];
    
    // Set title's text color
    [buttonTitleText addAttribute:NSForegroundColorAttributeName
                      value:[UIColor blackColor]
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
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setAttributedText:buttonWholeText];
    [label setNumberOfLines:0];
    [label setUserInteractionEnabled:NO];

    // Change target button's images to reflect its new state
    [button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateHighlighted];
    [button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateNormal];
}

- (void)setImageOnButton:(UIButton *)button image:(UIImage *)image
{    
    if (!self.buttonImageViewCollection) {
        self.buttonImageViewCollection = [NSMutableDictionary dictionary];
    }
    
    NSString *buttonTag = [NSString stringWithFormat:@"%d", button.tag];
    UIImageView *imageView = [self.buttonImageViewCollection objectForKey:buttonTag];
    
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                      CGRectGetWidth(button.bounds),
                                                      CGRectGetHeight(button.bounds))];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.buttonImageViewCollection setObject:imageView forKey:buttonTag];
        
        // Put the image view on top of target button
        [button addSubview:imageView];
    }

    [imageView setImage:image];

    if (image) {
        // Change target button's images to reflect its new state
        [button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateHighlighted];
        [button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateNormal];
    }
}

- (void)setPlaceholderWithTextView:(UITextView *)textView text:(NSString *)text
{
    [textView setText:text];
    [textView setTag:1];
    [textView setTextColor:[UIColor lightGrayColor]];
}

- (void)clearPlaceholderWithTextView:(UITextView *)textView
{
    [textView setText:@""];
    [textView setTag:0];
    [textView setTextColor:[UIColor darkGrayColor]];
}

- (void)clearDonationDescriptionText
{
    [self.textViewDonationDescription setText:@""];
}

- (void)configureCrossButtonStatus
{
    if ([self.textViewDonationDescription.text length] > 0) {
        [self.buttonCross setHidden:NO];
    }
    else {
        [self.buttonCross setHidden:YES];
    }
}

- (IBAction)buttonPicture_onTouchUpInside:(id)sender
{
    [self presentPictureSourceOptions];
}

- (IBAction)buttonCross_onTouchUpInside:(id)sender
{
    [self clearDonationDescriptionText];
    [self.textViewDonationDescription.delegate textViewDidChange:self.textViewDonationDescription];
}

- (IBAction)buttonPostDonation_onTouchUpInside:(id)sender
{
    [self.view endEditing:YES];
    [self.buttonPostDonation setEnabled:NO];
    [FFUI showLoadingViewOnView:self.view visible:YES];
    [self setIsPostDonationInProcess:YES];
    
    [self postDonationWithSuccess:nil failure:^{
        [self.buttonPostDonation setEnabled:YES];
        [self setIsPostDonationInProcess:NO];
        [FFUI showLoadingViewOnView:self.view visible:NO];
    }];

}

- (IBAction)donationTitle_onEditingChanged:(id)sender
{
    [self.donation setDonationTitle:self.textFieldDonationTitle.text];
    [self configurePostDonationButtonStatus];
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

// UIActionSheet delegate method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
       self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

// UIImagePickerController delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self setImageMealPhoto:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self dismissViewControllerAnimated:YES completion:nil];

    [self setImageOnButton:self.buttonPicture image:self.imageMealPhoto];
}
//---------------------------------------------

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"presentChooseLocation"])
    {
        //
        // Present Choose Location view controller
        //
        if (!self.chooseLocationViewController) {
            self.chooseLocationViewController = [self.moduleController.storyboard instantiateViewControllerWithIdentifier:@"POSDChooseLocationViewController"];
            
            // Pass location to Choose Location view controller
            [self.chooseLocationViewController setLocation:self.donation.location];
        }
        
        [self.navigationController pushViewController:(id)self.chooseLocationViewController animated:YES];

        return NO;
    }
    
    if ([identifier isEqualToString:@"presentChooseAmount"])
    {
        //
        // Present Choose Amount view controller
        //
        if (!self.chooseAmountViewController) {
            self.chooseAmountViewController = [self.moduleController.storyboard instantiateViewControllerWithIdentifier:@"POSDChooseAmountViewController"];
            
            // Pass donation to Choose Amount view controller
            [self.chooseAmountViewController setDonation:self.donation];
        }

        [self.navigationController pushViewController:(id)self.chooseAmountViewController animated:YES];

        return NO;
    }
    
    if ([identifier isEqualToString:@"presentChooseTime"])
    {
        //
        // Present Choose Time view controller
        //
        if (!self.chooseTimeViewController) {
            self.chooseTimeViewController = [self.moduleController.storyboard instantiateViewControllerWithIdentifier:@"POSDChooseTimeViewController"];
            
            // Pass donation to Choose Time view controller
            [self.chooseTimeViewController setDonation:self.donation];
        }
        
        [self.navigationController pushViewController:(id)self.chooseTimeViewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateView:textField up: YES];
    
    // Disable user interaction on all buttons
    [self.viewButtonsBackground setUserInteractionEnabled:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateView:textField up: NO];
    
    // Enable user interaction on all buttons
    [self.viewButtonsBackground setUserInteractionEnabled:YES];

    if (textField == self.textFieldDonationTitle) {
        [self.donation setDonationTitle:textField.text];
        [self configurePostDonationButtonStatus];
    }
}

#pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.textViewDonationDescription)
    {
        [self configureCrossButtonStatus];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateView:textView up:YES];
    
    // Disable user interaction on all buttons
    [self.viewButtonsBackground setUserInteractionEnabled:NO];
    
    if (textView == self.textViewDonationDescription)
    {
        // textViewDonationDescription is containing placeholder text
        if (textView.tag) {
            [self clearPlaceholderWithTextView:textView];
        }
        else {
            [self configureCrossButtonStatus];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateView:textView up:NO];
    
    // Enable user interaction on all buttons
    [self.viewButtonsBackground setUserInteractionEnabled:YES];
    
    if (textView == self.textViewDonationDescription)
    {
        if ([textView.text length] == 0) {
            [self setPlaceholderWithTextView:textView text:kDonationDescriptionPlaceholder];
            [self.donation setDonationDescription:@""];
        }
        else {
            [self.donation setDonationDescription:textView.text];
        }
        
        // Hide clear button
        [self.buttonCross setHidden:YES];
    }
}

@end
