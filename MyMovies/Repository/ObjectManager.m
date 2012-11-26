
#import "ObjectManager.h"
#import "ErrorAlertView.h"

@implementation ObjectManager {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

- (id) init {
    self = [super init];
    if (self) {
        [self managedObjectContext];
    }
    return self;
}

+ (ObjectManager *) instance {
    RETURN_SINGLETON(ObjectManager);
}

- (NSFetchRequest *) newMoviesFetchRequest {
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:MOVIE_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    return request;
}

- (NSArray *) fetchAll:(NSFetchRequest *) request {
    NSError *queryError = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&queryError];
    [ErrorAlertView showOnError:queryError];
    return results;
}

- (id) fetchSingleResult:(NSFetchRequest *) request {
    NSArray *results = [self fetchAll:request];
    if (results.count == 1) {
        return [results objectAtIndex:0];
    }
    if (results.count > 0) {
        Log(@"WARNING: Fetching single result matches multiple");
    }
    return nil;
}

- (void) insertObject:(NSManagedObject *) object {
    [managedObjectContext insertObject:object];
}

- (void) deleteObject:(NSManagedObject *) object {
    [managedObjectContext deleteObject:object];
}

- (void) saveContext {
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        managedObjectContext = [NSManagedObjectContext new];
        managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *) managedObjectModel {
    if (managedObjectModel) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MovieModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if (persistentStoreCoordinator) {
        return persistentStoreCoordinator;
    }

    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MovieModel.sqlite"];

    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeUrl error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *) applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end