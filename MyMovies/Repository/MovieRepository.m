
#import "MovieRepository.h"
#import "Movie.h"
#import "HttpRequest.h"
#import "NSString+Utilities.h"
#import "NSDictionary+JSON.h"

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

    [httpRequest perform:^(id response) {
        NSMutableArray *movies = [NSMutableArray array];

        NSDictionary *responseJson = response;
        NSArray *resultsJson = [responseJson objectForKey:@"results"];
        for (NSDictionary *resultJson in resultsJson) {
            Movie *movie = [Movie new];
            movie.title = [resultJson stringForKey:@"title"];
            movie.overview = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean neque diam, cursus eget rutrum eget, adipiscing id enim. Proin vitae orci ac orci vehicula convallis et ut massa. Maecenas suscipit interdum ligula eu vehicula. Sed sed metus mauris. Donec diam quam, porta at rutrum sed, venenatis at risus. Mauris sed nulla libero. Aliquam erat volutpat. Maecenas in urna turpis. Pellentesque at metus odio.";
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

- (NSArray *) watchedList {
    return [NSArray array];
}

- (NSArray *) toWatchList {
//    Movie *up = [Movie new];
//    up.title = @"Up";
//    up.releaseYear = @"2009";
//    up.overview = @"After a lifetime of dreaming of traveling the world, 78-year-old homebody Carl flies away on an unbelievable adventure with Russell, an 8-year-old Wilderness Explorer, unexpectedly in tow. Together, the unlikely pair embarks on a thrilling odyssey full of jungle beasts and rough terrain.";
//    up.posterImage = [UIImage imageNamed:@"poster-up.jpg"];
//    up.iconImage = [UIImage imageNamed:@"icon-up.jpg"];
//
//    Movie *theDarkKnight = [Movie new];
//    theDarkKnight.title = @"The Dark Knight";
//    theDarkKnight.releaseYear = @"2008";
//    theDarkKnight.overview = @"Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.";
//    theDarkKnight.posterImage = [UIImage imageNamed:@"poster-thedarkknight.jpg"];
//    theDarkKnight.iconImage = [UIImage imageNamed:@"icon-thedarkknight.jpg"];
//
//    Movie *matrix = [Movie new];
//    matrix.title = @"The Matrix";
//    matrix.releaseYear = @"1999";
//    matrix.overview = @"Thomas A. Anderson is a man living two lives. By day he is an average computer programmer and by night a malevolent hacker known as Neo, who finds himself targeted by the police when he is contacted by Morpheus, a legendary computer hacker, who reveals the shocking truth about our reality.";
//    matrix.posterImage = [UIImage imageNamed:@"poster-matrix.jpg"];
//    matrix.iconImage = [UIImage imageNamed:@"icon-matrix.jpg"];
//
//    return [NSArray arrayWithObjects:up, theDarkKnight, matrix, nil];
    return [NSArray array];
}

- (void) cancelSearch {
     [currentSearchHttpRequest cancel];
}
@end