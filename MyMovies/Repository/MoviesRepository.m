//
//  MoviesRepository.m
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "MoviesRepository.h"
#import "ObjectManager.h"
#import "NSMutableArray+Move.h"



@implementation MoviesRepository {
    ObjectManager *objectManager;
}




- (id) init {
    self = [super init];
    if (self) {
       objectManager = [ObjectManager instance];
    }
    return self;
}

+ (MoviesRepository *) instance {
    RETURN_SINGLETON(MoviesRepository)
}

- (void) addMovie:(Movie *) movie withType:(MovieListType) type {
    NSInteger orderNumber = [self determineNextOrderNumberForType:type];

    movie.type = [self stringForType:type];
    movie.order = @(orderNumber);

    [objectManager insertObject:movie];
    [objectManager saveContext];
}

- (NSInteger) determineNextOrderNumberForType:(MovieListType) type {
    NSFetchRequest *request = [objectManager newMoviesFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"type = %@", [self stringForType:type]];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO]];
    request.fetchLimit = 1;

    Movie *movie = [objectManager fetchSingleResult:request];
    return movie ? [movie.order integerValue] + 1 : 0;
}

- (void) deleteMovie:(Movie *) movie {
    [objectManager deleteObject:movie];
    [objectManager saveContext];
}

- (void) moveMovieFrom:(NSNumber *) sourceOrder toRow:(NSNumber *) destinationOrder withType:(MovieListType) type {
    // Step 1: Fetch all Movies that need their order changed
    NSFetchRequest *request = [objectManager newMoviesFetchRequest];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO]];
    BOOL movingUp = [sourceOrder compare:destinationOrder] == NSOrderedAscending;
    if (movingUp) {
        request.predicate = [NSPredicate predicateWithFormat:@"order >= %@ AND order <= %@ AND type = %@", sourceOrder, destinationOrder, [self stringForType:type]];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"order <= %@ AND order >= %@ AND type = %@", sourceOrder, destinationOrder, [self stringForType:type]];
    }
    NSMutableArray *movies = [[objectManager fetchAll:request] mutableCopy];

    // Step 2: Re-order the fetched Movies
    if (movingUp) {
        [movies moveLastObjectToBegin];
    } else {
        [movies moveFirstObjectToEnd];
    }

    // Step 3: Assign new order values to the re-ordered movies
    NSInteger currentValue = MAX([sourceOrder integerValue], [destinationOrder integerValue]);
    for (Movie *movie in movies) {
        movie.order = @(currentValue);
        currentValue --;
    }

    [objectManager saveContext];
}

- (NSMutableArray *) getMovies:(MovieListType) type sortBy:(NSString *) sortOrder ascending:(BOOL) ascending {
    NSFetchRequest *request = [objectManager newMoviesFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"type = %@", [self stringForType:type]];
    if (sortOrder) {
        request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:sortOrder ascending:ascending]];
    }

    return [[objectManager fetchAll:request] mutableCopy];
}





- (NSString *) stringForType:(MovieListType) type {
    if (type == ToWatchList) {
        return @"ToWatch";
    } else if (type == WatchedList) {
        return @"Watched";
    }
    [NSException raise:NSGenericException format:@"Unknown MovieListType"];
    return nil;
}

@end
