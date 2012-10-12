@class Movie;
@class MoviePosterView;
@class VotesView;

@interface MovieDetailViewController : UIViewController {
    __weak IBOutlet MoviePosterView *moviePosterView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *releaseYearLabel;
    __weak IBOutlet VotesView *votesView;
    __weak IBOutlet UILabel *overviewLabel;
}

@property (strong, nonatomic) Movie *movie;
@end
