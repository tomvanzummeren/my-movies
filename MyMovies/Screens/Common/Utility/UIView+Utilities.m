//
// Created by tomvanzummeren on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIView+Utilities.h"


@implementation UIView (Utilities)

- (void) logViewTree {
    [UIView logViewTreeForView:self level:0];
}

+ (void) logViewTreeForView:(UIView *) view level:(int) level {
    NSString *indent = @"";
    for (int i = 0; i < level; i++) {
        indent = [indent stringByAppendingString:@"    "];
    }
    Log(@"%@%@", indent, view);
    for (UIView *subView in view.subviews) {
        [self logViewTreeForView:subView level:level+1];
    }
}

@end