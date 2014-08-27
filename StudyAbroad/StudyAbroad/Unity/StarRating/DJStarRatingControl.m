/*

    DLStarRating
    Copyright (C) 2011 David Linsin <dlinsin@gmail.com> 

    All rights reserved. This program and the accompanying materials
    are made available under the terms of the Eclipse Public License v1.0
    which accompanies this distribution, and is available at
    http://www.eclipse.org/legal/epl-v10.html

 */

#import "DJStarRatingControl.h"
#import "DJStarView.h"

@interface DJStarRatingControl()

- (UIView *)subviewWithTag:(NSInteger)tag;

@end
@implementation DJStarRatingControl

@synthesize star, highlightedStar, delegate, isFractionalRatingEnabled;

#pragma mark -
#pragma mark Initialization

- (void)setupView {
	self.clipsToBounds = YES;
	currentIdx = -1;
	for (int i=0; i<numberOfStars; i++) {
		DJStarView *v = [[DJStarView alloc] initWithDefault:self.star highlighted:self.highlightedStar position:i allowFractions:isFractionalRatingEnabled];
		[self addSubview:v];
		[v release];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		numberOfStars = kDJDefaultNumberOfStars;
        if (isFractionalRatingEnabled)
            numberOfStars *=kDJNumberOfFractions;
		[self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		numberOfStars = kDJDefaultNumberOfStars;
        if (isFractionalRatingEnabled)
            numberOfStars *=kDJNumberOfFractions;
        [self setupView];

	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
           andStars:(NSUInteger)_numberOfStars 
       isFractional:(BOOL)isFract
        defaultStar:(NSString *)defaultStarImage 
    highlightedStar:(NSString *)highlightedStarImage {
	self = [super initWithFrame:frame];
	if (self) {
        isFractionalRatingEnabled = isFract;
		numberOfStars = _numberOfStars;
        if (isFractionalRatingEnabled)
            numberOfStars *= kDJNumberOfFractions;
        self.star = [[DianJinLocalImageCache sharedInstance]imageCacheWithName:defaultStarImage];
        self.highlightedStar = [[DianJinLocalImageCache sharedInstance]imageCacheWithName:highlightedStarImage];
		[self setupView];
	}
	return self;
}

- (void)layoutSubviews {
	for (int i=0; i < numberOfStars; i++) {
        DJStarView *starView = (DJStarView *)[self subviewWithTag:i];
		[starView centerIn:self.frame with:numberOfStars];
	}
}

#pragma mark -
#pragma mark Customization

- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage atIndex:(int)index {
    DJStarView *selectedStar = (DJStarView*)[self subviewWithTag:index];
    
    // check if star exists
    if (!selectedStar) return;
    
    // check images for nil else use default stars
    defaultStarImage = (defaultStarImage) ? defaultStarImage : star;
    highlightedStarImage = (highlightedStarImage) ? highlightedStarImage : highlightedStar;
    
    [selectedStar setStarImage:defaultStarImage highlightedStarImage:highlightedStarImage];
}

#pragma mark -
#pragma mark Touch Handling

- (UIButton*)starForPoint:(CGPoint)point {
	for (int i=0; i < numberOfStars; i++) {
		if (CGRectContainsPoint([self subviewWithTag:i].frame, point)) {
			return (UIButton*)[self subviewWithTag:i];
		}
	}
	return nil;
}

- (void)disableStarsDownToExclusive:(int)idx {
	for (int i=numberOfStars; i > idx; --i) {
		UIButton *b = (UIButton*)[self subviewWithTag:i];
		b.highlighted = NO;
	}
}

- (void)disableStarsDownTo:(int)idx {
	for (int i=numberOfStars; i >= idx; --i) {
		UIButton *b = (UIButton*)[self subviewWithTag:i];
		b.highlighted = NO;
	}
}


- (void)enableStarsUpTo:(int)idx {
	for (int i=0; i <= idx; i++) {
		UIButton *b = (UIButton*)[self subviewWithTag:i];
		b.highlighted = YES;
	}
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [touch locationInView:self];	
	UIButton *pressedButton = [self starForPoint:point];
	if (pressedButton) {
		int idx = pressedButton.tag;
		if (pressedButton.highlighted) {
			[self disableStarsDownToExclusive:idx];
		} else {
			[self enableStarsUpTo:idx];
		}		
		currentIdx = idx;
	} 
	return YES;		
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
	[super cancelTrackingWithEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [touch locationInView:self];
	
	UIButton *pressedButton = [self starForPoint:point];
	if (pressedButton) {
		int idx = pressedButton.tag;
		UIButton *currentButton = (UIButton*)[self subviewWithTag:currentIdx];
		
		if (idx < currentIdx) {
			currentButton.highlighted = NO;
			currentIdx = idx;
			[self disableStarsDownToExclusive:idx];
		} else if (idx > currentIdx) {
			currentButton.highlighted = YES;
			pressedButton.highlighted = YES;
			currentIdx = idx;
			[self enableStarsUpTo:idx];
		}
	} else if (point.x < [self subviewWithTag:0].frame.origin.x) {
		((UIButton*)[self subviewWithTag:0]).highlighted = NO;
		currentIdx = -1;
		[self disableStarsDownToExclusive:0];
	}
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	[self.delegate newRating:self :self.rating];
	[super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark -
#pragma mark Rating Property

- (void)setRating:(float)_rating {
    if (isFractionalRatingEnabled) {
        _rating *= kDJNumberOfFractions;
    }
	[self disableStarsDownTo:0];
	currentIdx = (int)_rating-1;
	[self enableStarsUpTo:currentIdx];
}

- (float)rating {
    if (isFractionalRatingEnabled) {
        return (float)(currentIdx+1)/kDJNumberOfFractions;
    }
	return (NSUInteger)currentIdx+1;
}


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	self.star = nil;
	self.highlightedStar = nil;
	self.delegate = nil;
	[super dealloc];
}

#pragma mark -private


- (UIView *)subviewWithTag:(NSInteger)tag
{
    for (UIView *v in self.subviews) {
		if (v.tag == tag) {
			return v;
		}
	}
	return nil;
}

@end
