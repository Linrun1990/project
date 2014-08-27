/*

    DLStarRating
    Copyright (C) 2011 David Linsin <dlinsin@gmail.com> 

    All rights reserved. This program and the accompanying materials
    are made available under the terms of the Eclipse Public License v1.0
    which accompanies this distribution, and is available at
    http://www.eclipse.org/legal/epl-v10.html

 */

#import <UIKit/UIKit.h>

#define kDJDefaultNumberOfStars 5
#define kDJNumberOfFractions 10

@protocol DJStarRatingDelegate;

@interface DJStarRatingControl : UIControl {
	int numberOfStars;
	int currentIdx;
	UIImage *star;
	UIImage *highlightedStar;
	IBOutlet id<DJStarRatingDelegate> delegate;
    BOOL isFractionalRatingEnabled;
}

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame
           andStars:(NSUInteger)_numberOfStars 
       isFractional:(BOOL)isFract
        defaultStar:(NSString *)defaultStarImage 
    highlightedStar:(NSString *)highlightedStarImage;
- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage atIndex:(int)index;

@property (retain,nonatomic) UIImage *star;
@property (retain,nonatomic) UIImage *highlightedStar;
@property (nonatomic) float rating;
@property (retain,nonatomic) id<DJStarRatingDelegate> delegate;
@property (nonatomic,assign) BOOL isFractionalRatingEnabled;

@end

@protocol DJStarRatingDelegate

-(void)newRating:(DJStarRatingControl *)control :(float)rating;

@end
