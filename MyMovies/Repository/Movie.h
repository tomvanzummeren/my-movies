//
// Created by tomvanzummeren on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *releaseYear;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) UIImage *iconImage;
@property (strong, nonatomic) UIImage *posterImage;

@end