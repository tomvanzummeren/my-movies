@class Movie;

@interface MovieSearchViewController : UIViewController<UISearchBarDelegate> {
    __weak IBOutlet UISearchBar *searchBar;
}
@property (copy, nonatomic) void (^onMovieSelected)(Movie *movie);

- (IBAction) cancelButtonTapped;
@end