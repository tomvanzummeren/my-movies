@class ListViewController;

#import "MoviesRepository.h"

@interface WatchedListController : UIViewController<UITabBarDelegate> {

    __weak IBOutlet UITabBar *tabBar;
    __weak IBOutlet UISegmentedControl *segmentedControl;
}

- (IBAction) sortOrderChanged;

@end