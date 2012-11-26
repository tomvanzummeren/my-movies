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

@property (nonatomic, retain) NSString * iconImageUrl;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * posterImageUrl;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * voteAverage;

- (NSString *) releaseYear;

+ (Movie *) transientInstance;

@end
