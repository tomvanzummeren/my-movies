#import "MyMoviesViewController.h"
#import "MovieListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "MovieSearchViewController.h"

@implementation MyMoviesViewController {

    MovieListViewController *movieListViewController;

    TheMovieDbApiConnector *movieRepository;

    MoviesCoreData *moviesCoreData;

    MovieListType selectedList;
}

- (void) viewDidLoad {
    movieRepository = [TheMovieDbApiConnector instance];
    moviesCoreData = [MoviesCoreData instance];

    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = YES;

    __weak MyMoviesViewController *weakSelf = self;
    movieListViewController.movieDeleted = ^(Movie *movie) {
        [weakSelf deleteMovie:movie];
    };

    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;

    movieListViewController.movies = [moviesCoreData getMovies:ToWatchList];
    tabBar.selectedItem = [tabBar.items objectAtIndex:0];
}

- (void) deleteMovie:(Movie *) movie {
    [moviesCoreData deleteMovie:movie withType:selectedList];
}

- (void) tabBar:(UITabBar *) tb didSelectItem:(UITabBarItem *) item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    [movieListViewController setEditing:NO];
    if (selectedItemIndex == 0) {
        movieListViewController.moviesReorderable = YES;
        movieListViewController.movies = [moviesCoreData getMovies:ToWatchList];
        selectedList = ToWatchList;
    } else {
        movieListViewController.moviesReorderable = NO;
        movieListViewController.movies = [moviesCoreData getMovies:WatchedList];
        selectedList = WatchedList;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"SearchMovies"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        MovieSearchViewController *searchViewController = (MovieSearchViewController *) navigationController.topViewController;
        searchViewController.onMovieSelected = ^(Movie *movie) {
            if (selectedList == ToWatchList) {
                [movieRepository addToToWatchList:movie];
                [movieListViewController addMovie:movie];
                [moviesCoreData addMovie:movie withType:ToWatchList];
            } else if (selectedList == WatchedList) {
                [movieRepository addToWatchedList:movie];
                [movieListViewController addMovie:movie];
                [moviesCoreData addMovie:movie withType:WatchedList];
            }
        };
    }
}

@end