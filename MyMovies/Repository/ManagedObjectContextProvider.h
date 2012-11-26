//
// Created by tomvanzummeren on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#define MOVIE_ENTITY_NAME @"Movie"

@interface ManagedObjectContextProvider : NSObject

+ (ManagedObjectContextProvider *) instance;

- (NSManagedObjectContext *) managedObjectContext;

- (void) saveContext;

- (NSFetchRequest *) newMoviesFetchRequest;
@end