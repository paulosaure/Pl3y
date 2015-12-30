//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import <UIKit/UIKit.h>

#define CustomViewControllerID @"CustomViewControllerID"

@interface CustomViewController : InnerRootViewController

- (void)changeColorBackground:(UIColor *)color;

// Outputs
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end

