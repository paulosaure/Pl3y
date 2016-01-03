//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import "TrainingViewController.h"
#import "MuseController.h"

@interface TrainingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mellowLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstSensor;
@property (weak, nonatomic) IBOutlet UILabel *secondSensor;
@property (weak, nonatomic) IBOutlet UILabel *thirdSensor;
@property (weak, nonatomic) IBOutlet UILabel *fourthSensor;

// Data
@property (nonatomic, strong) NSArray *selectedStates;

@end

@implementation TrainingViewController


#pragma mark - Initializer

- (instancetype)initWithStates:(NSArray *)states
{
    if (self = [super init])
    {
        _selectedStates = states;
    }
    
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.informationLabel.textColor = [UIColor blueColor];
    self.mellowLabel.textColor = [UIColor blueColor];
    self.firstSensor.textColor = [UIColor blueColor];
    self.secondSensor.textColor = [UIColor blueColor];
    self.thirdSensor.textColor = [UIColor blueColor];
    self.fourthSensor.textColor = [UIColor blueColor];
    self.informationLabel.text = @"Waiting ...";
    
    [self changeColorBackground:[UIColor brownColor]];
    
    // Init listener
    [RootViewController setMuseWithListener:self.selectedStates];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConcentrationNotification:) name:contentrationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMellowNotification:) name:mellowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHorsesShoeNotification:) name:horsesShoeNotification object:nil];
}

- (void)changeColorBackground:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (void)handleHorsesShoeNotification:(NSNotification*)note
{
    NSArray *packet = note.object;
    self.firstSensor.text = [NSString stringWithFormat:@"%.f  - ",[[packet objectAtIndex:0] floatValue]];
    self.secondSensor.text = [NSString stringWithFormat:@"%.f  - ",[[packet objectAtIndex:1] floatValue]];
    self.thirdSensor.text = [NSString stringWithFormat:@"%.f  - ",[[packet objectAtIndex:2] floatValue]];
    self.fourthSensor.text = [NSString stringWithFormat:@"%.f",[[packet objectAtIndex:3] floatValue]];
}

- (void)handleMellowNotification:(NSNotification*)note
{
    NSArray *packet = note.object;
    NSNumber *value = (NSNumber *)[packet objectAtIndex:0];
    CGFloat floatValue = [value floatValue];
    
    
    self.mellowLabel.text = [NSString stringWithFormat:@"Mellow : %f", floatValue];
    
    UIColor *color = [UIColor colorWithRed:floatValue green:0 blue:0 alpha:1];
    [self changeColorBackground:color];
}

- (void)handleConcentrationNotification:(NSNotification*)note
{
    NSArray *packet = note.object;
    NSNumber *value = (NSNumber *)[packet objectAtIndex:0];
    CGFloat floatValue = [value floatValue];
    
    
    self.informationLabel.text = [NSString stringWithFormat:@"Conc : %f", floatValue];
    
    //    UIColor *color = [UIColor colorWithRed:floatValue green:0 blue:0 alpha:1];
    //    [self changeColorBackground:color];
}

@end