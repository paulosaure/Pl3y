//
//  InnerRootViewController.h
//  Pl3y
//
//  Created by Paul Lavoine on 30/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface RootViewController : UIViewController

- (instancetype)initRootViewControllerWithDelegate:(AppDelegate *)delegate;
+ (void)setMuseWithListener:(NSArray *)listeners;

@end
