@class Movie;
@class PosterView;
@class VotesView;

@interface DetailViewController : UIViewController {
    __weak IBOutlet PosterView *moviePosterView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *releaseYearLabel;
    __weak IBOutlet VotesView *votesView;
    __weak IBOutlet UILabel *overviewLabel;
    __weak IBOutlet UIButton *markWatchedButton;
}

@property (strong, nonatomic) Movie *movie;

- (IBAction) markAsWatchedOrNotWatched;

@end
