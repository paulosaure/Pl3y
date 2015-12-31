//
//  RootAwareViewController.h
//  CityGuide
//
//  Created by Cyril Chandelier on 16/04/15.
//  Copyright (c) 2015 Big Boss Studio. All rights reserved.
//

#import "RootViewController.h"



@interface RootAwareViewController : UIViewController

/**
 Extracted root for easy access, usually navigation controller parent view controller
 */
@property (nonatomic, strong, readonly) RootViewController *rootViewController;

@end
