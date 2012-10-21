
#import "MovieDetailViewController.h"
#import "Movie.h"
#import "MoviePosterView.h"
#import "MovieRepository.h"
#import "MovieDetails.h"
#import "VotesView.h"

@implementation MovieDetailViewController {
    MovieRepository *movieRepository;
}

@synthesize movie;

- (void) awakeFromNib {
    movieRepository = [MovieRepository instance];
}

- (void) viewDidLoad {
    self.title = movie.title;
    titleLabel.text = movie.title;
    releaseYearLabel.text = movie.releaseYear;
    [votesView setScore:movie.voteAverage];

    [moviePosterView setPosterImageUrl:movie.posterImageUrl];

    overviewLabel.text = @"Baas";
    [movieRepository loadMovieDetails:movie callback:^(MovieDetails *details) {
        overviewLabel.text = details.overview;
        [overviewLabel sizeToFit];
    }];
}

@end
