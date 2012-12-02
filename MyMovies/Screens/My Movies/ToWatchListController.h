@class ListViewController;

#import "MoviesRepository.h"

@interface ToWatchListController : UIViewController<UITabBarDelegate> {
}

- (void) addMovie:(Movie *) movie;
@end