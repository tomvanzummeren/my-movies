#import "AppDelegate.h"
#import "ObjectManager.h"
#import "MyMoviesWindow.h"

@implementation AppDelegate {
    MyMoviesWindow *myMoviesWindow;

}

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    return YES;
}

- (UIWindow * ) window {
    if (!myMoviesWindow) {
        myMoviesWindow = [[MyMoviesWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return myMoviesWindow;
}

- (void) applicationWillTerminate:(UIApplication *) application {
    [[ObjectManager instance] saveContext];
}
@end
