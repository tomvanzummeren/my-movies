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
}

- (void) displayOverlappingMovieCell:(MovieCell *) cell atPoint:(CGPoint) point {
    movieCellSnapshot = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, cell.frame.size.width, cell.frame.size.height)];
    movieCellSnapshot.image = [self imageFromLayer:cell.layer];
    movieCellSnapshot.backgroundColor = [UIColor whiteColor];
    [self addSubview:movieCellSnapshot];

}

- (UIImage *) imageFromLayer:(CALayer *) layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 2.0);

    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return outputImage;
}

@end