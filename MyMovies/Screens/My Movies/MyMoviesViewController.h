@class MovieListViewController;

#import "MoviesCoreData.h"

@interface MyMoviesViewController : UIViewController<UITabBarDelegate> {

    __weak IBOutlet UITabBar *tabBar;

    __weak MoviesCoreData *moviesCoreData;
}
@end