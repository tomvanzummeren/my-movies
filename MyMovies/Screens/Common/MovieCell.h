@class Movie;
@class VotesView;

@interface MovieCell : UITableViewCell {
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *releaseYearLabel;
    __weak IBOutlet VotesView *votesView;
}

@property (strong, nonatomic) Movie* movie;

@end

