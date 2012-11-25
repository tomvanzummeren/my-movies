//
//  MoviesRepository.m
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "MoviesRepository.h"
#import "ManagedObjectContextProvider.h"

#define MOVIE_ENTITY_NAME @"Movie"

@implementation MoviesRepository {
    ManagedObjectContextProvider *provider;
}

- (id) init {
    self = [super init];
    if (self) {
        provider = [ManagedObjectContextProvider instance];
    }
    return self;
}

+ (MoviesRepository *) instance {
    RETURN_SINGLETON(MoviesRepository)
}

- (void) addMovie:(Movie *) movie withType:(MovieListType) type {
    NSManagedObjectContext *context = [provider managedObjectContext];

    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:MOVIE_ENTITY_NAME inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"(type = %@)", [self stringForType:type]];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortByName];

    NSError *queryError = nil;

    NSArray *results = [context executeFetchRequest:request error:&queryError];

    NSInteger orderNumber = 0;
    if([results count] != 0){
        NSManagedObject *firstMovie = [results objectAtIndex:0];
        NSInteger firstMovieOrderNumber = [[firstMovie valueForKey:@"order"] integerValue];
        orderNumber = firstMovieOrderNumber + 1;
    }

    NSLog(@"Order Number: %@", @(orderNumber));

    //////////////////
    NSManagedObject *managedMovie = [NSEntityDescription insertNewObjectForEntityForName:MOVIE_ENTITY_NAME
                                                                        inManagedObjectContext:context];

    [managedMovie setValue:@(movie.identifier) forKey:@"identifier"];
    [managedMovie setValue:movie.title forKey:@"title"];
    [managedMovie setValue:movie.releaseDate forKey:@"releaseDate"];
    [managedMovie setValue:movie.iconImageUrl forKey:@"iconImageUrl"];
    [managedMovie setValue:movie.posterImageUrl forKey:@"posterImageUrl"];
    [managedMovie setValue:@(movie.voteAverage) forKey:@"voteAverage"];
    [managedMovie setValue:[self stringForType:type] forKey:@"type"];
    [managedMovie setValue:@(orderNumber) forKey:@"order"];


    NSError *saveError = nil;
    [context save:&saveError];
    // TODO: Handle saveError

    return;
}

- (void) deleteMovie:(Movie *) movie withType:(MovieListType) type {
    NSManagedObjectContext *context = [provider managedObjectContext];

    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:MOVIE_ENTITY_NAME inManagedObjectContext:context];
    request.includesPropertyValues = NO;

    request.predicate = [NSPredicate predicateWithFormat:@"(identifier = %@)", @(movie.identifier)];
    NSError *queryError = nil;
    NSArray *results = [context executeFetchRequest:request error:&queryError];
    // TODO: Handle queryError

    for (NSManagedObject *result in results) {
        [context deleteObject:result];
    }

    NSError *saveError = nil;
    [context save:&saveError];
    // TODO: Handle saveError
}
- (void)moveMovie:(NSInteger)sourceRow toRow:(NSInteger)destinationRow {
    NSLog(@"Moving row %@ to %@", @(sourceRow), @(destinationRow));
}

- (NSMutableArray *) getMovies:(MovieListType) type {
    NSManagedObjectContext *context = [provider managedObjectContext];

    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:MOVIE_ENTITY_NAME inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"(type = %@)", [self stringForType:type]];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortByName];

    NSError *queryError = nil;
    NSArray *results = [context executeFetchRequest:request error:&queryError];
    // TODO: Handle queryError

    NSMutableArray *movies = [NSMutableArray new];

    for (NSManagedObject *result in results) {
        Movie *movie = [Movie new];

        movie.identifier = [[result valueForKey:@"identifier"] integerValue];
        movie.title = [result valueForKey:@"title"];
        movie.releaseDate = [result valueForKey:@"releaseDate"];
        movie.iconImageUrl = [result valueForKey:@"iconImageUrl"];
        movie.posterImageUrl = [result valueForKey:@"posterImageUrl"];
        movie.voteAverage = [[result valueForKey:@"voteAverage"] floatValue];

        [movies addObject:movie];
    }
    return movies;
}

- (NSString *) stringForType:(MovieListType) type {
    if (type == ToWatchList) {
        return @"ToWatch";
    } else if (type == WatchedList) {
        return @"Watched";
    }
    [NSException raise:NSGenericException format:@"Unknown MovieListType"];
}

@end
