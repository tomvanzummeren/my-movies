//
//  MoviesRepository.h
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "Movie.h"

typedef enum {
    ToWatchList,
    WatchedList
} MovieListType;

@interface MoviesRepository : NSObject;

+ (MoviesRepository *) instance;

- (void) addMovie:(Movie *) movie withType: (MovieListType) type;

- (void) deleteMovie:(Movie *) movie;

- (void) moveMovieFrom:(NSNumber *) sourceOrder toRow:(NSNumber *) destinationOrder withType:(MovieListType) type;

- (NSMutableArray *) getMovies:(MovieListType) type sortBy:(NSString *) sortOrder ascending:(BOOL) ascending;

- (BOOL) isMovieWatched:(Movie *) movie;

- (void) toggleMovieWatched:(Movie *) movie;

@end
