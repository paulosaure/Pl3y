////
////  PieChartViewController.m
////  ChartsDemo
////
////  Created by Daniel Cohen Gindi on 17/3/15.
////
////  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
////  A port of MPAndroidChart for iOS
////  Licensed under Apache License 2.0
////
////  https://github.com/danielgindi/ios-charts
////
//
//#import "PieChartViewController.h"
//#import "MuseController.h"
//
//
//@interface PieChartViewController () <ChartViewDelegate>
//
//// Outlets
//@property (nonatomic, strong) IBOutlet PieChartView *chartView;
//
//// Data
//@property (nonatomic, strong) NSMutableArray *valueListenedObjects;
//@end
//
//@implementation PieChartViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    // Init listener
//    NSArray *listenedObjects = @[ @(IXNMuseDataPacketTypeAlphaRelative),
//                                  @(IXNMuseDataPacketTypeBetaRelative),
//                                  @(IXNMuseDataPacketTypeDeltaRelative),
//                                  @(IXNMuseDataPacketTypeGammaRelative),
//                                  @(IXNMuseDataPacketTypeThetaRelative)
//                                  ];
//    [RootViewController setMuseWithListener:listenedObjects];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataNotification:) name:dataNotification object:nil];
//    
//    self.valueListenedObjects = [NSMutableArray array];
//    
//    self.title = @"Pl3y Chart";
//    
//    self.chartView.delegate = self;
//    
//    self.chartView.usePercentValuesEnabled = YES;
//    self.chartView.holeTransparent = YES;
//    self.chartView.holeRadiusPercent = 0.58;
//    self.chartView.transparentCircleRadiusPercent = 0.61;
//    self.chartView.descriptionText = @"";
//    [self.chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
//    
//    self.chartView.drawCenterTextEnabled = YES;
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Pl3y Chart"];
//    [centerText setAttributes:@{
//                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f],
//                                NSParagraphStyleAttributeName: paragraphStyle,
//                                NSForegroundColorAttributeName: UIColor.grayColor
//                                } range:NSMakeRange(0, centerText.length)];
//
//    self.chartView.centerAttributedText = centerText;
//    
//    self.chartView.drawHoleEnabled = YES;
//    self.chartView.rotationAngle = 0.0;
//    self.chartView.rotationEnabled = YES;
//    self.chartView.highlightPerTapEnabled = YES;
//    
//    ChartLegend *l = self.chartView.legend;
//    l.position = ChartLegendPositionRightOfChart;
//    l.xEntrySpace = 10007.0;
//    l.yEntrySpace = 0.0;
//    
//    // Warning : Allows to hide legend
//    l.yOffset = 100000.0;
//    
//    [self setDataCount:[self.valueListenedObjects count]];
//    
//    [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
//}
//
//#pragma mark - Notifications
//
//- (void)handleDataNotification:(NSNotification*)note
//{
//    IXNMuseDataPacket *packet = note.object;
//    CGFloat value = [self averagePacketValue: packet.values];
//    
//    switch (packet.packetType) {
//        case IXNMuseDataPacketTypeAlphaRelative:
//            self.valueListenedObjects[0] = @(value);
//            break;
//        case IXNMuseDataPacketTypeBetaRelative:
//            self.valueListenedObjects[1] = @(value);
//            break;
//        case IXNMuseDataPacketTypeDeltaRelative:
//            self.valueListenedObjects[2] = @(value);
//            break;
//        case IXNMuseDataPacketTypeThetaRelative:
//            self.valueListenedObjects[3] = @(value);
//            break;
//        case IXNMuseDataPacketTypeGammaRelative:
//            self.valueListenedObjects[4] = @(value);
//            break;
//        default:
//            NSLog(@"Packet type should not be send : %ld", (long)packet.packetType);
//            break;
//    }
//    
//    [self setDataCount:[self.valueListenedObjects count]];
//}
//
//- (void)setDataCount:(NSInteger)count
//{
//    
//    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
//    
//    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
//    for (int i = 0; i < count; i++)
//    {
//        double test = [self.valueListenedObjects[i] floatValue] * 100;
//        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:test xIndex:i]];
//    }
//    
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < count; i++)
//    {
//        NSString *legendString = [self stringDataWithPacketType:i];
//        [xVals addObject:legendString];
//    }
//    
//    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@""];
//    dataSet.sliceSpace = 2.0;
//    
//    // add a lot of colors
//    NSMutableArray *colors = [[NSMutableArray alloc] init];
//    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
//    [colors addObjectsFromArray:ChartColorTemplates.joyful];
//    [colors addObjectsFromArray:ChartColorTemplates.colorful];
//    [colors addObjectsFromArray:ChartColorTemplates.liberty];
//    [colors addObjectsFromArray:ChartColorTemplates.pastel];
//    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
//    
//    dataSet.colors = colors;
//    
//    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
//    
//    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
//    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
//    pFormatter.maximumFractionDigits = 1;
//    pFormatter.multiplier = @1.f;
//    pFormatter.percentSymbol = @" %";
//    
//    [data setValueFormatter:pFormatter];
//    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
//    [data setValueTextColor:UIColor.blackColor];
//    
//    _chartView.data = data;
//    [_chartView highlightValues:nil];
//}
//
//#pragma mark - Utils
//
//- (CGFloat)averagePacketValue:(NSArray *)values
//{
//    NSInteger cptValideValue = 0;
//    CGFloat sumValideValue = 0;
//    for (int i = 0; i < [values count] ; i++)
//    {
//        CGFloat value = [(NSNumber *)values[i] floatValue];
//        
//        if (!isnan(value))
//        {
//            cptValideValue ++;
//            sumValideValue += value;
//        }
//    }
//    
//    return (sumValideValue/cptValideValue);
//}
//
//- (NSString *)stringDataWithPacketType:(NSInteger)packet
//{
//    NSString *packetType = @"";
//    
//    switch (packet) {
//        case 0:
//            packetType = @"Alpha";
//            break;
//        case 1:
//            packetType = @"Beta";
//            break;
//        case 2:
//            packetType = @"Delta";
//            break;
//        case 3:
//            packetType = @"Theta";
//            break;
//        case 4:
//            packetType = @"Gamma";
//            break;
//        default:
//            packetType = @"Type problem";
//            break;
//    }
//    
//    return packetType;
//}
//
//@end
