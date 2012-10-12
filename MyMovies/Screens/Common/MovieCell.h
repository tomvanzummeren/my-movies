@class Movie;

@interface MovieCell : UITableViewCell {
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *releaseYearLabel;
}

@property (strong, nonatomic) Movie* movie;

@end

