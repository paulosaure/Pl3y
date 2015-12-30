//
//  InnerRootViewController.m
//  MuseStatsIos
//
//  Created by Paul Lavoine on 29/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import "InnerRootViewController.h"
#import "MuseController.h"

@implementation InnerRootViewController

+ (void)initMuseWithListener:(NSArray *)listeners
{
    MuseController *muse = [[MuseController alloc] init];
    muse.listenedObjects = listeners;
    [muse resumeInstance];
}

@end
