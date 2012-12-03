#import "ToWatchListController.h"
#import "ListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "SearchViewController.h"

#define SEGMENT_DATE_ADDED 0
#define SEGMENT_ALPHABET 1
#define SEGMENT_RATING 2

@implementation ToWatchListController {

    ListViewController *movieListViewController;

    TheMovieDbApiConnector *apiConnector;

    MoviesRepository *moviesRepository;
}

- (void) viewDidLoad {
    apiConnector = [TheMovieDbApiConnector instance];
    moviesRepository = [MoviesRepository instance];

    movieListViewController = self.childViewControllers[0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = YES;

    weakInBlock ToWatchListController *weakSelf = self;
    movieListViewController.movieDeleted = ^(Movie *movie) {
        [weakSelf->moviesRepository deleteMovie:movie];
    };

    movieListViewController.movieMoved = ^(NSNumber *sourceRow, NSNumber *destinationRow) {
        [weakSelf->moviesRepository moveMovieFrom:sourceRow toRow:destinationRow withType:ToWatchList];
    };

    [self reloadMovies];
}

- (void) viewWillAppear:(BOOL) animated {
    [movieListViewController setEditing:NO];
    // Configure the edit button on the top view controller (the tab bar controller)
    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;
}

- (void) reloadMovies {
    movieListViewController.movies = [moviesRepository getMovies:ToWatchList sortBy:@"order" ascending:NO];
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"SearchMovies"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SearchViewController *searchViewController = (SearchViewController *) navigationController.topViewController;
        searchViewController.onMovieSelected = ^(Movie *movie) {
            [moviesRepository addMovie:movie withType:ToWatchList];
            [movieListViewController addMovie:movie];
        };
    }
}

@end