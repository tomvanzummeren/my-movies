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

    movieListViewController = [self.childViewControllers objectAtIndex:0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = YES;

    weakInBlock MyMoviesViewController *weakSelf = self;
    movieListViewController.movieDeleted = ^(Movie *movie) {
        [weakSelf->moviesRepository deleteMovie:movie withType:weakSelf->selectedList];
    };

    movieListViewController.movieMoved = ^(NSInteger sourceRow, NSInteger destinationRow) {
        [weakSelf->moviesRepository moveMovie:sourceRow toRow:destinationRow];
    };

    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;

    movieListViewController.movies = [moviesRepository getMovies:ToWatchList];
    tabBar.selectedItem = [tabBar.items objectAtIndex:0];
}

- (void) tabBar:(UITabBar *) tb didSelectItem:(UITabBarItem *) item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    [movieListViewController setEditing:NO];
    if (selectedItemIndex == 0) {
        selectedList = ToWatchList;
        movieListViewController.moviesReorderable = YES;
    } else {
        selectedList = WatchedList;
        movieListViewController.moviesReorderable = NO;
    }
    movieListViewController.movies = [moviesRepository getMovies:selectedList];
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"SearchMovies"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SearchViewController *searchViewController = (SearchViewController *) navigationController.topViewController;
        searchViewController.onMovieSelected = ^(Movie *movie) {
            [moviesRepository addMovie:movie withType:selectedList];
            [movieListViewController addMovie:movie];
        };
    }
}

@end