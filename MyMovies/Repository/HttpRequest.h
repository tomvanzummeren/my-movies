
@interface HttpRequest : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSString *method;

- (id) initWithUrl:(NSString *) anUrl;

+ (id) requestWithUrl:(NSString *) anUrl, ...;

- (void) perform:(void (^)(id result)) onSuccess failure:(void (^)()) onFailure;

- (void) cancel;


@end