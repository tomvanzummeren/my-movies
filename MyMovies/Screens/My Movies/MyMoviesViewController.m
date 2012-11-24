
#import "MyMoviesViewController.h"
#import "MovieListViewController.h"
#import "MovieRepository.h"
#import "MovieSearchViewController.h"
#import "MoviesCoreData.h"


typedef enum {
    ToWatchList,
    WatchedList
} SelectedList;

@implementation MyMoviesViewController {
    MovieListViewController *movieListViewController;
    MovieRepository *movieRepository;
    MoviesCoreData *moviesCoreData;
    SelectedList selectedList;
}

- (void) viewDidLoad {
    movieRepository = [MovieRepository instance];
    moviesCoreData = [MoviesCoreData instance];
    
    
    
    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = YES;

    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;
    
    movieListViewController.movies = [moviesCoreData getMovies];;
    tabBar.selectedItem = [tabBar.items objectAtIndex:0];
}

- (void) tabBar:(UITabBar *) tb didSelectItem:(UITabBarItem *) item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    [movieListViewController setEditing:NO];
    if (selectedItemIndex == 0) {
        movieListViewController.moviesReorderable = YES;
        movieListViewController.movies = [moviesCoreData getMovies];
        selectedList = ToWatchList;
    } else {
        movieListViewController.moviesReorderable = NO;
        movieListViewController.movies = [movieRepository watchedList];
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
                [moviesCoreData addMovie:movie];
                
            } else if (selectedList == WatchedList) {
                [movieRepository addToWatchedList:movie];
                [movieListViewController addMovie:movie];
            }
        };
    }
}

@end