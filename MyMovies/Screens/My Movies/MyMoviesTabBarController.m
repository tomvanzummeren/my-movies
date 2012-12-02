//
// Created by tomvanzummeren on 12/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MyMoviesTabBarController.h"
#import "ListViewController.h"
#import "SearchViewController.h"
#import "MoviesRepository.h"
#import "ToWatchListController.h"
#import "WatchedListController.h"


@implementation MyMoviesTabBarController

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"SearchMovies"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SearchViewController *searchViewController = (SearchViewController *) navigationController.topViewController;
        searchViewController.onMovieSelected = ^(Movie *movie) {
            // Delegate either to the watched list or to watch list (depending on selected tab)
            if ([self.selectedViewController isKindOfClass:[WatchedListController class]]) {
                [(WatchedListController *)self.selectedViewController addMovie:movie];
            } else if ([self.selectedViewController isKindOfClass:[ToWatchListController class]]) {
                [(ToWatchListController *)self.selectedViewController addMovie:movie];
            }
        };
    }
}

@end