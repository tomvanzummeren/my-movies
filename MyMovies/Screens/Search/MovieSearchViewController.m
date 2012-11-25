#import "MovieSearchViewController.h"
#import "MovieListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "Movie.h"

@implementation MovieSearchViewController {
    MovieListViewController *movieListViewController;
    TheMovieDbApiConnector *movieRepository;
}
@synthesize onMovieSelected;

- (void) awakeFromNib {
    [super awakeFromNib];
    movieRepository = [TheMovieDbApiConnector instance];
}

- (void) viewDidLoad {

    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    __weak MovieSearchViewController *weakSelf = self;
    movieListViewController.customOnCellTapped = ^(Movie *movie){
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            weakSelf.onMovieSelected(movie);
        }];
    };
    [searchBar becomeFirstResponder];
}

- (IBAction) cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) searchBar:(UISearchBar *) db textDidChange:(NSString *) searchText {
    if (searchText.length > 0) {
        [movieRepository search:searchText callback:^(NSArray *movies) {
            if ([searchBar.text isEqualToString:searchText]) {
                movieListViewController.movies = movies;
            }
        }];
    } else {
        [movieRepository cancelSearch];
        movieListViewController.movies = [NSArray array];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar1 {
    [searchBar resignFirstResponder];
}


- (void) viewWillDisappear:(BOOL) animated {
    [searchBar resignFirstResponder];
}

@end