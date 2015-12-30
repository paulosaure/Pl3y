//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import <UIKit/UIKit.h>

#define batteryNotification         @"batteryNotification"
#define accelerometerNotification   @"accelerometerNotification"
#define contentrationNotification   @"contentrationNotification"
#define mellowNotification          @"mellowNotification"
#define horsesShoeNotification      @"horsesShoeNotification"
#define alphaNotification           @"alphaNotification"
#define betaNotification            @"betaNotification"
#define gammaNotification           @"gammaNotification"
#define thetaNotification           @"thetaNotification"
#define deltaNotification           @"deltaNotification"

#define CustomViewControllerID @"CustomViewControllerID"

@interface CustomViewController : UIViewController

- (void)changeColorBackground:(UIColor *)color;

// Outputs
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end

