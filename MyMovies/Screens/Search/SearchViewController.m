#import "SearchViewController.h"
#import "ListViewController.h"
#import "TheMovieDbApiConnector.h"
#import "Movie.h"
#import "MovieCell.h"
#import "MyMoviesWindow.h"

@implementation SearchViewController {
    ListViewController *listViewController;
    TheMovieDbApiConnector *apiConnector;
}
@synthesize onMovieSelected;

- (void) awakeFromNib {
    [super awakeFromNib];
    apiConnector = [TheMovieDbApiConnector instance];
}

- (void) viewDidLoad {
    listViewController = [self.childViewControllers objectAtIndex:0];
    weakInBlock SearchViewController *weakSelf = self;
    listViewController.customOnCellTapped = ^(Movie *movie, MovieCell *cell) {
        MyMoviesWindow *window = (MyMoviesWindow *) self.view.window;
        [window displayOverlappingMovieCell:cell];

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
        [apiConnector search:searchText callback:^(NSArray *movies) {
            if ([searchBar.text isEqualToString:searchText]) {
                listViewController.movies = movies;
            }
        }];
    } else {
        [apiConnector cancelSearch];
        listViewController.movies = [NSArray array];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar1 {
    [searchBar resignFirstResponder];
}


- (void) viewWillDisappear:(BOOL) animated {
    [searchBar resignFirstResponder];
}

@end