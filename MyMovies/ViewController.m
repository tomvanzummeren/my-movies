//
//  ViewController.m
//  MyMovies
//
//  Created by Tom van Zummeren on 10/6/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void) viewDidLoad {
    tabBar.selectedItem = [[tabBar items] objectAtIndex:0];
    [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) viewWillAppear:(BOOL) animated {
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:indexPath animated:animated];
    [tableView flashScrollIndicators];
}

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
}

- (IBAction) addNewMovieButtonPressed:(id) sender {
}

@end
