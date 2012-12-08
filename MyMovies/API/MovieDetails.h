
@interface MovieDetails : NSObject

@property (nonatomic) NSInteger identifier;
@property (strong, nonatomic) NSString *overview;

- (void) fillMissingFields:(MovieDetails *) details;
@end