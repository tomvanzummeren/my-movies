@class ListViewController;

#import "MoviesRepository.h"

@interface MyMoviesViewController : UIViewController<UITabBarDelegate> {

    __weak IBOutlet UITabBar *tabBar;
    __weak IBOutlet UISegmentedControl *segmentedControl;
}

- (IBAction) sortOrderChanged;

@end