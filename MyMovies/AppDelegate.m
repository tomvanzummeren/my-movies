#import "AppDelegate.h"
#import "ManagedObjectContextProvider.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    return YES;
}

- (void) applicationWillTerminate:(UIApplication *) application {
    [[ManagedObjectContextProvider instance] saveContext];
}
@end
