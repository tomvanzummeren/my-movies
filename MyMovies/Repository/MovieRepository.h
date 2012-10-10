
@interface MovieRepository : NSObject

+ (MovieRepository *) instance;

- (void) search:(NSString *) searchText callback:(void (^)(NSArray *)) callback;

@end