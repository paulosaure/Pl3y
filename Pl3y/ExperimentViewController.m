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

@property (weak, nonatomic) IBOutlet UITextField *referenceTextField;
@property (weak, nonatomic) IBOutlet UITextField *initialTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *activityTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


// Data
@property (nonatomic, strong) NSMutableArray *alphaRelativeArray;
@property (nonatomic, strong) NSMutableArray *betaRelativeArray;
@property (nonatomic, strong) NSMutableArray *gammaRelativeArray;
@property (nonatomic, strong) NSMutableArray *deltaRelativeArray;
@property (nonatomic, strong) NSMutableArray *thetaRelativeArray;
@property (nonatomic, strong) NSMutableArray *mellowArray;
@property (nonatomic, strong) NSMutableArray *concentrationArray;

@property (nonatomic, strong) NSTimer *repeatingTimer;
@property (nonatomic, assign) NSInteger seconde;

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
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self.view addGestureRecognizer:singleFingerTap];
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
    NSArray *value = packet.values;
    
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
    
    [self.repeatingTimer invalidate];
    self.seconde = 0;
    self.resultLabel.text = @"";
    self.timeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.seconde];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(increaseTimeCount:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.repeatingTimer = timer;
}


- (IBAction)stopTimer:(id)sender
{
    [self.repeatingTimer invalidate];
    [self writeDataInJson];
}

#pragma mark - Utils

- (void)increaseTimeCount:(NSTimer*)theTimer
{
    self.seconde++;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.seconde];
}

- (NSNumber *)valueWithNotification:(NSNotification *)notification
{
    NSArray *packet = notification.object;
    return (NSNumber *)[packet objectAtIndex:0];
}

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

- (void)dealloc
{
    [self.repeatingTimer invalidate];
}

- (void)writeDataInJson
{
    NSString *namefile = self.referenceTextField.text ? self.referenceTextField.text : @"référence";
    
    [self writeMetaDataFile:[NSString stringWithFormat:@"%@_metadata.txt", namefile]];
    [self writeConcFile:[NSString stringWithFormat:@"%@_conc.txt", namefile]];
    [self writeMelFile:[NSString stringWithFormat:@"%@_mel.txt", namefile]];
    [self writeAlphaFile:[NSString stringWithFormat:@"%@_alpha.txt", namefile]];
    [self writeBetaFile:[NSString stringWithFormat:@"%@_beta.txt", namefile]];
    [self writeDeltaFile:[NSString stringWithFormat:@"%@_delta.txt", namefile]];
    [self writeGammaFile:[NSString stringWithFormat:@"%@_gamma.txt", namefile]];
    [self writeThetaFile:[NSString stringWithFormat:@"%@_theta.txt", namefile]];
    
    self.resultLabel.text = @"Results have been written";
}

- (void)writeMetaDataFile:(NSString *)nameFile
{
    NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@", self.initialTextField.text, self.fromTextField.text, self.activityTextField.text];
    [self writeFile:content path:nameFile];
}

- (void)writeConcFile:(NSString *)nameFile
{
    NSString *content = [self createSimpleArray:self.concentrationArray];
    [self writeFile:content path:nameFile];
}

- (void)writeMelFile:(NSString *)nameFile
{
    NSString *content = [self createSimpleArray:self.mellowArray];
    [self writeFile:content path:nameFile];
}

- (void)writeAlphaFile:(NSString *)nameFile
{
    NSString *content = [self createComplexArray:self.alphaRelativeArray];
    [self writeFile:content path:nameFile];
}

- (void)writeBetaFile:(NSString *)nameFile
{
    NSString *content = [self createComplexArray:self.betaRelativeArray];
    [self writeFile:content path:nameFile];
}

- (void)writeDeltaFile:(NSString *)nameFile
{
    NSString *content = [self createComplexArray:self.deltaRelativeArray];
    [self writeFile:content path:nameFile];
}

- (void)writeGammaFile:(NSString *)nameFile
{
    NSString *content = [self createComplexArray:self.gammaRelativeArray];
    [self writeFile:content path:nameFile];
}

- (void)writeThetaFile:(NSString *)nameFile
{
    NSString *content = [self createComplexArray:self.thetaRelativeArray];
    [self writeFile:content path:nameFile];
}

- (void)writeFile:(NSString *)text path:(NSString *)path
{
    NSError *error;
    
    // Get full path
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *fileName = path;
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    
    // Create file
    NSFileManager *filemgr = [NSFileManager defaultManager];
    [filemgr createFileAtPath:filePath contents:nil attributes: nil];
    
    // Write Data
    BOOL ok = [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (!ok) {
        NSLog(@"Error writing file at %@\n%@", path, [error localizedFailureReason]);
    }

//    NSLog(@"Path : %@", filePath);
}

- (NSString *)createSimpleArray:(NSArray *)array
{
    NSMutableString *content = [[NSMutableString alloc] init];
    for (NSInteger i = 0 ; i < [array count] ; i++)
    {
        [content appendString:[NSString stringWithFormat:@"%ld %@\n",(long)i ,array[i]]];
    }
    
    return content;
}

- (NSString *)createComplexArray:(NSArray *)array
{
    NSMutableString *content = [[NSMutableString alloc] init];
    for (NSInteger i = 0 ; i < [array count] ; i++)
    {
        [content appendString:[NSString stringWithFormat:@"%ld %@ %@ %@ %@\n",(long)i ,array[i][0], array[i][1], array[i][2], array[i][3]]];
    }
    
    return content;
}

#pragma mark - Utils

- (void)gestureRecognizer:(UISwipeGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

@end
