//
//  CurrentDonationsBaseViewController.m
//  FFiPhoneApp
//
//  Created by lee on 8/8/13.
//  Copyright (c) 2013 Feeding Forward. All rights reserved.
//

#import "CurrentDonationsBaseViewController.h"

#import "CURDNavigationController.h"

@interface CurrentDonationsBaseViewController ()

@end

@implementation CurrentDonationsBaseViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // This is a queue of events that would be triggered
        //  when viewDidAppear is called. Once an event is
        //  triggered, it is then removed from the queue.
        self.didViewAppearOneTimeEventsQueue = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setModuleController:((CURDNavigationController *)self.navigationController).moduleController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //
    // Trigger events on the didViewAppearOneTimeEventsQueue
    //
    for (void (^event)(void) in self.didViewAppearOneTimeEventsQueue) {
        event();
    }
    [self.didViewAppearOneTimeEventsQueue removeAllObjects];
}

@end
