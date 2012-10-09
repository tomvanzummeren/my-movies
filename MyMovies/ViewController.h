//
//  ViewController.h
//  MyMovies
//
//  Created by Tom van Zummeren on 10/6/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITabBar *tabBar;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UITableView *tableView;
}

- (IBAction) addNewMovieButtonPressed:(id) sender;

@end
