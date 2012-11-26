//
// Created by tomvanzummeren on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "MyMoviesWindow.h"
#import "MovieCell.h"


@implementation MyMoviesWindow {
    UIImageView *movieCellSnapshot;
    CGAffineTransform originalTransform;
}

- (void) displayOverlappingMovieCell:(MovieCell *) cell {
    // Just to be sure ...
    [movieCellSnapshot removeFromSuperview];

    CGRect frame = [cell.superview convertRect:cell.frame toView:self];

    movieCellSnapshot = [[UIImageView alloc] initWithFrame:frame];
    movieCellSnapshot.image = [self imageFromLayer:cell.layer];
    movieCellSnapshot.backgroundColor = [UIColor whiteColor];

    [self addSubview:movieCellSnapshot];

    originalTransform = movieCellSnapshot.transform;
    [UIView animateWithDuration:.3 animations:^{
        movieCellSnapshot.transform = CGAffineTransformScale(movieCellSnapshot.transform, 1.15, 1.15);
    }];
}

- (void) animateMoveOverlappingMovieCellToPosition:(CGPoint) point inView:(UITableView *) view completion:(void (^)()) completion {
    if (!movieCellSnapshot) {
        if (completion) {
            completion();
        }
        return;
    }
    CGPoint convertedPoint = [view.superview convertPoint:point toView:self];

    [UIView animateWithDuration:.3 animations:^{
        movieCellSnapshot.transform = originalTransform;
        movieCellSnapshot.frame = CGRectMake(
                convertedPoint.x,
                convertedPoint.y,
                movieCellSnapshot.frame.size.width,
                movieCellSnapshot.frame.size.height);
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        [movieCellSnapshot removeFromSuperview];
        movieCellSnapshot = nil;
    }];
}

- (UIImage *) imageFromLayer:(CALayer *) layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 2.0);

    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return outputImage;
}

@end