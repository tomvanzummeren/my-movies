#import "MyMoviesViewController.h"
#import "ListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "SearchViewController.h"

@implementation MyMoviesViewController {

    ListViewController *movieListViewController;

    TheMovieDbApiConnector *apiConnector;

    MoviesRepository *moviesRepository;

    MovieListType selectedList;
}

- (void) viewDidLoad {
    apiConnector = [TheMovieDbApiConnector instance];
    moviesRepository = [MoviesRepository instance];

    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = YES;

    __weak MyMoviesViewController *weakSelf = self;
    movieListViewController.movieDeleted = ^(Movie *movie) {
        [weakSelf deleteMovie:movie];
    };

    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;

    movieListViewController.movies = [moviesRepository getMovies:ToWatchList];
    tabBar.selectedItem = [tabBar.items objectAtIndex:0];
}

- (void) deleteMovie:(Movie *) movie {
    [moviesRepository deleteMovie:movie withType:selectedList];
}

- (void) tabBar:(UITabBar *) tb didSelectItem:(UITabBarItem *) item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    [movieListViewController setEditing:NO];
    if (selectedItemIndex == 0) {
        movieListViewController.moviesReorderable = YES;
        movieListViewController.movies = [moviesRepository getMovies:ToWatchList];
        selectedList = ToWatchList;
    } else {
        movieListViewController.moviesReorderable = NO;
        movieListViewController.movies = [moviesRepository getMovies:WatchedList];
        selectedList = WatchedList;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"SearchMovies"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SearchViewController *searchViewController = (SearchViewController *) navigationController.topViewController;
        searchViewController.onMovieSelected = ^(Movie *movie) {
            if (selectedList == ToWatchList) {
                [movieListViewController addMovie:movie];
                [moviesRepository addMovie:movie withType:ToWatchList];
            } else if (selectedList == WatchedList) {
                [movieListViewController addMovie:movie];
                [moviesRepository addMovie:movie withType:WatchedList];
            }
        };
    }
}

@end