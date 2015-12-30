//
//  ExperimentViewController.m
//  MuseStatsIos
//
//  Created by Paul Lavoine on 29/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import "ExperimentViewController.h"
#import "MuseController.h"
#define mellowNotification          @"mellowNotification"

@interface ExperimentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mellowLabel;


@end

@implementation ExperimentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mellowLabel.textColor = [UIColor blueColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMellowNotification:) name:mellowNotification object:nil];
    
    MuseController *muse = [[MuseController alloc] init];
    
    NSMutableArray *listenedObjects = [NSMutableArray array];
        [listenedObjects addObject:@(IXNMuseDataPacketTypeMellow)];
    muse.listenedObjects = listenedObjects;
    [muse resumeInstance];
}

- (void)handleMellowNotification:(NSNotification*)note
{
    NSArray *packet = note.object;
    NSNumber *value = (NSNumber *)[packet objectAtIndex:0];
    CGFloat floatValue = [value floatValue];
    
    
    self.mellowLabel.text = [NSString stringWithFormat:@"Mellow : %f", floatValue];
    
    UIColor *color = [UIColor colorWithRed:floatValue green:0 blue:0 alpha:1];
}

@end
