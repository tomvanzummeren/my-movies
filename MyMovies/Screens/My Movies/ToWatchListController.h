@class ListViewController;

#import "MoviesRepository.h"

@interface ToWatchListController : UIViewController<UITabBarDelegate> {

    __weak IBOutlet UITabBar *tabBar;
    __weak IBOutlet UISegmentedControl *segmentedControl;
}

- (IBAction) sortOrderChanged;

@end