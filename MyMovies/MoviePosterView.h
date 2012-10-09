//
//  MoviePosterView.h
//  MyMovies
//
//  Created by Jim van Zummeren on 10/7/12.
//  Copyright (c) 2012 Tom van Zummeren. All rights reserved.
//


@interface MoviePosterView : UIView{
    __weak IBOutlet UIImageView *imageView;
}
- (IBAction) toggleSize;
- (IBAction) handlePanGesture:(UIPanGestureRecognizer *) sender;
@end
