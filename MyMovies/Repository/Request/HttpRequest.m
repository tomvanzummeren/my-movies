
#import "HttpRequest.h"
#import "SBJson.h"

@implementation HttpRequest {
    NSString *url;

    void (^success) (id);

    void (^failure) ();

    NSMutableData *receivedData;

    SBJsonParser *parser;

    NSURLConnection *currentConnection;
}
@synthesize method;

- (id) initWithUrl:(NSString *) anUrl {
    self = [super init];
    if (self) {
        url = anUrl;
        method = @"GET";
        parser = [SBJsonParser new];
    }
    return self;
}

+ (id) requestWithUrl:(NSString *) anUrl, ... {
    va_list arguments;
    va_start(arguments, anUrl);

    NSString *formattedUrl = [[NSString alloc] initWithFormat:anUrl arguments:arguments];

    va_end(arguments);
    return [[HttpRequest alloc] initWithUrl:formattedUrl];
}

- (void) perform:(void (^)(id response)) onSuccess failure:(void (^)()) onFailure {
    success = [onSuccess copy];
    failure = [onFailure copy];

    NSLog(@"%@: %@", method, url);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]
                                                     cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                 timeoutInterval:10.0];
    currentConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (void) cancel {
    [currentConnection cancel];
}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response {
    receivedData = [NSMutableData dataWithLength:0];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data {
    [receivedData appendData:data];
}

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error {
    if (failure) {
        failure();
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
    id result = [parser objectWithData:receivedData];
    if (success) {
        success(result);
    }
}

@end