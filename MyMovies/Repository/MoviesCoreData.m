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
    NSManagedObject *newMovie;
    newMovie = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Movie"
                  inManagedObjectContext:context];

    [newMovie setValue:[movie title] forKey:@"title"];


    NSError *error;
    [context save:&error];

    [self getMovies];
    return;
}


- (void) getMovies{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Movie"
                inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    /*NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(name = %@)",
     name.text];
    [request setPredicate:pred];*/

    NSError *error;
    NSArray *movies = [context executeFetchRequest:request
                                              error:&error];
    if ([movies count] == 0) {
        NSLog( @"No matches" );
    } else {
        NSLog(@"Movies:");
        
        for (NSManagedObject *movie in movies) {
            NSLog([NSString stringWithFormat:
                @"Movie title: %@", [movie valueForKey:@"title"]]
            );
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
