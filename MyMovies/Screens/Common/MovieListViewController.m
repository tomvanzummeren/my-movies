
#import "MovieListViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieDetailViewController.h"

@implementation MovieListViewController {
    NSArray *movies;
}

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return movies.count;
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    MovieCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    Movie *movie = [movies objectAtIndex:(NSUInteger) indexPath.row];
    movieCell.movie = movie;
    return movieCell;
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"MovieDetails"]) {
        MovieDetailViewController *controller = segue.destinationViewController;
        MovieCell *movieCell = sender;
        controller.movie = movieCell.movie;
    }
}


- (NSArray *) movies {
    return movies;
}

- (void) setMovies:(NSArray *) someMovies {
    movies = someMovies;
    [self.tableView reloadData];
}

@end
