#import "MovieSearchViewController.h"
#import "MovieListViewController.h"
#import "MovieRepository.h"

@implementation MovieSearchViewController {
    MovieListViewController *movieListViewController;
    MovieRepository *movieRepository;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    movieRepository = [MovieRepository instance];
}

- (void) viewDidLoad {
    movieListViewController = [[self childViewControllers] objectAtIndex:0];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *) sb {
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

- (void) viewWillAppear:(BOOL) animated {
    [searchBar becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL) animated {
    [searchBar resignFirstResponder];
}

@end