
#import "ListViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "DetailViewController.h"
#import "MoviesRepository.h"
#import "MyMoviesWindow.h"


#define SEGMENT_DATE_ADDED 0
#define SEGMENT_ALPHABET 1
#define SEGMENT_RATING 2

@implementation ListViewController {
    NSMutableArray *movies;
    MoviesRepository *moviesRepository;

    BOOL emptyTopCell;
}

@synthesize moviesDeletable;
@synthesize moviesReorderable;
@synthesize customOnCellTapped;
@synthesize movieDeleted;
@synthesize movieMoved;
@synthesize listBeganScrolling;


- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return emptyTopCell ? movies.count + 1 : movies.count;
}

- (void) viewDidLoad{
    moviesRepository = [MoviesRepository instance];
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    MovieCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    Movie *movie = [self movieAtIndexPath:indexPath];
    if (!movie) {
        // Return empty cell
        return [UITableViewCell new];
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

- (NSArray *) movies {
    return movies;
}

- (void) setMovies:(NSArray *) someMovies {
    movies = [someMovies mutableCopy];
    [self.tableView reloadData];
}

- (void) addMovie:(Movie *) movie {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    emptyTopCell = YES;
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

    MyMoviesWindow *window = (MyMoviesWindow *) self.view.window;
    [window animateMoveOverlappingMovieCellToPosition:CGPointMake(0, 0) inView:self.tableView completion:^{
        [movies insertObject:movie atIndex:0];
        emptyTopCell = NO;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}

- (Movie *) movieAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.row == 0 && emptyTopCell) {
        return nil;
    }
    NSUInteger row = (NSUInteger)(emptyTopCell ? indexPath.row - 1: indexPath.row);
    return movies[row];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (listBeganScrolling){
        listBeganScrolling();
    }
}

@end
