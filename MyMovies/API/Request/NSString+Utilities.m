//
// Created by tomvanzummeren on 10/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSString+Utilities.h"


@implementation NSString (Utilities)

- (NSString *) urlEncodedString {
    return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(
            NULL, (__bridge CFStringRef) self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

@end