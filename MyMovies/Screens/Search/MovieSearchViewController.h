
@interface MovieSearchViewController : UIViewController<UISearchBarDelegate> {
    __weak IBOutlet UISearchBar *searchBar;
}

- (IBAction) cancelButtonTapped;
@end