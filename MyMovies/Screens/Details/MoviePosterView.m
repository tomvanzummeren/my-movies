
#import "MoviePosterView.h"
#import "UIImageView+WebCache.h"

@implementation MoviePosterView {
    BOOL headerImageMaximized;

    CGFloat smallImageHeight;
    CGFloat maximizedHeight;

    UIView *blackBackground;
}

- (void) awakeFromNib {
    blackBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.superview.frame.size.width, self.superview.frame.size.height)];
    blackBackground.backgroundColor = [UIColor blackColor];
    blackBackground.alpha = 0.0;
    blackBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.superview insertSubview:blackBackground atIndex:0];
}

- (void) layoutSubviews {
    smallImageHeight = 110.0;
    maximizedHeight = self.superview.frame.size.height;
}

#pragma mark - Actions

- (IBAction) toggleSize {
    if (headerImageMaximized) {
        [self restoreHeaderImage:0.0];
    } else {
        [self maximizeImage];
    }
}

- (IBAction) handlePanGesture:(UIPanGestureRecognizer *) sender {
    CGPoint point = [sender translationInView:self];
    CGPoint velocity = [sender velocityInView:self];

    [self updateBackgroundAlpha:point.y];

    if (headerImageMaximized) {
        // minimize image
        self.frame = CGRectMake(0.0, point.y, self.frame.size.width, self.frame.size.height);

        if (sender.state == UIGestureRecognizerStateEnded) {
            [self restoreHeaderImage:velocity.y];
        }
    } else {
        // maximize image
        CGFloat height = smallImageHeight + point.y;
        self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, height);

        if (sender.state == UIGestureRecognizerStateEnded) {
            // TODO: Also do something with velocity here
            [self maximizeImage];
        }
    }
}

#pragma mark - Private methods

- (void) maximizeImage {
    [UIView animateWithDuration:.3 animations:^{
        // TODO: Center the maximized image vertically
        self.frame = CGRectMake(0.0, 0.0, 320.0, maximizedHeight);
        blackBackground.alpha = 1.0;
    }];

    headerImageMaximized = YES;
}

- (void) restoreHeaderImage:(CGFloat) velocity {
    CGFloat targetHeight = smallImageHeight;
    CGFloat currentHeight = imageView.frame.size.height;
    CGFloat distance = currentHeight - targetHeight;
    CGFloat animationDuration = distance / fabsf(velocity);

    // animate at normal speed if the gesture is downwards
    if (velocity >= 0.0) {
        // TODO: If the gesture is downwards, also do some kind of velocity trick
        animationDuration = .3;
    }
    if (animationDuration > .3) {
        animationDuration = .3;
    }

    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, smallImageHeight);
        blackBackground.alpha = 0.0;
    }];

    headerImageMaximized = NO;
}

- (void) updateBackgroundAlpha:(CGFloat) pointY {
    // TODO: Instead of *magic* numbers like 400 and 200, calculate a real percentage based on dragged distance
    CGFloat backgroundAlpha;
    if (headerImageMaximized) {
        backgroundAlpha = 1.0 - fabsf(pointY) / 400.0;
    } else {
        backgroundAlpha = fabsf(pointY) / 200.0;
    }

    if (backgroundAlpha < 0.0) {
        backgroundAlpha = 0.0;
    }
    blackBackground.alpha = backgroundAlpha;
}

- (void) setPosterImageUrl:(NSString *) url {
    if (url) {
        [activityIndicator startAnimating];
        [imageView setImageWithURL:[NSURL URLWithString:url] success:^(UIImage *image) {
            [activityIndicator stopAnimating];
        } failure:^(NSError *error) {
            // Ignore
        }];
    } else {
        imageView.image = nil;
    }
}

@end
