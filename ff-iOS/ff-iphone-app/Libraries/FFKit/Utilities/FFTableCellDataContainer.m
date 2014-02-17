//
//  FFTableCellDataContainer.m
//  FFiPhoneApp
//
//  Created by lee on 8/10/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "FFTableCellDataContainer.h"

@implementation FFTableCellDataContainer

- (id)initWithData:(id)data
configureCellBlock:(void (^)(UITableViewCell *cell))configureCellBlock
 didSelectRowBlock:(void (^)(UIViewController *viewController, UITableView *tableView, NSIndexPath *indexPath))didSelectRowBlock;
{
    self = [super init];
    
    if (self)
    {
        // You can specify any additonal
        // initialization steps here.
        
        [self setData:data];
        [self setConfigureCell:configureCellBlock];
        [self setDidSelectRowBlock:didSelectRowBlock];
    }

    return self;
}

@end
