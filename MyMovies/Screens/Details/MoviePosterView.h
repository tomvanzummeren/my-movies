
@interface MoviePosterView : UIView{
    __weak IBOutlet UIImageView *imageView;
}
- (IBAction) toggleSize;
- (IBAction) handlePanGesture:(UIPanGestureRecognizer *) sender;
@end