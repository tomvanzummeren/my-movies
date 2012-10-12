@class Movie;
@class MovieDetails;

@interface MovieRepository : NSObject

+ (MovieRepository *) instance;

- (void) search:(NSString *) searchText callback:(void (^)(NSArray *)) callback;

- (void) loadMovieDetails:(Movie *) movie callback:(void (^)(MovieDetails *)) callback;

- (NSArray *) watchedList;

- (NSArray *) toWatchList;

- (void) cancelSearch;

- (void) addToToWatchList:(Movie *) movie;

- (void) addToWatchedList:(Movie *) movie;
@end