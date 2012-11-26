
#define MOVIE_ENTITY_NAME @"Movie"

@interface ObjectManager : NSObject

+ (ObjectManager *) instance;

- (NSManagedObjectContext *) managedObjectContext;

- (void) saveContext;

- (NSFetchRequest *) newMoviesFetchRequest;

- (NSArray *) fetchAll:(NSFetchRequest *) request;

- (id) fetchSingleResult:(NSFetchRequest *) request;

- (void) insertObject:(NSManagedObject *) object;

- (void) deleteObject:(NSManagedObject *) object;
@end