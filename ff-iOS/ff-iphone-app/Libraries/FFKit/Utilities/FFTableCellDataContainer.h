//
//  FFTableCellDataContainer.h
//  FFiPhoneApp
//
//  Created by lee on 8/10/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFTableCellDataContainer : NSObject

@property (strong, nonatomic) id data;
@property (strong, nonatomic) void (^configureCell)(UITableViewCell *cell);
@property (strong, nonatomic) void (^didSelectRowBlock)(UIViewController *viewController, UITableView *tableView, NSIndexPath *indexPath);

- (id)initWithData:(id)data
configureCellBlock:(void (^)(UITableViewCell *cell))configureCellBlock
 didSelectRowBlock:(void (^)(UIViewController *viewController, UITableView *tableView, NSIndexPath *indexPath))didSelectRowBlock;

@end
