//
//  BatteryViewController.m
//  Pl3y
//
//  Created by Paul Lavoine on 02/01/2016.
//  Copyright © 2016 InteraXon. All rights reserved.
//

#import "BatteryViewController.h"

@interface BatteryViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UIView *batteryContentView;
@property (weak, nonatomic) IBOutlet UIView *batteryRemainingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *batteryRemainingTrailingConstant;

@end

@implementation BatteryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.batteryContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.batteryContentView.layer.borderWidth = 1.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBatteryNotification:) name:batteryNotification object:nil];
}

#pragma mark - Notification

- (void)receiveBatteryNotification:(NSNotification *)notification
{
    NSArray *packet = notification.object;
    NSNumber *value = (NSNumber *)[packet objectAtIndex:0];
    [self changePowerBatteryViewColor:[value floatValue]];
}

#pragma mark - Util

- (void)changePowerBatteryViewColor:(CGFloat)power
{
    CGFloat constant = (100 - power) * CGRectGetWidth(self.batteryContentView.frame) / 100;
    self.batteryRemainingTrailingConstant.constant = constant;
    
    if (power <= 20)
    {
        self.batteryRemainingView.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.batteryRemainingView.backgroundColor = [UIColor greenColor];
    }
}

@end
