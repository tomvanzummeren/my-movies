@interface PosterView : UIView{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}
- (IBAction) toggleSize;
- (IBAction) handlePanGesture:(UIPanGestureRecognizer *) sender;

- (void) setPosterImageUrl:(NSString *) url;

@end
