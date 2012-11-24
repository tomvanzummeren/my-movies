
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
    SelectedList selectedList;
}



- (void) viewDidLoad {
    movieRepository = [MovieRepository instance];
    moviesCoreData = [MoviesCoreData instance];
    
    
    
    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    movieListViewController.moviesDeletable = YES;
    movieListViewController.moviesReorderable = YES;
    
    __weak id weakSelf = self;
    movieListViewController.movieDeleted = ^(Movie *movie) {
        [weakSelf removeMovie:movie];         
    };
    
    self.navigationItem.leftBarButtonItem = movieListViewController.editButtonItem;
    
    movieListViewController.movies = [moviesCoreData getMovies:@"toWatch"];
    tabBar.selectedItem = [tabBar.items objectAtIndex:0];
    
    
}

- (void) removeMovie:(Movie *) movie{
    if (selectedList == ToWatchList) {
        [moviesCoreData removeMovie:movie WithType:@"toWatched"];
    }else{
        [moviesCoreData removeMovie:movie WithType:@"Watched"];
    }
}

- (void) tabBar:(UITabBar *) tb didSelectItem:(UITabBarItem *) item {
    int selectedItemIndex = [tabBar.items indexOfObject:item];
    [movieListViewController setEditing:NO];
    if (selectedItemIndex == 0) {
        movieListViewController.moviesReorderable = YES;
        movieListViewController.movies = [moviesCoreData getMovies:@"toWatch"];
        selectedList = ToWatchList;
    } else {
        movieListViewController.moviesReorderable = NO;
        movieListViewController.movies = [moviesCoreData getMovies:@"Watched"];
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
                [movieListViewController addMovie:movie ];
               
                [moviesCoreData addMovie:movie WithType:@"toWatch"];
                
            } else if (selectedList == WatchedList) {
                [movieRepository addToWatchedList:movie];
                [movieListViewController addMovie:movie];
                [moviesCoreData addMovie:movie WithType:@"Watched"];
            }
        };
    }
}

@end