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
@property (nonatomic, strong) StateTrainingView *mellowView;
@property (nonatomic, strong) StateTrainingView *concentrationView;

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
    self.states = [NSMutableDictionary dictionary];
    for (NSNumber *state in self.selectedStates)
    {
        CGFloat height = CGRectGetHeight(self.view.frame)/numberOfStateView;
        
        switch ([state integerValue]) {
            case IXNMuseDataPacketTypeConcentration:
            {
                self.concentrationView = [[StateTrainingView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(previousView.frame), CGRectGetWidth(self.view.frame), height)];
                self.concentrationView.title = ConcentrationStateViewLabel;
                self.concentrationView.backgroundColor = [UIColor redColor];
                [self.states setObject:self.concentrationView forKey:@(IXNMuseDataPacketTypeConcentration)];
                [self.concentrationView stateLabelTitle:0.f];
                [self.view addSubview:self.concentrationView];
                previousView = self.concentrationView;
                break;
            }
            case IXNMuseDataPacketTypeMellow:
            {
                self.mellowView = [[StateTrainingView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(previousView.frame), CGRectGetWidth(self.view.frame), height)];
                self.mellowView.title = MellowStateViewLabel;
                self.mellowView.backgroundColor = [UIColor blueColor];
                [self.states setObject:self.mellowView forKey:@(IXNMuseDataPacketTypeMellow)];
                [self.mellowView stateLabelTitle:0.f];
                [self.view addSubview:self.mellowView];
                previousView = self.mellowView;
                break;
            }
            default:
                NSLog(@"Problem : Not a mellow or concentration view");
                break;
        }
    }
}

- (void)changeColorBackground:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (void)handleMellowNotification:(NSNotification *)note
{
    [self updateTrainingView:self.mellowView type:IXNMuseDataPacketTypeMellow value:[self valueWithNotification:note]];
}

- (void)handleConcentrationNotification:(NSNotification *)note
{
    [self updateTrainingView:self.concentrationView type:IXNMuseDataPacketTypeConcentration value:[self valueWithNotification:note]];
}

- (void)updateTrainingView:(StateTrainingView *)view type:(IXNMuseDataPacketType)type value:(CGFloat)value
{
    view = [self.states objectForKey:@(type)];
    [view stateLabelTitle:value];
    view.backgroundColor = [UIColor colorWithRed:value green:0 blue:0 alpha:1];
}

- (CGFloat)valueWithNotification:(NSNotification *)notification
{
    NSArray *packet = notification.object;
    NSNumber *value = (NSNumber *)[packet objectAtIndex:0];
    return [value floatValue]*100;
}

@end
