//
// Created by tomvanzummeren on 12/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Movie;


@interface MovieList : NSObject

- (void) addMovie:(Movie *) movie inSection:(NSString *) sectionTitle;

+ (MovieList *) movieListWithOneSection:(NSArray *) movies;

- (void) addMovie:(Movie *) movie;

- (void) moveMovieFromIndexPath:(NSIndexPath *) fromIndexPath toIndexPath:(NSIndexPath *) toIndexPath;

- (void) removeMovieAtIndexPath:(NSIndexPath *) indexPath;

- (NSIndexPath *) indexPathForMovie:(Movie *) movie;

- (Movie *) movieAtIndexPath:(NSIndexPath *) indexPath;

- (NSUInteger) numberOfSections;

- (NSUInteger) numberOfMoviesInSection:(NSUInteger) sectionIndex;

- (NSString *) titleForHeaderInSection:(NSInteger) sectionIndex;

- (void) insertMovie:(Movie *) movie atIndexPath:(NSIndexPath *) indexPath;

- (NSInteger) sectionIndexForTitle:(NSString *) title;
@end