//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import <UIKit/UIKit.h>

#define TrainingViewControllerID @"TrainingViewControllerID"

@interface TrainingViewController : RootAwareViewController

- (instancetype)initWithStates:(NSArray *)states;
- (void)changeColorBackground:(UIColor *)color;

@end

