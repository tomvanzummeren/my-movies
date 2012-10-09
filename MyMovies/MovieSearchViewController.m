
#import "MovieSearchViewController.h"

@implementation MovieSearchViewController

- (void) viewDidLoad {
    [searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) sb {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end