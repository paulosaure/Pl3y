//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import "TrainingViewController.h"
#import "MuseController.h"
#import "StateTrainingView.h"

@interface TrainingViewController ()

// Outlets

// Data
@property (nonatomic, strong) NSMutableDictionary *states;
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
    
    [self changeColorBackground:[UIColor brownColor]];
    
    [self configureStatesView];
    
    // Init listener
    [RootViewController setMuseWithListener:self.selectedStates];
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConcentrationNotification:) name:contentrationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMellowNotification:) name:mellowNotification object:nil];
}

- (void)configureStatesView
{
    UIView *previousView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    NSInteger numberOfStateView = [self.selectedStates count];
    for (NSNumber *state in self.selectedStates)
    {
        CGFloat height = CGRectGetHeight(self.view.frame)/numberOfStateView;
        StateTrainingView *stateView = [[StateTrainingView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(previousView.frame), CGRectGetWidth(self.view.frame), height)];
        
        switch ([state integerValue]) {
            case IXNMuseDataPacketTypeConcentration:
            {
                stateView.title = ConcentrationStateViewLabel;
                stateView.backgroundColor = [UIColor redColor];
                [self.states setObject:stateView forKey:@(IXNMuseDataPacketTypeConcentration)];
                break;
            }
            case IXNMuseDataPacketTypeMellow:
            {
                stateView.title = MellowStateViewLabel;
                stateView.backgroundColor = [UIColor blueColor];
                [self.states setObject:stateView forKey:@(IXNMuseDataPacketTypeMellow)];
                break;
            }
            default:
                NSLog(@"Problem : Not a mellow or concentration view");
                break;
        }
        
        [stateView stateLabelTitle:0.f];
        [self.view addSubview:stateView];
        previousView = stateView;
    }
}

- (void)changeColorBackground:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (void)handleMellowNotification:(NSNotification*)note
{
    StateTrainingView *mellowView = [self.states objectForKey:@(IXNMuseDataPacketTypeMellow)];
    [mellowView stateLabelTitle:[self valueWithNotification:note]];
    
    //    self.mellowLabel.text = [NSString stringWithFormat:@"Mellow : %f", floatValue];
    //    UIColor *color = [UIColor colorWithRed:floatValue green:0 blue:0 alpha:1];
    //    [self changeColorBackground:color];
}

- (void)handleConcentrationNotification:(NSNotification*)note
{
    StateTrainingView *concentrationView = [self.states objectForKey:@(IXNMuseDataPacketTypeConcentration)];
    [concentrationView stateLabelTitle:[self valueWithNotification:note]];
    
    //    self.informationLabel.text = [NSString stringWithFormat:@"Conc : %f", floatValue];
    //    UIColor *color = [UIColor colorWithRed:floatValue green:0 blue:0 alpha:1];
    //    [self changeColorBackground:color];
}

- (CGFloat)valueWithNotification:(NSNotification *)notification
{
    NSArray *packet = notification.object;
    NSNumber *value = (NSNumber *)[packet objectAtIndex:0];
    return [value floatValue];
}

@end
