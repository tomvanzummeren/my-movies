@class Movie;
@class MovieCell;
@class MovieList;

@interface ListViewController : UITableViewController;

@property(nonatomic) BOOL moviesDeletable;
@property(nonatomic) BOOL moviesReorderable;

@property(copy, nonatomic) void (^movieDeleted) (Movie *movie);
@property(copy, nonatomic) void (^listBeganScrolling) ();
@property(copy, nonatomic) void (^movieMoved) (NSNumber *sourceRow, NSNumber *destinationRow);
@property(copy, nonatomic) void (^customOnCellTapped) (Movie *movie, MovieCell *movieCell);
@property(nonatomic, copy) MovieList *(^loadMovies) ();

@property(copy, nonatomic) NSArray *sectionIndexTitles;

- (void) addMovie:(Movie *) movie;

- (void) reloadMovies;

- (void) reloadMovies:(NSArray *) movies;

@end
