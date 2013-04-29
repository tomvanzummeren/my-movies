#import "ListViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "DetailViewController.h"
#import "MoviesRepository.h"
#import "MyMoviesWindow.h"
#import "UITableViewController+Scrolling.h"
#import "MovieList.h"


#define SEGMENT_DATE_ADDED 0
#define SEGMENT_ALPHABET 1
#define SEGMENT_RATING 2

@implementation ListViewController {

    MovieList *movies;

    MoviesRepository *moviesRepository;

    NSIndexPath *placeholderIndexPath;

    UITableViewCell *placeholderCell;
}

@synthesize moviesDeletable;
@synthesize moviesReorderable;
@synthesize customOnCellTapped;
@synthesize movieDeleted;
@synthesize movieMoved;
@synthesize listBeganScrolling;
@synthesize loadMovies;
@synthesize sectionIndexTitles;

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    int rowsInSection = [movies numberOfMoviesInSection:(NSUInteger) section];
    return placeholderIndexPath && placeholderIndexPath.section == section ? rowsInSection + 1 : rowsInSection;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return [movies numberOfSections];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
    return [movies titleForHeaderInSection:section];
}


- (void) viewDidLoad {
    moviesRepository = [MoviesRepository instance];
    placeholderIndexPath = nil;
    placeholderCell = [UITableViewCell new];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMovies)
                                                 name:@"ToggledMovieWatched"
                                               object:nil];
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

- (BOOL) tableView:(UITableView *) tableView canMoveRowAtIndexPath:(NSIndexPath *) indexPath {
    return moviesReorderable;
}

- (void) tableView:(UITableView *) tableView moveRowAtIndexPath:(NSIndexPath *) sourceIndexPath toIndexPath:(NSIndexPath *) destinationIndexPath {
    Movie *selectedMovie = [movies movieAtIndexPath:sourceIndexPath];
    Movie *movieAtDestination = [movies movieAtIndexPath:destinationIndexPath];

    [movies moveMovieFromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];

    movieMoved(selectedMovie.order, movieAtDestination.order);
}


- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return moviesDeletable;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    Movie *movie = [movies movieAtIndexPath:indexPath];

    movieDeleted(movie);

    [movies removeMovieAtIndexPath:indexPath];

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void) addMovie:(Movie *) movie {
    // Reload movies from database only to find out what index the new movie is at
    MovieList *moviesInDatabase = loadMovies();

    NSIndexPath *indexPath = [moviesInDatabase indexPathForMovie:movie];

    // Open up an empty cell
    placeholderIndexPath = indexPath;
    LogObject(indexPath);
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    // Scroll to the right position
    [self scrollAnimatedToRowAtIndexPath:indexPath completion:^{
        // After scrolling is done (and opening cell at same time) insert new row with animation
        MyMoviesWindow *window = (MyMoviesWindow *) self.view.window;
        CGRect cellFrame = [self.tableView rectForRowAtIndexPath:indexPath];
        CGFloat y = cellFrame.origin.y - [self.tableView contentOffset].y;
        [window animateMoveOverlappingMovieCellToPosition:CGPointMake(cellFrame.origin.x, y) inView:self.tableView completion:^{
            [movies insertMovie:movie atIndexPath:indexPath];
            placeholderIndexPath = nil;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }];
}

- (Movie *) movieAtIndexPath:(NSIndexPath *) indexPath {
    if ([indexPath isEqual:placeholderIndexPath]) {
        return nil;
    }
    if (!placeholderIndexPath || indexPath.section != placeholderIndexPath.section) {
        return [movies movieAtIndexPath:indexPath];
    }
    NSInteger row = placeholderIndexPath && indexPath.row > placeholderIndexPath.row ? indexPath.row - 1 : indexPath.row;
    return [movies movieAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *) scrollView {
    if (listBeganScrolling) {
        listBeganScrolling();
    }
}

- (void) reloadMovies:(NSArray *) newMovies {
    movies = [MovieList movieListWithOneSection:newMovies];
    [self.tableView reloadData];
}

- (void) reloadMovies {
    if (loadMovies) {
        movies = loadMovies();
        [self.tableView reloadData];
    }
}

- (NSInteger) tableView:(UITableView *) tableView sectionForSectionIndexTitle:(NSString *) title atIndex:(NSInteger) index {
    return [movies sectionIndexForTitle:title];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *) tableView {
    return sectionIndexTitles;
}

@end
