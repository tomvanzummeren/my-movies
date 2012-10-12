
#import "MovieCell.h"
#import "Movie.h"
#import "UIImageView+WebCache.h"

#define MARGIN 5

@implementation MovieCell {
    Movie *movie;
}

- (void) setMovie:(Movie *) aMovie {
    movie = aMovie;

    if (movie.iconImageUrl) {
        [iconImageView setImageWithURL:[[NSURL alloc] initWithString:movie.iconImageUrl]];
    } else {
        iconImageView.image = nil;
    }
    titleLabel.text = movie.title;
    if (movie.releaseYear) {
        releaseYearLabel.text = [NSString stringWithFormat:@"(%@)", movie.releaseYear];
    } else {
        releaseYearLabel.text = @"";
    }

    CGFloat titleTextWidth = [titleLabel.text sizeWithFont:titleLabel.font].width;
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleTextWidth, titleLabel.frame.size.height);

    releaseYearLabel.frame = CGRectMake(
            titleLabel.frame.origin.x + titleLabel.frame.size.width + MARGIN,
            releaseYearLabel.frame.origin.y,
            releaseYearLabel.frame.size.width,
            releaseYearLabel.frame.size.height);
}

- (Movie *) movie {
    return movie;
}

@end