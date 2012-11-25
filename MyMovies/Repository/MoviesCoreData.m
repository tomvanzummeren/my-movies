//
//  MoviesCoreData.m
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "MoviesCoreData.h"
#import "AppDelegate.h"

#define MOVIE_ENTITY_NAME @"Movie"

@implementation MoviesCoreData

static MoviesCoreData *instance = nil;

+ (MoviesCoreData *) instance {
    if (!instance) {
        instance = [MoviesCoreData new];
    }
    return instance;
}

- (void) addMovie:(Movie *) movie withType:(MovieListType) type {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSManagedObject *managedMovie = [NSEntityDescription insertNewObjectForEntityForName:MOVIE_ENTITY_NAME
                                                                        inManagedObjectContext:context];

    [managedMovie setValue:@(movie.identifier) forKey:@"identifier"];
    [managedMovie setValue:movie.title forKey:@"title"];
    [managedMovie setValue:movie.releaseDate forKey:@"releaseDate"];
    [managedMovie setValue:movie.iconImageUrl forKey:@"iconImageUrl"];
    [managedMovie setValue:movie.posterImageUrl forKey:@"posterImageUrl"];
    [managedMovie setValue:@(movie.voteAverage) forKey:@"voteAverage"];
    [managedMovie setValue:[self stringForType:type] forKey:@"type"];

    NSError *saveError = nil;
    [context save:&saveError];
    // TODO: Handle saveError

    return;
}

- (void) deleteMovie:(Movie *) movie withType:(MovieListType) type {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

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


- (NSMutableArray *) getMovies:(MovieListType) type {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:MOVIE_ENTITY_NAME inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"(type = %@)", [self stringForType:type]];

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
    NSLog(@"Error: unknown MovieListType");
    return nil;
}

@end
