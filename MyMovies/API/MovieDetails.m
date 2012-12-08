
#import "MovieDetails.h"

@implementation MovieDetails

@synthesize identifier;
@synthesize overview;

- (void) fillMissingFields:(MovieDetails *) details {
    if (!self.overview) {
        self.overview = details.overview;
    }
}
@end