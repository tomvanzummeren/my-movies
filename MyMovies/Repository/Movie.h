//
//  Movie.h
//  MyMovies
//
//  Created by Tom van Zummeren on 11/25/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, strong) NSString * iconImageUrl;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSString * posterImageUrl;
@property (nonatomic, strong) NSDate * releaseDate;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * voteAverage;

@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * order;

- (NSString *) releaseYear;

- (NSString *) uppercaseFirstLetterOfTitle;

- (BOOL) persisted;
@end
