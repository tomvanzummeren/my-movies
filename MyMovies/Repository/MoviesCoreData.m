//
//  MoviesCoreData.m
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MoviesCoreData.h"
#import "AppDelegate.h"



@implementation
MoviesCoreData


static MoviesCoreData *instance = nil;

+ (MoviesCoreData *) instance {
    if (!instance) {
        instance = [MoviesCoreData new];
    }
    return instance;
}

- (void) addMovie:(Movie *) movie WithType: (NSString *) type{
    NSLog(@"Adding movie to core data..");
    

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSManagedObject *movieManagedObject;
    movieManagedObject = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Movie"
                  inManagedObjectContext:context];

    [movieManagedObject setValue:[NSNumber numberWithInteger:[movie identifier]] forKey:@"identifier"];
    [movieManagedObject setValue:[movie title] forKey:@"title"];
    [movieManagedObject setValue:[movie releaseDate] forKey:@"releaseDate"];
    [movieManagedObject setValue:[movie iconImageUrl] forKey:@"iconImageUrl"];
    [movieManagedObject setValue:[movie posterImageUrl] forKey:@"posterImageUrl"];
    [movieManagedObject setValue:[NSNumber numberWithFloat:[movie voteAverage]] forKey:@"voteAverage"];
    [movieManagedObject setValue:type forKey:@"type"];

    
    NSError *error;
    [context save:&error];

    return;
}

- (void) removeMovie: (Movie *) movie WithType: (NSString *) type{
    NSLog(@"Removing movie:");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSPredicate *identifier_pred =
    [NSPredicate predicateWithFormat:@"(identifier = %@)",
     [NSNumber numberWithInteger:movie.identifier]];
    [request setPredicate:identifier_pred];
    
  /*  NSPredicate *type_pred =
    [NSPredicate predicateWithFormat:@"(type = %@)",
     type];
    [request setPredicate:type_pred];*/
    
    
    
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:request error:&error];

    for (NSManagedObject * movie in results) {
        [context deleteObject:movie];
    }
    
    NSError *saveError = nil;
    [context save:&saveError];
    
}


- (NSMutableArray *) getMovies:(NSString *) type{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Movie"
                inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(type = %@)",
     type];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request
                                              error:&error];
    
    NSMutableArray *movies = [NSMutableArray new];
    
    if ([results count] == 0) {
        NSLog( @"No matches" );
    } else {
        NSLog(@"Movies:");
        
        for (NSManagedObject *result in results) {
           
            //log
            NSLog([NSString stringWithFormat:
                @"Movie title: %@", [result valueForKey:@"title"]]
            );
           
            //make movie object
            Movie *movie = [Movie new];
            
            movie.identifier = [[result valueForKey:@"identifier"] integerValue];
            movie.title = [result valueForKey:@"title"];
            movie.releaseDate = [result valueForKey:@"releaseDate"];
            movie.iconImageUrl = [result valueForKey:@"iconImageUrl"];
            movie.posterImageUrl = [result valueForKey:@"posterImageUrl"];
            movie.voteAverage = [[result valueForKey:@"voteAverage"] floatValue];
            
            
            
            [movies addObject:movie];
            
        }
    }
    
    return movies;
}



@end
