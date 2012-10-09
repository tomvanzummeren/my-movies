
#import "MyMoviesViewController.h"

@implementation MyMoviesViewController {
    MovieListViewController *movieListViewController;
}

- (void) viewDidLoad {
    movieListViewController = [[self childViewControllers] objectAtIndex:0];

    tabBar.selectedItem = [[tabBar items] objectAtIndex:0];
}

@end