//
// Created by tomvanzummeren on 11/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface ErrorAlertView : UIAlertView
- (id) initWithError:(NSError *) error;

+ (void) showOnError:(NSError *) error;
@end