
#import "ListViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "DetailViewController.h"
#import "MoviesRepository.h"


@implementation ListViewController {
    NSMutableArray *movies;
    MoviesRepository *moviesRepository;
}

@synthesize moviesDeletable;
@synthesize moviesReorderable;
@synthesize customOnCellTapped;
@synthesize movieDeleted;


- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return movies.count;
}

- (void) viewDidLoad{
    moviesRepository = [MoviesRepository instance];
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
        DetailViewController *controller = segue.destinationViewController;
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

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return moviesReorderable;
}

-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
   [movies exchangeObjectAtIndex:(NSUInteger)sourceIndexPath.row withObjectAtIndex:(NSUInteger)destinationIndexPath.row];
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
    NSUInteger row = indexPath.row;
    Movie *movie = [movies objectAtIndex:row];
  
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:movies.count inSection:0];
    [movies addObject:movie];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
