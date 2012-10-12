//
// Created by tomvanzummeren on 10/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

- (NSString *) stringForKey:(NSString *) key;

- (NSInteger) integerForKey:(NSString *) key;

- (CGFloat) floatForKey:(NSString *) key;

@end