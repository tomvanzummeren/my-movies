@class Movie;
@class MoviePosterView;

@interface MovieDetailViewController : UIViewController {
    IBOutlet MoviePosterView *moviePosterView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *overviewLabel;
}

@property (strong, nonatomic) Movie *movie;
@end
