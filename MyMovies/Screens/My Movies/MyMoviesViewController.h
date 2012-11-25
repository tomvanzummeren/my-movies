@class ListViewController;

#import "MoviesRepository.h"

@interface MyMoviesViewController : UIViewController<UITabBarDelegate> {

    __weak IBOutlet UITabBar *tabBar;
}
- (void)moveMovie:(NSInteger)sourceRow toRow:(NSInteger)destinationRow;
@end