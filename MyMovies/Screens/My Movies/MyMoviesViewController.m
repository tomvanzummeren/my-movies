#import "MyMoviesViewController.h"
#import "ListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "SearchViewController.h"
#import "Settings.h"

#define SEGMENT_DATE_ADDED 0
#define SEGMENT_ALPHABET 1
#define SEGMENT_RATING 2

@implementation MyMoviesViewController {

    ListViewController *movieListViewController;

    TheMovieDbApiConnector *apiConnector;

    MoviesRepository *moviesRepository;

    MovieListType selectedList;
    
    NSString *sortOn;
    BOOL ascending;
}

- (void)viewDidLoad {
    apiConnector = [TheMovieDbApiConnector instance];
    moviesRepository = [MoviesRepository instance];

    movieListViewController = self.childViewControllers[0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = YES;

    weakInBlock MyMoviesViewController *weakSelf = self;
    movieListViewController.movieDeleted = ^(Movie *movie) {
        [weakSelf->moviesRepository deleteMovie:movie];
    };

    movieListViewController.movieMoved = ^(NSNumber *sourceRow, NSNumber *destinationRow) {
        [weakSelf->moviesRepository moveMovieFrom:sourceRow toRow:destinationRow withType:weakSelf->selectedList];
    };

    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;

    tabBar.selectedItem = tabBar.items[0];

    Settings *settings = [Settings instance];
    segmentedControl.selectedSegmentIndex = settings.watchedListSelectedSorting;
    [self sortOrderChanged];
}

- (void)tabBar:(UITabBar *)tb didSelectItem:(UITabBarItem *)item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    [movieListViewController setEditing:NO];
    if (selectedItemIndex == 0) {
        selectedList = ToWatchList;
        movieListViewController.moviesReorderable = YES;
    } else {
        selectedList = WatchedList;
        movieListViewController.moviesReorderable = NO;
    }
   [self reloadMovies];
}

- (void)reloadMovies {
    movieListViewController.movies = [moviesRepository getMovies:selectedList sortBy:sortOn ascending:ascending];

    NSLog(@"%@", @(movieListViewController.movies.count));
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchMovies"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SearchViewController *searchViewController = (SearchViewController *) navigationController.topViewController;
        searchViewController.onMovieSelected = ^(Movie *movie) {
            [moviesRepository addMovie:movie withType:selectedList];
            [movieListViewController addMovie:movie];
        };
    }
}

#pragma Segmented Control

- (IBAction)sortOrderChanged {

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


@end