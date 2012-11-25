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

@interface MoviesRepository : NSObject

+ (MoviesRepository *) instance;

- (void) addMovie:(Movie *) movie withType: (MovieListType) type;

- (void) deleteMovie:(Movie *) movie withType: (MovieListType) type;

- (void)moveMovie:(NSInteger)sourceRow toRow:(NSInteger)destinationRow;

- (NSMutableArray *) getMovies:(MovieListType) type;

@end
