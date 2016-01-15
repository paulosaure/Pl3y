//
//  StateTrainingView.h
//  Pl3y
//
//  Created by Paul Lavoine on 03/01/2016.
//  Copyright © 2016 InteraXon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ConcentrationStateViewLabel @"C"
#define MellowStateViewLabel        @"M"

@interface StateTrainingView : UIView

@property (nonatomic, strong) IBOutlet UIView *contentView;

// Data
@property (nonatomic, strong) NSString *title;

- (void)stateLabelTitle:(CGFloat)value;
- (instancetype)initWithFrame:(CGRect)frame;

@end
