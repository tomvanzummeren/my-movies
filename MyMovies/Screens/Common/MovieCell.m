#import "MovieCell.h"
#import "Movie.h"
#import "UIImageView+WebCache.h"
#import "VotesView.h"

#define MARGIN_BETWEEN_TITLE_AND_YEAR 5
#define RIGHT_MARGIN 25

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
    [votesView setScore:movie.voteAverage];

    CGFloat titleTextWidth = [titleLabel.text sizeWithFont:titleLabel.font].width;
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleTextWidth, titleLabel.frame.size.height);

    [self adjustReleaseYearPosition];

}

- (void) adjustReleaseYearPosition {
    [releaseYearLabel sizeToFit];
    CGFloat releaseYearX = titleLabel.frame.origin.x + titleLabel.frame.size.width + MARGIN_BETWEEN_TITLE_AND_YEAR;
    CGFloat adjustedReleaseYearX = releaseYearX;
    if ((releaseYearX + releaseYearLabel.frame.size.width) > (self.frame.size.width - RIGHT_MARGIN)) {
        adjustedReleaseYearX = self.frame.size.width - RIGHT_MARGIN - releaseYearLabel.frame.size.width;
    }
    CGFloat deltaReleaseYearX = adjustedReleaseYearX - releaseYearX;
    releaseYearX = adjustedReleaseYearX;

    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width + deltaReleaseYearX, titleLabel.frame.size.height);

    releaseYearLabel.frame = CGRectMake(
            releaseYearX,
            releaseYearLabel.frame.origin.y,
            releaseYearLabel.frame.size.width,
            releaseYearLabel.frame.size.height);
}

- (Movie *) movie {
    return movie;
}

@end