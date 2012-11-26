//
// Created by tomvanzummeren on 11/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ErrorAlertView.h"


@implementation ErrorAlertView {

}

- (id) initWithError:(NSError *) error {
    self = [super initWithTitle:[error localizedDescription]
                        message:[error localizedFailureReason]
                       delegate:nil
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil];
    if (self) {
    }
    return self;
}

+ (void) showOnError:(NSError *) error {
    if (error) {
        [[[ErrorAlertView alloc] initWithError:error] show];
    }
}
@end