//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import "AppDelegate.h"
#import "MuseController.h"
#import "MenuViewController.h"

#define MAIN_STORYBOARD     @"Main"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = [[RootViewController alloc] initRootViewControllerWithDelegate:self];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MuseController sharedInstance].muse = nil;
}

@end
