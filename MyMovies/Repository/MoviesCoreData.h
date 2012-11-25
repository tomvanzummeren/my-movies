//
//  MoviesCoreData.h
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

@interface MoviesCoreData : NSObject

+ (MoviesCoreData *) instance;

- (void) addMovie:(Movie *) movie withType: (MovieListType) type;

- (void) deleteMovie:(Movie *) movie withType: (MovieListType) type;

- (NSMutableArray *) getMovies:(MovieListType) type;

@end
