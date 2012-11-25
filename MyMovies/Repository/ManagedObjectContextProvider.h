//
// Created by tomvanzummeren on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface ManagedObjectContextProvider : NSObject

+ (ManagedObjectContextProvider *) instance;

- (NSManagedObjectContext *) managedObjectContext;

- (void) saveContext;

@end