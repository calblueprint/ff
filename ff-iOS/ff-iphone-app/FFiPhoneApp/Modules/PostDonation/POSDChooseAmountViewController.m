//
//  POSDChooseAmountViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/4/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "POSDChooseAmountViewController.h"

#import "PostDonationConstants.h"

#import "FFKit.h"

@interface POSDChooseAmountViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textFieldAmount;
@property (strong, nonatomic) IBOutlet UIStepper *stepperAmount;
@property (strong, nonatomic) IBOutlet UISlider *sliderAmount;
@property (strong, nonatomic) IBOutlet UIButton *buttonVehicleTypeNone;
@property (strong, nonatomic) IBOutlet UIButton *buttonVehicleTypeSmall;
@property (strong, nonatomic) IBOutlet UIButton *buttonVehicleTypeMedium;
@property (strong, nonatomic) IBOutlet UIButton *buttonVehicleTypeLarge;

@property (strong, nonatomic) NSArray *vehicleTypeButtons;

- (IBAction)buttonVehicleTypeNone_onTouchUpInside:(id)sender;
- (IBAction)buttonVehicleTypeSmall_onTouchUpInside:(id)sender;
- (IBAction)buttonVehicleTypeMedium_onTouchUpInside:(id)sender;
- (IBAction)buttonVehicleTypeLarge_onTouchUpInside:(id)sender;
- (IBAction)buttonBack_onTouchUpInside:(id)sender;
- (IBAction)buttonDone_onTouchUpInside:(id)sender;

@end

@implementation POSDChooseAmountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureAppearance];
    
    [self.textFieldAmount setInputAccessoryView:[FFUI keyboardToolbarWithDoneButtonOnView:self.view
                                                                       buttonActionTarget:self.textFieldAmount
                                                                             buttonAction:@selector(resignFirstResponder)]];
    //
    // Setup vehicle type buttons
    //
    [self.buttonVehicleTypeNone setTag:0];
    [self.buttonVehicleTypeSmall setTag:1];
    [self.buttonVehicleTypeMedium setTag:2];
    [self.buttonVehicleTypeLarge setTag:3];
    self.vehicleTypeButtons = @[self.buttonVehicleTypeNone,
                                self.buttonVehicleTypeSmall,
                                self.buttonVehicleTypeMedium,
                                self.buttonVehicleTypeLarge];
    
    DebugLog(@"Maximum donation amount: %d", kMaximumDonationAmount);
    DebugLog(@"Minimum donation amount: %d", kMinimumDonationAmount);
    
    //
    // Setup maximum/minimum values for slider and stepper
    //
    [self.sliderAmount setMinimumValue:(float)kMinimumDonationAmount];
    [self.sliderAmount setMaximumValue:(float)kMaximumDonationAmount];
    [self.stepperAmount setMinimumValue:(float)kMinimumDonationAmount];
    [self.stepperAmount setMaximumValue:(float)kMaximumDonationAmount];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //
    // Pre-set data
    //
    NSUInteger defaultAmount = kMinimumDonationAmount;
    NSUInteger defaultVehicleType = 0;
    if (self.donation.totalLBS) {
        defaultAmount = self.donation.totalLBS;
        defaultVehicleType = self.donation.vehicleType;
    }
    [self.textFieldAmount setText:[NSString stringWithFormat:@"%d", defaultAmount]];
    [self.sliderAmount setValue:defaultAmount];
    [self.stepperAmount setValue:defaultAmount];
    [self chooseVehicle:[self.vehicleTypeButtons objectAtIndex:defaultVehicleType]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureAppearance
{
    
}

- (IBAction)buttonsVehicleType_onTouchUpInside:(id)sender
{
    [self chooseVehicle:sender];
}

- (IBAction)buttonVehicleTypeNone_onTouchUpInside:(id)sender
{
    [self chooseVehicle:sender];
}

- (IBAction)buttonVehicleTypeSmall_onTouchUpInside:(id)sender
{
    [self chooseVehicle:sender];
}

- (IBAction)buttonVehicleTypeMedium_onTouchUpInside:(id)sender
{
    [self chooseVehicle:sender];
}

- (IBAction)buttonVehicleTypeLarge_onTouchUpInside:(id)sender
{
    [self chooseVehicle:sender];
}

- (IBAction)buttonBack_onTouchUpInside:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonDone_onTouchUpInside:(id)sender
{
    [self setDonationAmount];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderAmount_onValueChanged:(id)sender
{
    // Rounds float to an integer
    int discreteValue = roundl(self.sliderAmount.value);
    [self.sliderAmount setValue:(float)discreteValue];
    [self.stepperAmount setValue:(float)discreteValue];
    [self.textFieldAmount setText:[NSString stringWithFormat:@"%d", discreteValue]];
}

- (IBAction)stepperAmount_onValueChanged:(id)sender
{
    // Rounds float to an integer
    int discreteValue = roundl(self.stepperAmount.value);
    [self.sliderAmount setValue:(float)discreteValue];
    [self.stepperAmount setValue:(float)discreteValue];
    [self.textFieldAmount setText:[NSString stringWithFormat:@"%d", discreteValue]];
}

- (IBAction)textFieldAmount_onEditingDidEnd:(id)sender
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:self.textFieldAmount.text];
    NSInteger amount;
    
    if ([scanner scanInteger:&amount])
    {
        if (amount >= kMinimumDonationAmount && amount <= kMaximumDonationAmount)
        {
            [self.stepperAmount setValue:(float)amount];
            [self.sliderAmount setValue:(float)amount];
            
            DebugLog(@"Pounds was set to: %i", amount);
        }
        else if (amount > kMaximumDonationAmount)
        {
            [self.textFieldAmount setText:[NSString stringWithFormat:@"%d", kMaximumDonationAmount]];
            [self.stepperAmount setValue:(float)kMaximumDonationAmount];
            [self.sliderAmount setValue:(float)kMaximumDonationAmount];
             
            DebugLog(@"Pounds too high.");
             
        }
        else if (amount < kMinimumDonationAmount)
        {
            [self.textFieldAmount setText:[NSString stringWithFormat:@"%d", kMinimumDonationAmount]];
            [self.stepperAmount setValue:(float)kMinimumDonationAmount];
            [self.sliderAmount setValue:(float)kMinimumDonationAmount];
            
            DebugLog(@"Pounds too low.");
        }
    }
    else
    {
        [self.textFieldAmount setText:[NSString stringWithFormat:@"%d", kMinimumDonationAmount]];
        [self.stepperAmount setValue:(float)kMinimumDonationAmount];
        [self.sliderAmount setValue:(float)kMinimumDonationAmount];

        DebugLog(@"Didn't parse successfully.");
    }
}

- (void)chooseVehicle:(id)sender
{
    for (UIButton *button in self.vehicleTypeButtons)
    {
        if ([sender isEqual:button]) {
            [self.donation setVehicleType:button.tag];
            [button setAlpha:1.0f];
        } else {
            [button setAlpha:0.1f];
        }
    }
    
    DebugLog(@"Selected vehicle type: %u", self.donation.vehicleType);
}

- (void)setDonationAmount
{
    [self.donation setTotalLBS:[self.textFieldAmount.text integerValue]];
}

@end
