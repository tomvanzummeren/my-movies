
#import "MovieDetailViewController.h"
#import "Movie.h"
#import "MoviePosterView.h"
#import "MovieRepository.h"
#import "MovieDetails.h"

@implementation MovieDetailViewController {
    MovieRepository *movieRepository;
}

@synthesize movie;

- (void) awakeFromNib {
    movieRepository = [MovieRepository instance];
}

- (void) viewDidLoad {
    self.title = movie.title;
    titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", movie.title, movie.releaseYear];

    [moviePosterView setPosterImageUrl:movie.posterImageUrl];

    overviewLabel.text = @"";
    [movieRepository loadMovieDetails:movie callback:^(MovieDetails *details) {
        overviewLabel.text = details.overview;
    }];
}

@end
