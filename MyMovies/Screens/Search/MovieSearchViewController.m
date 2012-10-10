#import "MovieSearchViewController.h"
#import "MovieListViewController.h"

@implementation MovieSearchViewController {
    MovieListViewController *movieListViewController;
}

- (void) viewDidLoad {
    movieListViewController = [[self childViewControllers] objectAtIndex:0];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *) sb {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) searchBar:(UISearchBar *) db textDidChange:(NSString *) searchText {
    if (searchText.length > 0) {
        movieListViewController.movies = [NSArray array];
    } else {
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