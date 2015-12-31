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

#define HEIGHT_SENSORS_VIEW     45

@interface RootViewController () <UINavigationControllerDelegate>

// Outlets
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIView *supportView;
@property (nonatomic, weak) IBOutlet UIView *sensorView;

//@property (weak, nonatomic) IBOutlet UILabel *firstSensor;
//@property (weak, nonatomic) IBOutlet UILabel *secondSensor;
//@property (weak, nonatomic) IBOutlet UILabel *thirdSensor;
//@property (weak, nonatomic) IBOutlet UILabel *fourthSensor;

// Navigation stack
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation RootViewController

#pragma mark - Constructor

- (instancetype)initRootViewController
{
    if (self = [super initWithNibName:@"RootViewController" bundle:nil])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:MenuViewControllerID];

        self.navigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
        self.navigationController.delegate = self;
        self.navigationController.navigationBarHidden = YES;
        [self addChildViewController:self.navigationController];
    }
    
    return self;
}

+ (void)initMuseWithListener:(NSArray *)listeners
{
    MuseController *muse = [MuseController sharedInstance];
    [muse.muse unregisterAllListeners];
    muse.listenedObjects = listeners;
    [[MuseController sharedInstance] registerDataListener];
    [muse resumeInstance];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backButton.hidden = YES;
    
    // Display the content of the navigation controller into the support view
    [self.supportView addSubview:self.navigationController.view];
    self.navigationController.view.frame = self.supportView.bounds;
    
    [self.view bringSubviewToFront:self.sensorView];
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

@end
