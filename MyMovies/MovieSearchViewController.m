
#import "MovieSearchViewController.h"

@implementation MovieSearchViewController

- (void)searchBarCancelButtonClicked:(UISearchBar *) sb {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL) animated {
    [searchBar becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL) animated {
    [searchBar resignFirstResponder];
}

@end