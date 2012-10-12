//
// Created by tomvanzummeren on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Movie.h"


@implementation Movie

@synthesize identifier;
@synthesize title;
@synthesize releaseDate;
@synthesize iconImageUrl;
@synthesize posterImageUrl;
@synthesize voteAverage;

static NSDateFormatter *yearFormatter;

+ (void) initialize {
    yearFormatter = [NSDateFormatter new];
    yearFormatter.dateFormat = @"yyyy";
}

- (NSString *) releaseYear {
    if (!releaseDate) {
        return nil;
    }
    return [yearFormatter stringFromDate:releaseDate];
}

@end