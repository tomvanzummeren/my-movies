
@interface VotesView : UIView {
    __weak IBOutlet UIImageView *starView1;
    __weak IBOutlet UIImageView *starView2;
    __weak IBOutlet UIImageView *starView3;
    __weak IBOutlet UIImageView *starView4;
    __weak IBOutlet UIImageView *starView5;
}

- (void) setScore:(CGFloat) score;
@end