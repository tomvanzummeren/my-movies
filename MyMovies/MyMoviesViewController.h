
@interface MyMoviesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITabBar *tabBar;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UITableView *tableView;
}

- (IBAction) addNewMovieButtonPressed:(id) sender;

@end
