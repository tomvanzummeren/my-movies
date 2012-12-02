#import "WatchedListController.h"
#import "ListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "Settings.h"

#define SEGMENT_DATE_ADDED 0
#define SEGMENT_ALPHABET 1
#define SEGMENT_RATING 2

@implementation WatchedListController {

    ListViewController *movieListViewController;

    TheMovieDbApiConnector *apiConnector;

    MoviesRepository *moviesRepository;

    NSString *sortOn;

    BOOL ascending;
}

- (void) viewDidLoad {
    apiConnector = [TheMovieDbApiConnector instance];
    moviesRepository = [MoviesRepository instance];

    movieListViewController = self.childViewControllers[0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = NO;

    weakInBlock WatchedListController *weakSelf = self;
    movieListViewController.movieDeleted = ^(Movie *movie) {
        [weakSelf->moviesRepository deleteMovie:movie];
    };

    Settings *settings = [Settings instance];
    segmentedControl.selectedSegmentIndex = settings.watchedListSelectedSorting;
    [self sortOrderChanged];
}

- (void) viewWillAppear:(BOOL) animated {
    [movieListViewController setEditing:NO];
    // Configure the edit button on the top view controller (the tab bar controller)
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;
    self.navigationController.topViewController.navigationItem.title = self.title;
}

- (void) reloadMovies {
    movieListViewController.movies = [moviesRepository getMovies:WatchedList sortBy:sortOn ascending:ascending];
}

#pragma Segmented Control

- (IBAction) sortOrderChanged {

    NSInteger segmentIndex = segmentedControl.selectedSegmentIndex;

    if (segmentIndex == SEGMENT_DATE_ADDED) {
        NSLog(@"Sort on date");
        sortOn = @"releaseDate";
        ascending = NO;
    }
    if (segmentIndex == SEGMENT_ALPHABET) {
        NSLog(@"Sort on alphabet");
        sortOn = @"title";
        ascending = YES;
    }
    if (segmentIndex == SEGMENT_RATING) {
        NSLog(@"Sort on rating");
        sortOn = @"voteAverage";
        ascending = NO;
    }

    [self reloadMovies];

    Settings *settings = [Settings instance];
    settings.watchedListSelectedSorting = segmentIndex;
}


- (void) addMovie:(Movie *) movie {
    [moviesRepository addMovie:movie withType:WatchedList];
    [movieListViewController addMovie:movie];
}
@end