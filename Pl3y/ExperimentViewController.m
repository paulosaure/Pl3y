//
//  ExperimentViewController.m
//  Pl3y
//
//  Created by Paul Lavoine on 26/01/2016.
//  Copyright © 2016 InteraXon. All rights reserved.
//

#import "ExperimentViewController.h"

@interface ExperimentViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UIView *actionContentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

// Data
@property (nonatomic, strong) NSMutableArray *alphaRelativeArray;
@property (nonatomic, strong) NSMutableArray *betaRelativeArray;
@property (nonatomic, strong) NSMutableArray *gammaRelativeArray;
@property (nonatomic, strong) NSMutableArray *deltaRelativeArray;
@property (nonatomic, strong) NSMutableArray *thetaRelativeArray;
@property (nonatomic, strong) NSMutableArray *mellowArray;
@property (nonatomic, strong) NSMutableArray *concentrationArray;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger *seconde;

@end

@implementation ExperimentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init listener
    NSArray *listenedObjects = @[ @(IXNMuseDataPacketTypeAlphaRelative),
                                  @(IXNMuseDataPacketTypeBetaRelative),
                                  @(IXNMuseDataPacketTypeDeltaRelative),
                                  @(IXNMuseDataPacketTypeGammaRelative),
                                  @(IXNMuseDataPacketTypeThetaRelative),
                                  @(IXNMuseDataPacketTypeConcentration),
                                  @(IXNMuseDataPacketTypeMellow)
                                  ];
    
    [RootViewController setMuseWithListener:listenedObjects];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataNotification:) name:dataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConcentrationNotification:) name:contentrationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMellowNotification:) name:mellowNotification object:nil];
}

- (void)handleConcentrationNotification:(NSNotification *)notification
{
    [self.concentrationArray addObject:[self valueWithNotification:notification]];
}

- (void)handleMellowNotification:(NSNotification *)notification
{
    [self.mellowArray addObject:[self valueWithNotification:notification]];
}

- (void)handleDataNotification:(NSNotification *)notification
{
    IXNMuseDataPacket *packet = notification.object;
    NSNumber *value = [self valueWithNotification:notification];
    
    switch (packet.packetType) {
        case IXNMuseDataPacketTypeAlphaRelative:
            [self.alphaRelativeArray addObject:value];
            break;
        case IXNMuseDataPacketTypeBetaRelative:
            [self.betaRelativeArray addObject:value];
            break;
        case IXNMuseDataPacketTypeDeltaRelative:
            [self.deltaRelativeArray addObject:value];
            break;
        case IXNMuseDataPacketTypeThetaRelative:
            [self.thetaRelativeArray addObject:value];
            break;
        case IXNMuseDataPacketTypeGammaRelative:
            [self.gammaRelativeArray addObject:value];
            break;
        default:
            NSLog(@"Packet type should not be send : %ld", (long)packet.packetType);
            break;
    }
}

#pragma mark - Actions

- (IBAction)startTimer:(id)sender
{
    self.alphaRelativeArray = [NSMutableArray array];
    self.betaRelativeArray = [NSMutableArray array];
    self.gammaRelativeArray = [NSMutableArray array];
    self.deltaRelativeArray = [NSMutableArray array];
    self.thetaRelativeArray = [NSMutableArray array];
    self.mellowArray = [NSMutableArray array];
    self.concentrationArray = [NSMutableArray array];
    
   self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(increaseTimeCount) userInfo:nil repeats:YES];
    self.seconde = 0;
    [self.timer fire];
}


- (IBAction)stopTimer:(id)sender
{
    [self.timer invalidate];
    [self writeDataInJson];
}

#pragma mark - Utils

- (void)writeDataInJson
{
    
}

- (void)increaseTimeCount
{
    self.seconde++;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.seconde];
}

- (NSNumber *)valueWithNotification:(NSNotification *)notification
{
    NSArray *packet = notification.object;
    return (NSNumber *)[packet objectAtIndex:0];
}

- (void)dealloc
{
    [self.timer invalidate];
}


@end