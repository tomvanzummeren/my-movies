
#import "MovieListViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieDetailViewController.h"

@implementation MovieListViewController {
    NSMutableArray *movies;
}
@synthesize customOnCellTapped;

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return movies.count;
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    MovieCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    Movie *movie = [movies objectAtIndex:(NSUInteger) indexPath.row];
    movieCell.movie = movie;
    if (!customOnCellTapped) {
        movieCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return movieCell;
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"MovieDetails"]) {
        MovieDetailViewController *controller = segue.destinationViewController;
        MovieCell *movieCell = sender;
        controller.movie = movieCell.movie;
    }
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    if (customOnCellTapped) {
        Movie *movie = [movies objectAtIndex:(NSUInteger) indexPath.row];
        customOnCellTapped(movie);
    } else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"MovieDetails" sender:cell];
    }
}

- (void) tableView:(UITableView *) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"MovieDetails" sender:cell];
}


- (NSArray *) movies {
    return movies;
}

- (void) setMovies:(NSArray *) someMovies {
    movies = [someMovies mutableCopy];
    [self.tableView reloadData];
}

- (void) addMovie:(Movie *) movie {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:movies.count inSection:0];
    [movies addObject:movie];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
