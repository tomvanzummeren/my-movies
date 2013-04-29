#import "WatchedListController.h"
#import "ListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "Settings.h"
#import "SearchViewController.h"
#import "MovieList.h"

#define SEGMENT_DATE_ADDED 0
#define SEGMENT_ALPHABET 1
#define SEGMENT_RATING 2

@implementation WatchedListController {

    ListViewController *movieListViewController;

    TheMovieDbApiConnector *apiConnector;

    MoviesRepository *moviesRepository;

    // TODO: Maybe combine the below 4 fields in an object

    NSString *sortOn;

    BOOL ascending;

    SEL movieSectionSelector;
}

- (void) awakeFromNib {
    self.title = NSLocalizedString(@"Watched", nil);
}

- (void) viewDidLoad {
    apiConnector = [TheMovieDbApiConnector instance];
    moviesRepository = [MoviesRepository instance];

    movieListViewController = self.childViewControllers[0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = NO;
    movieListViewController.loadMovies = ^{
        NSMutableArray *movies = [moviesRepository getMovies:WatchedList sortBy:sortOn ascending:ascending];
        MovieList *movieList = [MovieList new];
        for (Movie *movie in movies) {
            if (movieSectionSelector) {
                [movieList addMovie:movie inSection:[movie performSelector:movieSectionSelector]];
            } else {
                [movieList addMovie:movie];
            }
        }
        return movieList;
    };

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
    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;
}

- (void) reloadMovies {
    [movieListViewController reloadMovies];
}

#pragma Segmented Control

- (IBAction) sortOrderChanged {
    NSInteger segmentIndex = segmentedControl.selectedSegmentIndex;

    if (segmentIndex == SEGMENT_DATE_ADDED) {
        sortOn = @"releaseDate";
        ascending = NO;
        movieSectionSelector = @selector(releaseYear);
        movieListViewController.sectionIndexTitles = nil;
    }
    if (segmentIndex == SEGMENT_ALPHABET) {
        sortOn = @"title";
        ascending = YES;
        movieSectionSelector = @selector(uppercaseFirstLetterOfTitle);
        movieListViewController.sectionIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K",
                @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    }
    if (segmentIndex == SEGMENT_RATING) {
        sortOn = @"voteAverage";
        ascending = NO;
        movieSectionSelector = nil;
        movieListViewController.sectionIndexTitles = nil;
    }

    [self reloadMovies];

    Settings *settings = [Settings instance];
    settings.watchedListSelectedSorting = segmentIndex;
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"SearchMovies"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SearchViewController *searchViewController = (SearchViewController *) navigationController.topViewController;
        searchViewController.onMovieSelected = ^(Movie *movie) {
            [moviesRepository addMovie:movie withType:WatchedList];
            [movieListViewController addMovie:movie];
        };
    }
}
@end