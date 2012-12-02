//
// Created by jimvanzummeren on 12/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "Settings.h"
#define WATCHED_LIST_SELECTED_SORTING @"watchedListSelectedSorting"

@implementation Settings {

}

+ (Settings *)instance {
    RETURN_SINGLETON(Settings)
}

- (void) setWatchedListSelectedSorting: (int) watchedListSelectedSorting {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:watchedListSelectedSorting forKey:WATCHED_LIST_SELECTED_SORTING];
    [userDefaults synchronize];
}

- (int) watchedListSelectedSorting {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:WATCHED_LIST_SELECTED_SORTING];
}
@end