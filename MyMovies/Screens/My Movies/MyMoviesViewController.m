
#import "MyMoviesViewController.h"
#import "MovieListViewController.h"

@implementation MyMoviesViewController {
    MovieListViewController *movieListViewController;
}

- (void) viewDidLoad {
    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    movieListViewController.numberOfMovies = 1;

    tabBar.selectedItem = [tabBar.items objectAtIndex:0];
}

- (void) tabBar:(UITabBar *) tb didSelectItem:(UITabBarItem *) item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    if (selectedItemIndex == 0) {
        movieListViewController.numberOfMovies = 1;
    } else {
        movieListViewController.numberOfMovies = 0;
    }
}

@end