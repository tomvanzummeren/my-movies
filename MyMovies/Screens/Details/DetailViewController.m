#import "DetailViewController.h"
#import "Movie.h"
#import "PosterView.h"
#import "TheMovieDbApiConnector.h"
#import "MovieDetails.h"
#import "VotesView.h"
#import "MoviesRepository.h"

@implementation DetailViewController {
    TheMovieDbApiConnector *apiConnector;
    MoviesRepository *movieRepository;
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
    movieRepository = [MoviesRepository instance];

    [self setMarkWatchedButtonTitle];
}

- (void) setMarkWatchedButtonTitle {
    if (![movie persisted]) {
        markWatchedButton.hidden = YES;
        return;
    }
    if ([movieRepository isMovieWatched:movie]) {
        [markWatchedButton setTitle:NSLocalizedString(@"Mark as not watched", nil) forState:UIControlStateNormal];
    } else {
        [markWatchedButton setTitle:NSLocalizedString(@"Mark as watched", nil) forState:UIControlStateNormal];
    }
    [markWatchedButton sizeToFit];
    markWatchedButton.frame = CGRectMake(
            (self.view.frame.size.width / 2) - (markWatchedButton.frame.size.width / 2),
            markWatchedButton.frame.origin.y,
            markWatchedButton.frame.size.width,
            markWatchedButton.frame.size.height);
}

- (IBAction) markAsWatchedOrNotWatched {
    [movieRepository toggleMovieWatched:movie];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggledMovieWatched"
                                                        object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

@end