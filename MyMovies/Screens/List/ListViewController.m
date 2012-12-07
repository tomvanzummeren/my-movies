#import "ListViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "DetailViewController.h"
#import "MoviesRepository.h"
#import "MyMoviesWindow.h"
#import "UITableViewController+Scrolling.h"


#define SEGMENT_DATE_ADDED 0
#define SEGMENT_ALPHABET 1
#define SEGMENT_RATING 2

@implementation ListViewController {
    NSMutableArray *movies;
    MoviesRepository *moviesRepository;

    NSInteger placeholderCellIndex;

    UITableViewCell *placeholderCell;
}

@synthesize moviesDeletable;
@synthesize moviesReorderable;
@synthesize customOnCellTapped;
@synthesize movieDeleted;
@synthesize movieMoved;
@synthesize listBeganScrolling;
@synthesize loadMovies;

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return placeholderCellIndex != -1 ? movies.count + 1 : movies.count;
}

- (void) viewDidLoad{
    moviesRepository = [MoviesRepository instance];
    placeholderCellIndex = -1;
    placeholderCell = [UITableViewCell new];
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    MovieCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    Movie *movie = [self movieAtIndexPath:indexPath];
    if (!movie) {
        // Return empty cell
        return placeholderCell;
    }
    movieCell.movie = movie;
    if (!customOnCellTapped) {
        movieCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return movieCell;
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString:@"MovieDetails"]) {
        DetailViewController *controller = segue.destinationViewController;
        MovieCell *movieCell = sender;
        controller.movie = movieCell.movie;
    }
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    MovieCell *cell = (MovieCell *) [tableView cellForRowAtIndexPath:indexPath];
    if (customOnCellTapped) {
        Movie *movie = [self movieAtIndexPath:indexPath];
        customOnCellTapped(movie, cell);
    } else {
        [self performSegueWithIdentifier:@"MovieDetails" sender:cell];
    }
}

- (void) tableView:(UITableView *) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"MovieDetails" sender:cell];
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return moviesReorderable;
}

-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Movie *selectedMovie = movies[(NSUInteger) sourceIndexPath.row];
    Movie *movieAtDestination = movies[(NSUInteger) destinationIndexPath.row];

    [movies removeObject:selectedMovie];
    [movies insertObject:selectedMovie atIndex:(NSUInteger) destinationIndexPath.row];

    movieMoved(selectedMovie.order, movieAtDestination.order);
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return moviesDeletable;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView{
    if(moviesDeletable){
        return UITableViewCellEditingStyleDelete;
    }

    return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = (NSUInteger) indexPath.row;
    Movie *movie = movies[row];
  
    movieDeleted(movie);
    
    [movies removeObjectAtIndex:row];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void) addMovie:(Movie *) movie {
    // Reload movies from database only to find out what index the new movie is at
    NSArray *moviesInDatabase = loadMovies();
    NSInteger movieIndex = [moviesInDatabase indexOfObject:movie];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:movieIndex inSection:0];

    // Open up an empty cell
    placeholderCellIndex = movieIndex;
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    // Scroll to the right position
    [self scrollAnimatedToRowAtIndexPath:indexPath completion:^{
        // After scrolling is done (and opening cell at same time) insert new row with animation
        MyMoviesWindow *window = (MyMoviesWindow *) self.view.window;
        CGRect cellFrame = [self.tableView rectForRowAtIndexPath:indexPath];
        CGFloat y = cellFrame.origin.y - [self.tableView contentOffset].y;
        [window animateMoveOverlappingMovieCellToPosition:CGPointMake(cellFrame.origin.x, y) inView:self.tableView completion:^{
            [movies insertObject:movie atIndex:(NSUInteger) indexPath.row];
            placeholderCellIndex = -1;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }];
}

- (Movie *) movieAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.row == placeholderCellIndex) {
        return nil;
    }
    NSUInteger row = (NSUInteger)(placeholderCellIndex != -1 && indexPath.row > placeholderCellIndex ? indexPath.row - 1: indexPath.row);
    return movies[row];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (listBeganScrolling){
        listBeganScrolling();
    }
}

- (void) reloadMovies:(NSArray *) newMovies {
    movies = [newMovies mutableCopy];
    [self.tableView reloadData];
}

- (void) reloadMovies {
    if (loadMovies) {
        movies = loadMovies();
        [self.tableView reloadData];
    }
}
@end
