//
//  StateTrainingView.m
//  Pl3y
//
//  Created by Paul Lavoine on 03/01/2016.
//  Copyright © 2016 InteraXon. All rights reserved.
//

#import "StateTrainingView.h"

@interface StateTrainingView ()

// Outlets
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation StateTrainingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:@"StateTrainingView" owner:self options:nil];
    [self addConstraintToContentView];
}

- (void)addConstraintToContentView
{
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void)stateLabelTitle:(CGFloat)value
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@ : %.f%%", self.title, value ];
    self.titleLabel.textColor = [UIColor whiteColor];
}

@end
