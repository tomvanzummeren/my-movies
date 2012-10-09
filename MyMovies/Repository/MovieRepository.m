
#import "MovieRepository.h"

@implementation MovieRepository

static MovieRepository *instance = [MovieRepository new];

- (MovieRepository *) instance {
    return instance;
}

@end