//
//  PieChartViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "PieChartViewController.h"
#import "MuseController.h"

@interface PieChartViewController ()

// Data
@property (nonatomic, strong) NSMutableArray *valueListenedObjects;

@end

@implementation PieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
    [self configureMuse];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)configureMuse
{
    self.valueListenedObjects = [NSMutableArray array];
    
    
    // Init listener
    NSArray *listenedObjects = @[ @(IXNMuseDataPacketTypeAlphaRelative),
                                  @(IXNMuseDataPacketTypeBetaRelative),
                                  @(IXNMuseDataPacketTypeDeltaRelative),
                                  @(IXNMuseDataPacketTypeGammaRelative),
                                  @(IXNMuseDataPacketTypeThetaRelative)
                                  ];
    [RootViewController setMuseWithListener:listenedObjects];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataNotification:) name:dataNotification object:nil];
}

- (void)configureUI
{
   
}

#pragma mark - Notifications

- (void)handleDataNotification:(NSNotification*)note
{
    IXNMuseDataPacket *packet = note.object;
    CGFloat value = [self averagePacketValue: packet.values];
    
    switch (packet.packetType) {
        case IXNMuseDataPacketTypeAlphaRelative:
            self.valueListenedObjects[0] = @(value);
            break;
        case IXNMuseDataPacketTypeBetaRelative:
            self.valueListenedObjects[1] = @(value);
            break;
        case IXNMuseDataPacketTypeDeltaRelative:
            self.valueListenedObjects[2] = @(value);
            break;
        case IXNMuseDataPacketTypeThetaRelative:
            self.valueListenedObjects[3] = @(value);
            break;
        case IXNMuseDataPacketTypeGammaRelative:
            self.valueListenedObjects[4] = @(value);
            break;
        default:
            NSLog(@"Packet type should not be send : %ld", (long)packet.packetType);
            break;
    }
    
    [self setDataCount:[self.valueListenedObjects count]];
}

- (void)setDataCount:(NSInteger)count
{
    
    for (int i = 0; i < count; i++)
    {
        double test = [self.valueListenedObjects[i] floatValue] * 100;
        NSLog(@"test %f",test);
    }

}

#pragma mark - Utils

- (CGFloat)averagePacketValue:(NSArray *)values
{
    NSInteger cptValideValue = 0;
    CGFloat sumValideValue = 0;
    for (int i = 0; i < [values count] ; i++)
    {
        CGFloat value = [(NSNumber *)values[i] floatValue];
        
        if (!isnan(value))
        {
            cptValideValue ++;
            sumValideValue += value;
        }
    }
    
    return (sumValideValue/cptValideValue);
}

- (NSString *)stringDataWithPacketType:(NSInteger)packet
{
    NSString *packetType = @"";
    
    switch (packet) {
        case 0:
            packetType = @"Alpha";
            break;
        case 1:
            packetType = @"Beta";
            break;
        case 2:
            packetType = @"Delta";
            break;
        case 3:
            packetType = @"Theta";
            break;
        case 4:
            packetType = @"Gamma";
            break;
        default:
            packetType = @"Type problem";
            break;
    }
    
    return packetType;
}

@end
