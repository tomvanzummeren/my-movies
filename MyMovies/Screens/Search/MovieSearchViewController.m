#import "MovieSearchViewController.h"
#import "MovieListViewController.h"
#import "MovieRepository.h"
#import "Movie.h"

@implementation MovieSearchViewController {
    MovieListViewController *movieListViewController;
    MovieRepository *movieRepository;
}
@synthesize onMovieSelected;

- (void) awakeFromNib {
    [super awakeFromNib];
    movieRepository = [MovieRepository instance];
}

- (void) viewDidLoad {
    movieListViewController = [[self childViewControllers] objectAtIndex:0];
    movieListViewController.customOnCellTapped = ^(Movie *movie){
        [self dismissViewControllerAnimated:YES completion:^{
            onMovieSelected(movie);
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