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
@synthesize viewControllers;

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
    return [viewControllers count];
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
    //cell.textLabel.text = NSStringFromClass([[viewControllers objectAtIndex:indexPath.row] class]);
    cell.textLabel.text = [self.navCellNames objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"second.png"];
    cell.backgroundColor = self.backgroundGray;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Nav Drawer index selected: %d", indexPath.row);
    UIViewController *viewController = [viewControllers objectAtIndex:indexPath.row];
    
    [self.mmDrawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
}
@end
