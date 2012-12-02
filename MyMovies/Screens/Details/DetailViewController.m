#import "DetailViewController.h"
#import "Movie.h"
#import "PosterView.h"
#import "TheMovieDbApiConnector.h"
#import "MovieDetails.h"
#import "VotesView.h"

@implementation DetailViewController {
    TheMovieDbApiConnector *apiConnector;
}

@synthesize movie;

- (void) awakeFromNib {
    apiConnector = [TheMovieDbApiConnector instance];
}

- (void) viewDidLoad {
    self.title = movie.title;
    titleLabel.text = movie.title;
    releaseYearLabel.text = movie.releaseYear;
    [votesView setScore:[movie.voteAverage floatValue]];

    [moviePosterView setPosterImageUrl:movie.posterImageUrl];

    overviewLabel.text = @"";
    [apiConnector loadMovieDetails:movie callback:^(MovieDetails *details) {
        overviewLabel.text = details.overview;
        [overviewLabel sizeToFit];
    }];
}

@end