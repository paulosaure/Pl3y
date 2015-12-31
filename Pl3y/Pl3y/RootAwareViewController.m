//
//  RootAwareViewController.m
//  CityGuide
//
//  Created by Cyril Chandelier on 16/04/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

#import "RootAwareViewController.h"



@interface RootAwareViewController ()

// Root
@property (nonatomic, strong) RootViewController *rootViewController;

@end



@implementation RootAwareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Retrieve root
    if ([self.navigationController.parentViewController isKindOfClass:[RootViewController class]])
    {
        self.rootViewController = (RootViewController *)self.navigationController.parentViewController;
    }
}

@end
