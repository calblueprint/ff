//
//  POSDChooseTimeViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/4/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "POSDChooseTimeViewController.h"
#import "PostDonationConstants.h"
#import "PostDonationModuleController.h"
#import "FFKit.h"

@interface POSDChooseTimeViewController ()

@property (strong, nonatomic) UIPickerView *pickerViewStartDate;
@property (strong, nonatomic) UIDatePicker *datePickerStartTime;
@property (strong, nonatomic) UIDatePicker *datePickerEndTime;
@property (strong, nonatomic) IBOutlet UIButton *buttonBack;
@property (strong, nonatomic) IBOutlet UITextField *textFieldStartDate;
@property (strong, nonatomic) IBOutlet UITextField *textFieldStartTime;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEndTime;
@property (strong, nonatomic) IBOutlet UIButton *buttonDone;

@property (strong, nonatomic) NSArray *pickupDates;
@property (strong, nonatomic) NSDate *selectedPickupDate;
@property (strong, nonatomic) NSDate *pickupTimePeriodStart;
@property (strong, nonatomic) NSDate *pickupTimePeriodEnd;

- (IBAction)buttonDone_onTouchUpInside:(id)sender;

@end

@implementation POSDChooseTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureAppearance];
    
    //
    // Compute allowable pickup time period
    //
    [self setPickupTimePeriodStart:[[[NSDate date] ff_dateMidnight] ff_dateByAddingHours:kPickupTimeStartHour]];
    [self setPickupTimePeriodEnd:[[[NSDate date] ff_dateMidnight] ff_dateByAddingHours:kPickupTimeEndHour]];

    //
    // Generate pickup dates
    //
    if ([self isPickupTodayAllowedWithTodayEndingTime:self.pickupTimePeriodEnd]) {
        // First available date is Today
        self.pickupDates = [self generateDatesWithStartDate:[NSDate date] numberOfDays:kPickupPeriodMaximumLengthInDay];
    }
    else {
        // First available date is Tomorrow
        self.pickupDates = [self generateDatesWithStartDate:[[NSDate date] ff_dateByAddingDays:1] numberOfDays:kPickupPeriodMaximumLengthInDay];
    }

    //
    // Setup picker view for start date
    //
    self.pickerViewStartDate = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [self.pickerViewStartDate setDelegate:self];
    [self.pickerViewStartDate setShowsSelectionIndicator:YES];
    self.textFieldStartDate.inputView = self.pickerViewStartDate;
    self.textFieldStartDate.inputAccessoryView = [FFUI keyboardToolbarWithDoneButtonOnView:self.view
                                                                         buttonActionTarget:self.textFieldStartDate
                                                                               buttonAction:@selector(resignFirstResponder)];
    //
    // Setup date picker for start time
    //
    self.datePickerStartTime = [[UIDatePicker alloc] init];
    [self.datePickerStartTime setDatePickerMode:UIDatePickerModeTime];
    [self.datePickerStartTime addTarget:self
                                 action:@selector(datePickerStartTime_onValueChanged:)
                       forControlEvents:UIControlEventValueChanged];
    self.textFieldStartTime.inputView = self.datePickerStartTime;
    self.textFieldStartTime.inputAccessoryView = [FFUI keyboardToolbarWithDoneButtonOnView:self.view
                                                                        buttonActionTarget:self.textFieldStartTime
                                                                              buttonAction:@selector(resignFirstResponder)];
    
    //
    // Setup date picker for end time
    //
    self.datePickerEndTime = [[UIDatePicker alloc] init];
    [self.datePickerEndTime setDatePickerMode:UIDatePickerModeTime];
    [self.datePickerEndTime addTarget:self
                               action:@selector(datePickerEndTime_onValueChanged:)
                     forControlEvents:UIControlEventValueChanged];
    self.textFieldEndTime.inputView = self.datePickerEndTime;
    self.textFieldEndTime.inputAccessoryView = [FFUI keyboardToolbarWithDoneButtonOnView:self.view
                                                                      buttonActionTarget:self.textFieldEndTime
                                                                            buttonAction:@selector(resignFirstResponder)];
    
    //
    // Setup maximum date for start time picker and end time picker
    //
    [self.datePickerStartTime setMaximumDate:[[[NSDate date] ff_dateMidnight] ff_dateByAddingHours:kPickupTimeEndHour-kPickupPeriodMinimumLengthInHour]];
    [self.datePickerEndTime setMaximumDate:[[[NSDate date] ff_dateMidnight] ff_dateByAddingHours:kPickupTimeEndHour]];
    
    // Select start date as Today by default
    [self.pickerViewStartDate.delegate pickerView:self.pickerViewStartDate didSelectRow:0 inComponent:1];
	self.identifier = @"POSDChooseTimeViewController";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureAppearance
{
    [self.textFieldStartDate ff_styleWithRoundCorners];
    [self.textFieldStartDate ff_styleWithPadding];
    [self.textFieldStartTime ff_styleWithRoundCorners];
    [self.textFieldStartTime ff_styleWithPadding];
    [self.textFieldEndTime ff_styleWithRoundCorners];
    [self.textFieldEndTime ff_styleWithPadding];
}

- (IBAction)buttonDone_onTouchUpInside:(id)sender
{
    if (self.textFieldStartTime.text.length > 0 && self.textFieldEndTime.text.length > 0) {
        [self setDonationAvailableDates];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
  
    DebugLog(@"availableStart: %@", self.donation.availableStart);
    DebugLog(@"availableEnd: %@", self.donation.availableEnd);
}

- (IBAction)buttonBack_onTouchUpInside:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setDonationAvailableDates
{
    //
    // Construct donatoin.availableStart by combining self.selectedPickupDate and self.datePickerStartTime.date
    //
    NSDate *tempDate = [self.selectedPickupDate ff_dateMidnight];
    tempDate = [tempDate ff_dateByAddingHours:[self.datePickerStartTime.date ff_hour]];
    tempDate = [tempDate ff_dateByAddingMinutes:[self.datePickerStartTime.date ff_minute]];
    [self.donation setAvailableStart:tempDate];
    
    //
    // Construct donatoin.availableEnd by combining self.selectedPickupDate and self.datePickerEndTime.date
    //
    tempDate = [self.selectedPickupDate ff_dateMidnight];
    tempDate = [tempDate ff_dateByAddingHours:[self.datePickerEndTime.date ff_hour]];
    tempDate = [tempDate ff_dateByAddingMinutes:[self.datePickerEndTime.date ff_minute]];
    [self.donation setAvailableEnd:tempDate];
}

- (BOOL)isPickupTodayAllowedWithTodayEndingTime:(NSDate *)endTime
{
    NSDate *currentDate = [NSDate date];
    
    // currentDate < self.pickupTimePeriodEnd - kPickupPeriodMinimumLengthInHour
    return ([currentDate compare:[endTime ff_dateByAddingHours:-kPickupPeriodMinimumLengthInHour]] == NSOrderedAscending);
}

- (NSArray *)generateDatesWithStartDate:(NSDate *)startDate numberOfDays:(NSUInteger)numberOfDays
{
    NSMutableArray *dates = [NSMutableArray array];
    
    for (int i=0; i<numberOfDays; i++) {
        [dates addObject:[startDate ff_dateByAddingDays:i]];
    }
    
    return dates;
}

- (void)datePickerStartTime_onValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    
    if ([self.textFieldStartTime.text length]) {
        [self.textFieldStartTime setText:[NSString stringWithFormat:@"%@", [datePicker.date ff_stringWithFormat:@"hh:mm a"]]];
    }
    
    [self setMinimumDateOnDatePicker:self.datePickerEndTime
                         minimumDate:[datePicker.date ff_dateByAddingHours:kPickupPeriodMinimumLengthInHour]];
}

- (void)datePickerEndTime_onValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;

    if ([self.textFieldEndTime.text length]) {
        [self.textFieldEndTime setText:[NSString stringWithFormat:@"%@", [datePicker.date ff_stringWithFormat:@"hh:mm a"]]];
    }
}

//
// Set minimum date on target date picker,
//  and trigger event UIControlEventValueChanged if the picker's date is changed.
//
// @param datePicker Target date picker
// @param minimumDate Minimum date we want to set to
//
- (void)setMinimumDateOnDatePicker:(UIDatePicker *)datePicker minimumDate:(NSDate *)minimumDate
{
    NSDate *pickerDate = datePicker.date;
    [datePicker setMinimumDate:minimumDate];
    
    if ([datePicker.date compare:pickerDate] != NSOrderedSame) {
        [datePicker sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void) animateTextFieldIfNecessary:(UITextField *)textField up:(BOOL)up
{
    if (IS_WIDESCREEN()) {
        return;
    }
    
    [FFUI scrollUpView:self.view withDirectionUp:up distance:80];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textFieldStartTime && [textField.text length] == 0) {
        [self.textFieldStartTime setText:@" "];
        [self.datePickerStartTime sendActionsForControlEvents:UIControlEventValueChanged];
    }
    else if (textField == self.textFieldEndTime && [textField.text length] == 0) {
        [self.textFieldEndTime setText:@" "];
        [self.datePickerEndTime sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    [self animateTextFieldIfNecessary:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextFieldIfNecessary:textField up:NO];
}

#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickupDates count];
}

#pragma mark - UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.textFieldStartDate setText:[pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component]];
    [self setSelectedPickupDate:[self.pickupDates objectAtIndex:row]];

    //
    // Adjust start time picker' minimum date according to selectedDate
    //
    NSDate *currentDate = [NSDate date];
    
    if ([self.selectedPickupDate ff_isToday] && [currentDate compare:self.pickupTimePeriodStart] == NSOrderedDescending) {
        [self setMinimumDateOnDatePicker:self.datePickerStartTime
                             minimumDate:currentDate];
    }
    else {
        [self setMinimumDateOnDatePicker:self.datePickerStartTime
                             minimumDate:self.pickupTimePeriodStart];
    }

    // Adjust end time picker's minimum date according to self.datePickerStartTime.date
    [self setMinimumDateOnDatePicker:self.datePickerEndTime
                         minimumDate:[self.datePickerStartTime.date ff_dateByAddingHours:kPickupPeriodMinimumLengthInHour]];
    
    //
    // Set default date on start time picker and end time picker if they are not set yet
    //
    if ([[self.textFieldStartTime text] length] == 0 && [[self.textFieldEndTime text] length] == 0)
    {
        if ([self.selectedPickupDate ff_isToday] && [currentDate compare:self.pickupTimePeriodStart] == NSOrderedDescending) {
            // Set start time picker's default date to now
            [self.datePickerStartTime setDate:currentDate];
        }
        else {
            // Set start time picker's default date to tomorrow's earliest time
            [self.datePickerStartTime setDate:self.pickupTimePeriodStart];
        }
        
        // Adjust end time picker's minimum date according to self.datePickerStartTime.date
        [self setMinimumDateOnDatePicker:self.datePickerEndTime
                             minimumDate:[self.datePickerStartTime.date ff_dateByAddingHours:kPickupPeriodMinimumLengthInHour]];
        
        // Adjust end time picker's default date according to start time picker''s date
        [self.datePickerEndTime setDate:[self.datePickerStartTime.date ff_dateByAddingHours:kPickupPeriodMinimumLengthInHour]];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDate *date = [self.pickupDates objectAtIndex:row];
    
    if ([date ff_isToday]) { return @"Today"; }
    if ([date ff_isTomorrow]) { return @"Tomorrow"; }

    return [[self.pickupDates objectAtIndex:row] ff_stringWithFormat:@"EEEE, LLL d"];
}

@end
