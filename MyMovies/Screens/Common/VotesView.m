
#import "VotesView.h"

@implementation VotesView {
    NSArray *starViews;
}

- (void) awakeFromNib {
    starViews = [NSArray arrayWithObjects:starView1, starView2, starView3, starView4, starView5, nil];
}

- (void) setScore:(CGFloat) score {
    CGFloat filledStarsCount = score / 2.0;
    CGFloat index = 0;
    for (UIImageView *starView in starViews) {
        if (filledStarsCount >= index + 1.0) {
            starView.image = [UIImage imageNamed:@"star-full"];
        } else if (filledStarsCount >= index + 0.5) {
            starView.image = [UIImage imageNamed:@"star-half"];
        } else {
            starView.image = [UIImage imageNamed:@"star-none"];
        }
        index ++;
    }
}

@end