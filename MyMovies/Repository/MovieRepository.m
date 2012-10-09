
#import "MovieRepository.h"

@implementation MovieRepository

static MovieRepository *instance = nil;

- (MovieRepository *) instance {
    if (!instance) {
        instance = [MovieRepository new];
    }
    return instance;
}

@end