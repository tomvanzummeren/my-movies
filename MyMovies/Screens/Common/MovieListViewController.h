@class Movie;

@interface MovieListViewController : UITableViewController

@property (nonatomic) BOOL moviesDeletable;
@property (strong, nonatomic) NSArray *movies;
@property (copy, nonatomic) void (^customOnCellTapped)(Movie *movie);

- (void) addMovie:(Movie *) movie;


@end
