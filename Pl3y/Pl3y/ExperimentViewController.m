//
//  ExperimentViewController.m
//  MuseStatsIos
//
//  Created by Paul Lavoine on 29/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import "ExperimentViewController.h"
#import "MuseController.h"

@import Charts;

@interface ExperimentViewController () <ChartViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mellowLabel;


@end

@implementation ExperimentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mellowLabel.textColor = [UIColor blueColor];
    
    // Init listener
    NSArray *listenedObjects = @[ @(IXNMuseDataPacketTypeAlphaRelative),
                                  @(IXNMuseDataPacketTypeBetaRelative),
                                  @(IXNMuseDataPacketTypeDeltaRelative),
                                  @(IXNMuseDataPacketTypeGammaRelative),
                                  @(IXNMuseDataPacketTypeThetaRelative)
                                ];
    [RootViewController setMuseWithListener:listenedObjects];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handledataNotification:) name:dataNotification object:nil];
}

- (void)handledataNotification:(NSNotification*)note
{
    NSArray *packet = note.object;
    NSNumber *value = (NSNumber *)[packet objectAtIndex:0];
    CGFloat floatValue = [value floatValue];
    
    
    self.mellowLabel.text = [NSString stringWithFormat:@"Mellow : %f", floatValue];
    

}



@end
