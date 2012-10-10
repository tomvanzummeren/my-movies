@class Movie;

@interface MovieCell : UITableViewCell {
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *releaseYearLabel;
    __weak IBOutlet UILabel *overviewLabel;
}

- (void) setMovie:(Movie *) movie;
@end

