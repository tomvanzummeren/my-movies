
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
    return [NSArray array];
}

- (NSArray *) toWatchList {
    Movie *up = [Movie new];
    up.title = @"Up";
    up.releaseYear = @"2009";
    up.overview = @"After a lifetime of dreaming of traveling the world, 78-year-old homebody Carl flies away on an unbelievable adventure with Russell, an 8-year-old Wilderness Explorer, unexpectedly in tow. Together, the unlikely pair embarks on a thrilling odyssey full of jungle beasts and rough terrain.";
    up.posterImage = [UIImage imageNamed:@"poster-up.jpg"];
    up.iconImage = up.posterImage;

    Movie *theDarkKnight = [Movie new];
    theDarkKnight.title = @"The Dark Knight";
    theDarkKnight.releaseYear = @"2008";
    theDarkKnight.overview = @"Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.";
    theDarkKnight.posterImage = [UIImage imageNamed:@"poster-thedarkknight.jpg"];
    theDarkKnight.iconImage = theDarkKnight.posterImage;

    return [NSArray arrayWithObjects:up, theDarkKnight, nil];
}

@end