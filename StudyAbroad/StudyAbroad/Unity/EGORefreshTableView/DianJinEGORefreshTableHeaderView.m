//
//  DianJinEGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DianJinEGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface DianJinEGORefreshTableHeaderView ()

- (void)setState:(EGOPullRefreshState)aState;

@end


@implementation DianJinEGORefreshTableHeaderView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

		_lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		_lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		_lastUpdatedLabel.textColor = TEXT_COLOR;
		_lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		_lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_lastUpdatedLabel];
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = TEXT_COLOR;
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_statusLabel];
		
		_arrowImage = [CALayer layer];
		_arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		_arrowImage.contentsGravity = kCAGravityResizeAspect;
		_arrowImage.contents = (id)[UIImage imageNamed:@"headerArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			_arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:_arrowImage];

		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
		
		[self setState:kDJEGOOPullRefreshNormal];
    }
	
    return self;
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	if (_delegate!=nil && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"MM-dd hh:mm"];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最新更新: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} 
	else {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(EGOPullRefreshState)aState {
	switch (aState) {
		case kDJEGOOPullRefreshPulling:
			_statusLabel.text = NSLocalizedString(@"松开立即更新...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		case kDJEGOOPullRefreshNormal:
			if (_state == kDJEGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"下拉即可更新...", @"Pull down to refresh...");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			break;
		case kDJEGOOPullRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"正在加载数据...", @"Pull down to refresh status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			break;
		default:
			break;
	}
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	if (_state == kDJEGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	} 
	else if (scrollView.isDragging) {
		if (_state == kDJEGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
			[self setState:kDJEGOOPullRefreshNormal];
		} 
		else if (_state == kDJEGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
			[self setState:kDJEGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {	
	if (scrollView.contentOffset.y <= - 65.0f) {
        [self setState:kDJEGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
        
        DELEGATE_CALLBACK_ONE_PARAMETER(_delegate, egoRefreshTableHeaderDidTriggerRefresh:, self);
	}	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:kDJEGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
    
    [_activityView release];
    _activityView = nil;
    
    [_statusLabel release];
    _statusLabel = nil;
    
    [_lastUpdatedLabel release];
    _lastUpdatedLabel = nil;

	_arrowImage = nil;

    [super dealloc];
}

@end
