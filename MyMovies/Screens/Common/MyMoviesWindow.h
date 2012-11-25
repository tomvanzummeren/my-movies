//
// Created by tomvanzummeren on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class MovieCell;


@interface MyMoviesWindow : UIWindow
- (void) displayOverlappingMovieCell:(MovieCell *) cell;

- (void) animateMoveOverlappingMovieCellToPosition:(CGPoint) point inView:(UITableView *) view completion:(void (^)()) completion;
@end