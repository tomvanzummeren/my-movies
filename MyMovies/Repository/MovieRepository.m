
#import "MovieRepository.h"
#import "Movie.h"
#import "HttpRequest.h"
#import "NSString+Utilities.h"
#import "NSDictionary+JSON.h"
#import "MovieDetails.h"

#define BASE_API_URL @"http://api.themoviedb.org/3/"
#define API_KEY @"7f379d4320f537c491799a4d1ea1be47"

#define IMAGE_BASE_URL @"http://cf2.imgobject.com/t/p/"
#define ICON_SIZE @"w154"
#define POSTER_SIZE @"original"

@implementation MovieRepository {
    NSDateFormatter *dateFormatter;
    HttpRequest *currentSearchHttpRequest;
}
- (id) init {
    self = [super init];
    if (self) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

static MovieRepository *instance = nil;

+ (MovieRepository *) instance {
    if (!instance) {
        instance = [MovieRepository new];
    }
    return instance;
}

- (void) search:(NSString *) searchText callback:(void (^)(NSArray *results)) callback {
    [currentSearchHttpRequest cancel];

    NSString *encodedSearchText = [searchText urlEncodedString];
    HttpRequest *httpRequest = [HttpRequest requestWithUrl:@"%@search/movie?query=%@&api_key=%@", BASE_API_URL, encodedSearchText, API_KEY];
    currentSearchHttpRequest = httpRequest;

    [httpRequest perform:^(NSDictionary *responseJson) {
        NSMutableArray *movies = [NSMutableArray array];

        NSArray *resultsJson = [responseJson objectForKey:@"results"];
        for (NSDictionary *resultJson in resultsJson) {
            Movie *movie = [Movie new];
            movie.title = [resultJson stringForKey:@"title"];
            movie.releaseDate = [dateFormatter dateFromString:[resultJson stringForKey:@"release_date"]];
            movie.identifier = [resultJson integerForKey:@"id"];
            movie.voteAverage = [resultJson integerForKey:@"vote_average"];

            NSString *posterPath = [resultJson stringForKey:@"poster_path"];
            if (posterPath) {
                movie.posterImageUrl = [NSString stringWithFormat:@"%@/%@%@", IMAGE_BASE_URL, POSTER_SIZE, posterPath];
                movie.iconImageUrl = [NSString stringWithFormat:@"%@/%@%@", IMAGE_BASE_URL, ICON_SIZE, posterPath];
            }

            [movies addObject:movie];
        }
        NSLog(@"Movies found: %i", movies.count);
        callback(movies);
    } failure:^{
        callback(nil);
    }];
}

- (void) loadMovieDetails:(Movie *) movie callback:(void (^)(MovieDetails *movieDetails)) callback {
    HttpRequest *httpRequest = [HttpRequest requestWithUrl:@"%@movie/%i?api_key=%@", BASE_API_URL, movie.identifier, API_KEY];
    [httpRequest perform:^(NSDictionary *response) {
        MovieDetails *movieDetails = [MovieDetails new];
        movieDetails.identifier = [response integerForKey:@"id"];
        movieDetails.overview = [response stringForKey:@"overview"];

        callback(movieDetails);
    } failure:^{
        callback(nil);
    }];
}

- (NSArray *) watchedList {
    return [NSArray array];
}

- (NSArray *) toWatchList {
    return [NSArray array];
}

- (void) cancelSearch {
     [currentSearchHttpRequest cancel];
}
@end