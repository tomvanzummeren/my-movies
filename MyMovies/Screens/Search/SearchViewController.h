@class Movie;

@interface SearchViewController : UIViewController<UISearchBarDelegate> {
    __weak IBOutlet UISearchBar *searchBar;
}
@property (copy, nonatomic) void (^onMovieSelected)(Movie *movie);

- (IBAction) cancelButtonTapped;
@end