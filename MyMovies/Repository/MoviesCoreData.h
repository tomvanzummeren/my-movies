//
//  MoviesCoreData.h
//  MyMovies
//
//  Created by Jim van Zummeren on 11/23/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "Movie.h"

@interface MoviesCoreData : NSObject
+ (MoviesCoreData *) instance;

- (void) addMovie:(Movie *) movie;
- (NSMutableArray *) getMovies;

@end
