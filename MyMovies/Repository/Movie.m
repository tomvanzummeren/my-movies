//
//  Movie.m
//  MyMovies
//
//  Created by Tom van Zummeren on 11/25/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "Movie.h"
#import "ObjectManager.h"


@implementation Movie

@dynamic iconImageUrl;
@dynamic identifier;
@dynamic order;
@dynamic posterImageUrl;
@dynamic releaseDate;
@dynamic title;
@dynamic type;
@dynamic voteAverage;

static NSDateFormatter *yearFormatter;

+ (void) initialize {
    yearFormatter = [NSDateFormatter new];
    yearFormatter.dateFormat = @"yyyy";
}

- (NSString *) releaseYear {
    if (!self.releaseDate) {
        return nil;
    }
    return [yearFormatter stringFromDate:self.releaseDate];
}

+ (Movie *) transientInstance {
    NSEntityDescription *entity = [NSEntityDescription entityForName:MOVIE_ENTITY_NAME inManagedObjectContext:[[ObjectManager instance] managedObjectContext] ];
    return (Movie *) [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
}

@end
