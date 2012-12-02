//
// Created by tomvanzummeren on 10/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDictionary+JSON.h"


@implementation NSDictionary (JSON)

- (NSString *) stringForKey:(NSString *) key {
    id value = self[key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}

- (NSInteger) integerForKey:(NSString *) key {
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (CGFloat) floatForKey:(NSString *) key {
    id value = self[key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return 0;
}


@end