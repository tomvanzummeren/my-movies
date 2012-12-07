//
// Created by tomvanzummeren on 12/7/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UITableViewController+Scrolling.h"


@implementation UITableViewController (Scrolling)

static void (^onEndScrollingAnimation) () = nil;

- (void) scrollAnimatedToRowAtIndexPath:(NSIndexPath *) indexPath completion:(void (^) ()) completion {
    onEndScrollingAnimation = completion;
    if ([self needsScrollingForIndexPathToMiddle:indexPath]) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        [self scrollViewDidEndScrollingAnimation:(UIScrollView *) self.view];
    }
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *) scrollView {
    if (onEndScrollingAnimation) {
        onEndScrollingAnimation();
        onEndScrollingAnimation = nil;
    }
}

- (BOOL) needsScrollingForIndexPathToMiddle:(NSIndexPath *) indexPath{
    CGFloat targetY = self.tableView.frame.size.height / 2.0;
    CGRect visibleCellFrame = [self.tableView rectForRowAtIndexPath:indexPath];
    if (visibleCellFrame.origin.y < targetY) {
        CGFloat topCellY = visibleCellFrame.origin.y;
        CGFloat bottomCellY = visibleCellFrame.origin.y + visibleCellFrame.size.height;
        targetY = (topCellY + bottomCellY) / 2;
    }

    CGFloat visibleCellY = visibleCellFrame.origin.y - [self.tableView contentOffset].y;

    CGFloat topCellY = visibleCellY;
    CGFloat bottomCellY = visibleCellY + visibleCellFrame.size.height;
    CGFloat middleVisibleCellY = (topCellY + bottomCellY) / 2;
    if (roundf(targetY) == roundf(middleVisibleCellY)) {
        return NO;
    }
    return YES;
}

@end