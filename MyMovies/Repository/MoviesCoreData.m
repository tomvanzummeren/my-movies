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

- (void) addMovie:(Movie *) movie{
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
    
    
    NSError *error;
    [context save:&error];

  //  [self getMovies];
    return;
}


- (NSMutableArray *) getMovies{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Movie"
                inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];


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
