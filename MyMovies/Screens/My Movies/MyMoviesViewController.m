
#import "MyMoviesViewController.h"
#import "MovieListViewController.h"
#import "MovieRepository.h"

@implementation MyMoviesViewController {
    MovieListViewController *movieListViewController;
    MovieRepository *movieRepository;
}

- (void) viewDidLoad {
    movieRepository = [MovieRepository instance];

    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    movieListViewController.movies = [movieRepository toWatchList];

    tabBar.selectedItem = [tabBar.items objectAtIndex:0];
}

- (void) tabBar:(UITabBar *) tb didSelectItem:(UITabBarItem *) item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    if (selectedItemIndex == 0) {
        movieListViewController.movies = [movieRepository toWatchList];
    } else {
        movieListViewController.movies = [movieRepository watchedList];
    }
}

@end