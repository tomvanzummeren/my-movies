
#import "MovieDetailViewController.h"
#import "Movie.h"
#import "MoviePosterView.h"

@implementation MovieDetailViewController

@synthesize movie;

- (void) viewDidLoad {
    self.title = movie.title;
    titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", movie.title, movie.releaseYear];
    overviewLabel.text = movie.overview;

    [moviePosterView setPosterImageUrl:movie.posterImageUrl];
}

@end
