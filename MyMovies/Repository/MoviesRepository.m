//
//  MoviesRepository.m
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "MoviesRepository.h"
#import "ManagedObjectContextProvider.h"
#import "ErrorAlertView.h"

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

    NSLog(@"Order Number: %@", @(orderNumber));

    movie.type = [self stringForType:type];
    movie.order = @(orderNumber);

    [context insertObject:movie];

    NSError *saveError = nil;
    [context save:&saveError];
    [ErrorAlertView showOnError:saveError];

    return;
}

- (NSInteger) determineNextOrderNumberForType:(MovieListType) type {
    NSFetchRequest *request = [provider newMoviesFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"(type = %@)", [self stringForType:type]];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortByName];

    NSError *queryError = nil;
    NSArray *results = [context executeFetchRequest:request error:&queryError];
    [ErrorAlertView showOnError:queryError];

    NSInteger orderNumber = 0;
    if ([results count] > 0) {
        NSManagedObject *firstMovie = [results objectAtIndex:0];
        NSInteger firstMovieOrderNumber = [[firstMovie valueForKey:@"order"] integerValue];
        orderNumber = firstMovieOrderNumber + 1;
    }

}

- (void) deleteMovie:(Movie *) movie withType:(MovieListType) type {
    NSFetchRequest *request = [provider newMoviesFetchRequest];
    request.includesPropertyValues = NO;

    request.predicate = [NSPredicate predicateWithFormat:@"(identifier = %@)", movie.identifier];
    NSError *queryError = nil;
    NSArray *results = [context executeFetchRequest:request error:&queryError];
    [ErrorAlertView showOnError:queryError];

    for (NSManagedObject *result in results) {
        [context deleteObject:result];
    }

    NSError *saveError = nil;
    [context save:&saveError];
    [ErrorAlertView showOnError:saveError];
}

- (void) moveMovie:(NSInteger) sourceOrder toRow:(NSInteger) destinationOrder {
    // Moving down
    if (sourceOrder < destinationOrder) {
        NSLog(@"Moving down...");
        NSInteger lastOrderNumber;

        for (int i = sourceOrder; i < destinationOrder; i++) {

            NSFetchRequest *request = [provider newMoviesFetchRequest];
            request.predicate = [NSPredicate predicateWithFormat:@"(order = %@)", @(i)];

            NSError *queryError = nil;
            NSArray *results = [context executeFetchRequest:request error:&queryError];
            [ErrorAlertView showOnError:queryError];

            NSManagedObject *managedMovie = [results objectAtIndex:0];
            NSInteger orderNumber = [[managedMovie valueForKey:@"order"] integerValue];
            [managedMovie setValue:@(orderNumber - 1) forKey:@"order"];

            lastOrderNumber = orderNumber - 1;

            NSError *saveError = nil;
            [context save:&saveError];
            [ErrorAlertView showOnError:saveError];
        }

        NSFetchRequest *request = [provider newMoviesFetchRequest];
        request.predicate = [NSPredicate predicateWithFormat:@"(order = %@)", @(sourceOrder)];

        NSError *queryError = nil;
        NSArray *results = [context executeFetchRequest:request error:&queryError];
        [ErrorAlertView showOnError:queryError];

        NSManagedObject *managedMovie = [results objectAtIndex:0];
        [managedMovie setValue:@(lastOrderNumber - 1) forKey:@"order"];

        NSError *saveError = nil;
        [context save:&saveError];
        [ErrorAlertView showOnError:saveError];
    } else {

    }

    NSLog(@"Moving row %@ to %@", @(sourceOrder), @(destinationOrder));
}

- (NSMutableArray *) getMovies:(MovieListType) type {
    NSFetchRequest *request = [provider newMoviesFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"(type = %@)", [self stringForType:type]];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortByName];

    NSError *queryError = nil;
    NSArray *movies = [context executeFetchRequest:request error:&queryError];
    [ErrorAlertView showOnError:queryError];
    return [movies mutableCopy];
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
