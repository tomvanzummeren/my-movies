
#import "MovieListViewController.h"
#import "MovieCell.h"
#import "Movie.h"

@implementation MovieListViewController {
    NSArray *movies;
}

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return movies.count;
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    MovieCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    Movie *movie = [movies objectAtIndex:(NSUInteger) indexPath.row];
    [movieCell setMovie:movie];
    return movieCell;
}

- (NSArray *) movies {
    return movies;
}

- (void) setMovies:(NSArray *) someMovies {
    movies = someMovies;
    [self.tableView reloadData];
}

@end
