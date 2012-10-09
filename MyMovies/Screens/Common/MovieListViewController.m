
#import "MovieListViewController.h"

@implementation MovieListViewController {
    NSInteger numberOfMovies;
}

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return numberOfMovies;
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
}

- (NSInteger) numberOfMovies {
    return numberOfMovies;
}

- (void) setNumberOfMovies:(NSInteger) number {
    numberOfMovies = number;
    [self.tableView reloadData];
}

@end
