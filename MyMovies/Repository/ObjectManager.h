//
// Created by tomvanzummeren on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#define MOVIE_ENTITY_NAME @"Movie"

@interface ObjectManager : NSObject

+ (ObjectManager *) instance;

- (NSManagedObjectContext *) managedObjectContext;

- (void) saveContext;

- (NSFetchRequest *) newMoviesFetchRequest;

- (NSArray *) fetchAll:(NSFetchRequest *) request;

- (id) fetchSingleResult:(NSFetchRequest *) request;

- (void) insertObject:(Movie *) object;

- (void) deleteObject:(Movie *) object;
@end