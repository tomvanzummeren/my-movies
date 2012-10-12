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
@property (strong, nonatomic) NSString *iconImageUrl;
@property (strong, nonatomic) NSString *posterImageUrl;
@property(nonatomic) CGFloat voteAverage;

- (NSString *) releaseYear;
@end