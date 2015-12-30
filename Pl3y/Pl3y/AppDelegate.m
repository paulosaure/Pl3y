//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MuseController.h"

#define MAIN_STORYBOARD     @"Main"

@interface AppDelegate ()

@property (nonatomic, strong) MenuViewController *menuViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Instantiate firt View controller
    UINavigationController *navController = (UINavigationController *)[[UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:nil] instantiateInitialViewController];
    
    // Retrieve master
    self.menuViewController = (MenuViewController *)navController.topViewController;
    
    // Init window
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [MuseController sharedInstance].muse = nil;
}

@end
