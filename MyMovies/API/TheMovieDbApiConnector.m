
#import "TheMovieDbApiConnector.h"
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

#define DEFAULT_LANGUAGE @"en"

@implementation TheMovieDbApiConnector {

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

+ (TheMovieDbApiConnector *) instance {
    RETURN_SINGLETON(TheMovieDbApiConnector)
}

- (void) search:(NSString *) searchText callback:(void (^)(NSArray *results)) callback {
    [currentSearchHttpRequest cancel];

    NSString *encodedSearchText = [searchText urlEncodedString];
    HttpRequest *httpRequest = [HttpRequest requestWithUrl:@"%@search/movie?query=%@&api_key=%@", BASE_API_URL, encodedSearchText, API_KEY];
    currentSearchHttpRequest = httpRequest;

    [httpRequest perform:^(NSDictionary *responseJson) {
        NSMutableArray *movies = [NSMutableArray array];

        NSArray *resultsJson = responseJson[@"results"];
        for (NSDictionary *resultJson in resultsJson) {
            Movie *movie = [Movie new];
            movie.title = [resultJson stringForKey:@"title"];
            movie.releaseDate = [dateFormatter dateFromString:[resultJson stringForKey:@"release_date"]];
            movie.identifier = resultJson[@"id"];
            movie.voteAverage = resultJson[@"vote_average"];

            NSString *posterPath = [resultJson stringForKey:@"poster_path"];
            if (posterPath) {
                movie.posterImageUrl = [NSString stringWithFormat:@"%@/%@%@", IMAGE_BASE_URL, POSTER_SIZE, posterPath];
                movie.iconImageUrl = [NSString stringWithFormat:@"%@/%@%@", IMAGE_BASE_URL, ICON_SIZE, posterPath];
            }
            [movies addObject:movie];
        }
        callback(movies);
    } failure:^{
        callback(nil);
    }];
}

- (void) loadMovieDetails:(Movie *) movie callback:(void (^)(MovieDetails *movieDetails)) callback {
    [self loadMovieDetails:movie language:[self currentLanguage] callback:^(MovieDetails *movieDetails) {
        if (!movieDetails.overview) {
            [self loadMovieDetails:movie language:DEFAULT_LANGUAGE callback:^(MovieDetails *defaultMovieDetails) {
                [movieDetails fillMissingFields:defaultMovieDetails];
                callback(movieDetails);
            }];
        } else {
            callback(movieDetails);
        }
    }];
}

- (void) loadMovieDetails:(Movie *) movie language:(NSString *) language callback:(void (^)(MovieDetails *movieDetails)) callback {
    HttpRequest *httpRequest = [HttpRequest requestWithUrl:@"%@movie/%i?api_key=%@&language=%@", BASE_API_URL, [movie.identifier integerValue], API_KEY, language];
    [httpRequest perform:^(NSDictionary *response) {
        MovieDetails *movieDetails = [MovieDetails new];
        movieDetails.identifier = [response integerForKey:@"id"];
        movieDetails.overview = [response stringForKey:@"overview"];

        callback(movieDetails);
    } failure:^{
        callback(nil);
    }];
}

- (void) cancelSearch {
    [currentSearchHttpRequest cancel];
}

- (NSString *) currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    return [languages objectAtIndex:0];
}

@end