@class Movie;
@class MovieCell;

@interface ListViewController : UITableViewController

@property (nonatomic) BOOL moviesDeletable;
@property (nonatomic) BOOL moviesReorderable;

@property (strong, nonatomic) NSArray *movies;
@property (copy, nonatomic) void (^customOnCellTapped)(Movie *movie, MovieCell *movieCell);

@property (copy, nonatomic) void (^movieDeleted)(Movie *movie);
@property (copy, nonatomic) void (^movieMoved)(NSInteger sourceRow, NSInteger destinationRow);

- (void) addMovie:(Movie *) movie;


@end
