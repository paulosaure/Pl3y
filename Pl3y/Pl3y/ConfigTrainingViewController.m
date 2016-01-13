//
//  ConfigTrainingViewController.m
//  MuseStatsIos
//
//  Created by Paul Lavoine on 29/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import "ConfigTrainingViewController.h"
#import "TrainingViewController.h"
#import "MuseController.h"

@interface ConfigTrainingViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UIButton *concentrationButton;
@property (weak, nonatomic) IBOutlet UIButton *mellowButton;
@property (weak, nonatomic) IBOutlet UIButton *startTrainingButton;

@end

@implementation ConfigTrainingViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *checkedImage = [UIImage imageNamed:@"checkedImage.png"];
    UIImage *uncheckedImage = [UIImage imageNamed:@"uncheckedImage.png"];
    [self.concentrationButton setImage:uncheckedImage forState:UIControlStateNormal];
    [self.concentrationButton setImage:checkedImage forState:UIControlStateSelected];
    [self.mellowButton setImage:uncheckedImage forState:UIControlStateNormal];
    [self.mellowButton setImage:checkedImage forState:UIControlStateSelected];
    self.concentrationButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.mellowButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.startTrainingButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.startTrainingButton.layer.borderWidth = 6.0f;
    self.startTrainingButton.layer.cornerRadius = 8.0f;
}


#pragma mark - Actions

- (IBAction)selectSpiritState:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)startTraining:(UIButton *)sender
{
    NSMutableArray *states = [NSMutableArray array];
    if (self.concentrationButton.selected)
    {
        [states addObject:@(IXNMuseDataPacketTypeConcentration)];
    }
    if (self.mellowButton.selected)
    {
        [states addObject:@(IXNMuseDataPacketTypeMellow)];
    }
    
    TrainingViewController *trainingViewController = [[TrainingViewController alloc] initWithStates:states];
    [self.navigationController pushViewController:trainingViewController animated:YES];
}

@end
