@class Movie;
@class MovieDetails;

@interface TheMovieDbApiConnector : NSObject

+ (TheMovieDbApiConnector *) instance;

- (void) search:(NSString *) searchText callback:(void (^)(NSArray *)) callback;

- (void) loadMovieDetails:(Movie *) movie callback:(void (^)(MovieDetails *)) callback;

- (void) cancelSearch;
@end