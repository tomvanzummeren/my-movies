//
// Created by tomvanzummeren on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Movie : NSObject

@property (nonatomic) NSInteger identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *releaseDate;

// TODO: See how bad we want "overview" to be in search results. Needs separate API call.
@property (strong, nonatomic) NSString *overview;

@property (strong, nonatomic) NSString *iconImageUrl;
@property (strong, nonatomic) NSString *posterImageUrl;
@property(nonatomic) NSInteger voteAverage;

- (NSString *) releaseYear;
@end