//
//  InnerRootViewController.m
//  Pl3y
//
//  Created by Paul Lavoine on 30/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import "RootViewController.h"
#import "MuseController.h"
#import "MenuViewController.h"
#import "BatteryViewController.h"

#define HEIGHT_SENSORS_VIEW     45

@interface RootViewController () <UINavigationControllerDelegate>

// Outlets
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIView *supportView;
@property (nonatomic, weak) IBOutlet UIView *sensorView;
@property (weak, nonatomic) IBOutlet UIView *batteryView;
@property (weak, nonatomic) IBOutlet UIView *isConnected;

// Sensors outlets
@property (weak, nonatomic) IBOutlet UIView *firstSensor;
@property (weak, nonatomic) IBOutlet UIView *secondSensor;
@property (weak, nonatomic) IBOutlet UIView *thirdSensor;
@property (weak, nonatomic) IBOutlet UIView *fourthSensor;

// Navigation stack
@property (nonatomic, strong) BatteryViewController* batteryViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation RootViewController

#pragma mark - Constructor

- (instancetype)initRootViewControllerWithDelegate:(AppDelegate *)delegate
{
    if (self = [super initWithNibName:@"RootViewController" bundle:nil])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:MenuViewControllerID];

        self.navigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
        self.navigationController.delegate = self;
        self.navigationController.navigationBarHidden = YES;
        [self addChildViewController:self.navigationController];
        
        MuseController *muse = [MuseController sharedInstance];
        muse.delegate = delegate;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveConnectionNotification:) name:connectionNotification object:nil];
    }
    
    return self;
}

+ (void)setMuseWithListener:(NSArray *)listeners
{
    MuseController *muse = [MuseController sharedInstance];
    [muse.muse unregisterAllListeners];
    NSMutableArray *listenersList = [[NSMutableArray alloc] initWithArray:listeners];
    [listenersList addObject:@(IXNMuseDataPacketTypeBattery)];
    [listenersList addObject:@(IXNMuseDataPacketTypeHorseshoe)];
    muse.listenedObjects = listenersList;
    [muse registerDataListeners];
    [muse resumeInstance];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backButton.hidden = YES;
    
    [self configureSensorView];
    
    // Display the content of the navigation controller into the support view
    [self.supportView addSubview:self.navigationController.view];
    self.navigationController.view.frame = self.supportView.bounds;
    
    [self.view bringSubviewToFront:self.sensorView];
}

#pragma mark - Configuration

- (void)configureSensorView
{
    self.isConnected.layer.cornerRadius = ceil(CGRectGetWidth(self.isConnected.frame)/2);
    [self configureSensors];
    [self configureBatteryView];
}

- (void)configureSensors
{
    self.firstSensor.layer.cornerRadius = ceil(CGRectGetWidth(self.firstSensor.frame)/2);
    self.secondSensor.layer.cornerRadius = ceil(CGRectGetWidth(self.secondSensor.frame)/2);
    self.thirdSensor.layer.cornerRadius = ceil(CGRectGetWidth(self.thirdSensor.frame)/2);
    self.fourthSensor.layer.cornerRadius = ceil(CGRectGetWidth(self.fourthSensor.frame)/2);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHorsesShoesNotification:) name:horsesShoeNotification object:nil];
}

- (void)configureBatteryView
{
    self.batteryViewController = [[BatteryViewController alloc] init];
    self.batteryViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.batteryView.frame), CGRectGetHeight(self.batteryView.frame));
    [self.batteryView addSubview:self.batteryViewController.view];
}

#pragma mark - Notification

- (void)receiveHorsesShoesNotification:(NSNotification *)notification
{
    NSArray *sensors = notification.object;
    NSInteger i = 0;
    for (NSNumber *sensor in sensors)
    {
        switch (i) {
            case 0:
                self.firstSensor.backgroundColor = [self setColorSensorView:[sensor intValue]];
                break;
            case 1:
                self.secondSensor.backgroundColor = [self setColorSensorView:[sensor intValue]];
                break;
            case 2:
                self.thirdSensor.backgroundColor = [self setColorSensorView:[sensor intValue]];
                break;
            case 3:
                self.fourthSensor.backgroundColor = [self setColorSensorView:[sensor intValue]];
                break;
            default:
                NSLog(@"receiveHorsesShoesNotification : There is 5 sensors ?");
                break;
        }
        i++;
    }
}

- (void)receiveConnectionNotification:(NSNotification *)notification
{
    NSNumber *value = (NSNumber *) notification.object;
    switch ([value intValue]) {
        case IXNConnectionStateConnected:
            self.isConnected.backgroundColor = [UIColor greenColor];
            break;
        case IXNConnectionStateConnecting:
            self.isConnected.backgroundColor = [UIColor orangeColor];
            break;
        case IXNConnectionStateDisconnected:
        default:
            self.isConnected.backgroundColor = [UIColor redColor];
            break;
    }
}

#pragma mark - UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.backButton.userInteractionEnabled = NO;
    self.backButton.hidden = ([navigationController.viewControllers indexOfObject:viewController] == 0);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.backButton.userInteractionEnabled = YES;
}


#pragma mark - UI Actions

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Util

- (UIColor *)setColorSensorView:(NSInteger)value
{
    switch (value) {
        case 1:
            return [UIColor greenColor];
            break;
        case 2:
            return  [UIColor orangeColor];
            break;
        case 3:
        default:
            return [UIColor redColor];
            break;
    }
}

@end
