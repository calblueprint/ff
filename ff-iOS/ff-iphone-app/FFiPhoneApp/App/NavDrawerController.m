//
//  NavDrawerController.m
//  FFiPhoneApp
//
//  Created by William Tang on 4/1/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import "NavDrawerController.h"

@interface NavDrawerController ()
@property UIColor *backgroundGray;
@end

@implementation NavDrawerController
@synthesize moduleCoordinator;
@synthesize viewControllers;
@synthesize drawerIcons;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:0.7]];
    [self.tableView setBounces:NO];
    
    UIView* bview = [[UIView alloc] init];
    self.backgroundGray = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1.0];
    

    bview.backgroundColor = self.backgroundGray;
    [self.tableView setBackgroundView:bview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([viewControllers count] == 5)
    {
        return [viewControllers count] + 1;
    }
    else
    {
        return [viewControllers count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    // Configure the cell...
    cell.textLabel.text = [self.navCellNames objectAtIndex:indexPath.row];
    UIImage *icon = [UIImage imageNamed:[self.drawerIcons objectAtIndex:indexPath.row]];
    icon = [self.class resizeImage:icon withWidth:30 withHeight:30];
    
    cell.imageView.image = icon;
    cell.backgroundColor = self.backgroundGray;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"ProximaNovaA-Regular" size:20]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Nav Drawer index selected: %d", indexPath.row);
    if (indexPath.row == 5) {
        NSLog(@"logout shit");
        NSLog(@"module coordinator: %@", moduleCoordinator);
        [self logoutUser];
        
    }
    else {
        UIViewController *viewController = [viewControllers objectAtIndex:indexPath.row];
        [self.mmDrawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
    }
}

+ (UIImage*)resizeImage:(UIImage*)image withWidth:(int)width withHeight:(int)height
{
    CGSize newSize = CGSizeMake(width, height);
    float widthRatio = newSize.width/image.size.width;
    float heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)logoutUser
{
    [self.moduleCoordinator didReceiveRequestToLogoutUserWithSender:self];
    //Logout functionality goes here
}

@end
