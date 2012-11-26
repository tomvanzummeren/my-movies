//
//  MoviesRepository.m
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "MoviesRepository.h"
#import "ManagedObjectContextProvider.h"
#import "NSMutableArray+Move.h"

@implementation MoviesRepository {
    ManagedObjectContextProvider *provider;
    NSManagedObjectContext *context;
}

- (id) init {
    self = [super init];
    if (self) {
        provider = [ManagedObjectContextProvider instance];
        context = [provider managedObjectContext];
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

    [context insertObject:movie];
    [provider saveContext];
}

- (NSInteger) determineNextOrderNumberForType:(MovieListType) type {
    NSFetchRequest *request = [provider newMoviesFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"type = %@", [self stringForType:type]];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO]];
    request.fetchLimit = 1;

    Movie *movie = [provider fetchSingleResult:request];
    return movie ? [movie.order integerValue] + 1 : 0;
}

- (void) deleteMovie:(Movie *) movie {
    [context deleteObject:movie];
    [provider saveContext];
}

- (void) moveMovieFrom:(NSNumber *) sourceOrder toRow:(NSNumber *) destinationOrder withType:(MovieListType) type {
    // Step 1: Fetch all Movies that need their order changed
    NSFetchRequest *request = [provider newMoviesFetchRequest];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO]];
    BOOL movingUp = [sourceOrder compare:destinationOrder] == NSOrderedAscending;
    if (movingUp) {
        request.predicate = [NSPredicate predicateWithFormat:@"order >= %@ AND order <= %@ AND type = %@", sourceOrder, destinationOrder, [self stringForType:type]];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"order <= %@ AND order >= %@ AND type = %@", sourceOrder, destinationOrder, [self stringForType:type]];
    }
    NSMutableArray *movies = [[provider fetchAll:request] mutableCopy];

    // Step 2: Re-order the fetched Movies
    if (movingUp) {
        [movies moveLastObjectToBegin];
    } else {
        [movies moveFirstObjectToEnd];
    }

    // Step 3: Assign new order values to the re-ordered movies
    NSInteger currentValue = MAX([sourceOrder integerValue], [destinationOrder integerValue]);
    for (Movie *movie in movies) {
        NSNumber *oldOrder = movie.order;
        movie.order = @(currentValue);
        currentValue --;
    }

    [provider saveContext];
}

- (NSMutableArray *) getMovies:(MovieListType) type {
    NSFetchRequest *request = [provider newMoviesFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"type = %@", [self stringForType:type]];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO]];

    return [[provider fetchAll:request] mutableCopy];
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
