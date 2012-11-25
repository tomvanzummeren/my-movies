#import "MovieDetailViewController.h"
#import "Movie.h"
#import "MoviePosterView.h"
#import "TheMovieDbApiConnector.h"
#import "MovieDetails.h"
#import "VotesView.h"

@implementation MovieDetailViewController {
    TheMovieDbApiConnector *movieRepository;
}

@synthesize movie;

- (void) awakeFromNib {
    movieRepository = [TheMovieDbApiConnector instance];
}

- (void) viewDidLoad {
    self.title = movie.title;
    titleLabel.text = movie.title;
    releaseYearLabel.text = movie.releaseYear;
    [votesView setScore:movie.voteAverage];

    [moviePosterView setPosterImageUrl:movie.posterImageUrl];

    overviewLabel.text = @"";
    [movieRepository loadMovieDetails:movie callback:^(MovieDetails *details) {
        overviewLabel.text = details.overview;
        [overviewLabel sizeToFit];
    }];
}

@end