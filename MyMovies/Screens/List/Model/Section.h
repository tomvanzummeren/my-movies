//
// Created by tomvanzummeren on 12/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Section : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *movies;

- (id) initWithTitle:(NSString *) aTitle;

@end