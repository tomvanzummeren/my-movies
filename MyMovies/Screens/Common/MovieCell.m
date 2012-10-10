
#import "MovieCell.h"
#import "Movie.h"

#define MARGIN 5

@implementation MovieCell

- (void) setMovie:(Movie *) movie {
    iconImageView.image = movie.iconImage;
    titleLabel.text = movie.title;
    releaseYearLabel.text = [NSString stringWithFormat:@"(%@)", movie.releaseYear];
    overviewLabel.text = movie.overview;

    CGFloat titleTextWidth = [titleLabel.text sizeWithFont:titleLabel.font].width;
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleTextWidth, titleLabel.frame.size.height);

    releaseYearLabel.frame = CGRectMake(
            titleLabel.frame.origin.x + titleLabel.frame.size.width + MARGIN,
            releaseYearLabel.frame.origin.y,
            releaseYearLabel.frame.size.width,
            releaseYearLabel.frame.size.height);
}

@end