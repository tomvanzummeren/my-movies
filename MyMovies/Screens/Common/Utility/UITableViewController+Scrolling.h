//
// Created by tomvanzummeren on 12/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface UITableViewController (Scrolling)

- (void) scrollAnimatedToRowAtIndexPath:(NSIndexPath *) indexPath completion:(void (^) ()) completion;

@end