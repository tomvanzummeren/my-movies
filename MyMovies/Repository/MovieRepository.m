
#import "MovieRepository.h"
#import "Movie.h"

@implementation MovieRepository

static MovieRepository *instance = nil;

+ (MovieRepository *) instance {
    if (!instance) {
        instance = [MovieRepository new];
    }
    return instance;
}

- (void) search:(NSString *) searchText callback:(void (^)(NSArray *results)) callback {
    NSArray *results = [NSArray array];
    // TODO: Make dummy implementation
    callback(results);
}

- (NSArray *) watchedList {

}

- (NSArray *) toWatchList {
    Movie *up = [Movie new];
    up.title = @"Up";
    up.releaseYear = @"2009";
    up.overview = @"After a lifetime of dreaming of traveling the world, 78-year-old homebody Carl flies away on an unbelievable adventure with Russell, an 8-year-old Wilderness Explorer, unexpectedly in tow. Together, the unlikely pair embarks on a thrilling odyssey full of jungle beasts and rough terrain.";
    up.posterImage = [UIImage imageNamed:@""];

    return [NSArray arrayWithObjects:up, nil];
}

@end