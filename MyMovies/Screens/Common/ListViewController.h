@class Movie;

@interface ListViewController : UITableViewController

@property (nonatomic) BOOL moviesDeletable;
@property (nonatomic) BOOL moviesReorderable;

@property (strong, nonatomic) NSArray *movies;
@property (copy, nonatomic) void (^customOnCellTapped)(Movie *movie);

@property (copy, nonatomic) void (^movieDeleted)(Movie *movie);


- (void) addMovie:(Movie *) movie;


@end
