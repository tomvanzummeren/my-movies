
#import "MovieListViewController.h"

@implementation MovieListViewController

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
}

@end
