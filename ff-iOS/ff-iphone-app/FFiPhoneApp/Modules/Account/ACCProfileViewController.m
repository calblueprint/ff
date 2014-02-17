//
//  ACCProfileViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "ACCProfileViewController.h"

#import "AccountModuleController.h"

#import "FFKit.h"

@interface ACCProfileViewController ()

@property (strong, nonatomic) FFDataUser *user;
@property (strong, nonatomic) IBOutlet UILabel *labelFullName;
@property (strong, nonatomic) IBOutlet UILabel *labelEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelMobilePhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelOrganization;
@property (strong, nonatomic) IBOutlet UISwitch *switchSettingShareDonationPopup;

- (IBAction)switchShareDonationPopupSetting_onValueChanged:(id)sender;
- (IBAction)buttonLogout_onTouchUpInside:(id)sender;

@end

@implementation ACCProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.switchSettingShareDonationPopup setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsShareDonationPopupKey] boolValue]];
    
    [self setUser:self.moduleController.user];

    [self.labelFullName setText:self.user.fullName];
    [self.labelEmail setText:self.user.email];
    [self.labelMobilePhoneNumber setText:self.user.mobilePhoneNumber];
    [self.labelOrganization setText:self.user.organization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchShareDonationPopupSetting_onValueChanged:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:self.switchSettingShareDonationPopup.on]
                                             forKey:kUserDefaultsShareDonationPopupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)buttonLogout_onTouchUpInside:(id)sender
{
    [self.moduleController logoutUser];
}

@end
