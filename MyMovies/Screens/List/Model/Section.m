//
// Created by tomvanzummeren on 12/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Section.h"


@implementation Section {

}
@synthesize title;
@synthesize movies;

- (id) init {
    self = [super init];
    if (self) {
        title = nil;
        movies = [NSMutableArray array];
    }
    return self;
}

- (id) initWithTitle:(NSString *) aTitle {
    self = [super init];
    if (self) {
        title = aTitle;
        movies = [NSMutableArray array];
    }
    return self;
}

@end