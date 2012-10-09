
#import "MovieListViewController.h"

@implementation MovieListViewController

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSLog(@"cell: %@", cell);
    return cell;
}

@end
