//
//  NavDrawerController.m
//  FFiPhoneApp
//
//  Created by William Tang on 4/1/14.
//  Copyright (c) 2014 Feeding Forward. All rights reserved.
//

#import "NavDrawerController.h"

@interface NavDrawerController ()

@end

@implementation NavDrawerController
@synthesize viewControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    // Configure the cell...
    cell.textLabel.text = NSStringFromClass([[viewControllers objectAtIndex:indexPath.row] class]);
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    NSLog(@"Index selected: %d", index);
    [self.navigationController pushViewController:[viewControllers objectAtIndex:indexPath.row] animated:YES];
    
    
}
@end
