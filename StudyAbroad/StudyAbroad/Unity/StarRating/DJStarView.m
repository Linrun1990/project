/*
 
 DLStarRating
 Copyright (C) 2011 David Linsin <dlinsin@gmail.com> 
 
 All rights reserved. This program and the accompanying materials
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 */

#import "DJStarView.h"
#import "DJStarRatingControl.h"

#define kEdgeInsetBottom 0

@implementation DJStarView

#pragma mark -
#pragma mark Initialization

- (id)initWithDefault:(UIImage*)star highlighted:(UIImage*)highlightedStar position:(int)index allowFractions:(BOOL)fractions {
	self = [super initWithFrame:CGRectZero];
    
	if (self) {
        [self setTag:index];
        if (fractions) {
            highlightedStar = [self croppedImage:highlightedStar];
            star = [self croppedImage:star];
        }
        self.frame = CGRectMake((star.size.width*index), 0, star.size.width, star.size.height+kEdgeInsetBottom);
        [self setStarImage:star highlightedStarImage:highlightedStar];
		[self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, kEdgeInsetBottom, 0)];
		[self setBackgroundColor:[UIColor clearColor]];
        if (index == 0) {
   	        [self setAccessibilityLabel:@"1 star"];
        } else {
   	        [self setAccessibilityLabel:[NSString stringWithFormat:@"%d stars", index+1]];   
        }
	}
	return self;
}


- (UIImage *)croppedImage:(UIImage*)image {
    float partWidth = image.size.width * 1.0 /kDJNumberOfFractions * image.scale;
    int part = (self.tag+kDJNumberOfFractions)%kDJNumberOfFractions;
    float xOffset = partWidth*part;
    CGRect newFrame = CGRectMake(xOffset, 0, partWidth , image.size.height * image.scale);
    CGImageRef resultImage = CGImageCreateWithImageInRect([image CGImage], newFrame);
    UIImage *result = [UIImage imageWithCGImage:resultImage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(resultImage);
    return result;
}

#pragma mark -
#pragma mark UIView methods

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	return self.superview;
}

#pragma mark -
#pragma mark Layouting

- (void)centerIn:(CGRect)_frame with:(int)numberOfStars {
	CGFloat scale = _frame.size.height / self.frame.size.height;
    CGRect frame = self.frame;
    frame.origin.x *= scale;
    frame.size.height *= scale;
    frame.size.width *= scale;
    self.frame = frame;
    
	CGSize size = self.frame.size;
	float height = self.frame.size.height;
	float frameHeight = _frame.size.height;
	float newY = (frameHeight-height)/2;
	
//	float widthOfStars = self.frame.size.width * numberOfStars;
//	float frameWidth = _frame.size.width;
//	float gapToApply = (frameWidth - widthOfStars)/2;
    
    CGFloat offsetX = self.tag/10 * 2;
	self.frame = CGRectMake((size.width*self.tag) + offsetX, newY, size.width, size.height);
}

- (void)setStarImage:(UIImage*)starImage highlightedStarImage:(UIImage*)highlightedImage {
    [self setImage:starImage forState:UIControlStateNormal];
    [self setImage:highlightedImage forState:UIControlStateSelected];
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

@end
