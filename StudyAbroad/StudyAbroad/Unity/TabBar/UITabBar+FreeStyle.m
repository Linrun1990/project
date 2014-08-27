//
//  UITabBar+FreeStyle.m
//  BDKit
//
//  Created by Liu Jinyong on 14-1-14.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import "UITabBar+FreeStyle.h"

#define TAB_BAR_HEIGHT 49

@implementation UITabBar (FreeStyle)

- (void)drawRect:(CGRect)rect {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
	self.frame = CGRectMake(0, screenSize.height - TAB_BAR_HEIGHT, screenSize.width, TAB_BAR_HEIGHT);

	for (UIView *subView in self.superview.subviews) {
		if ([[subView description] hasPrefix:@"<UITransitionView"]) {
			CGRect frame = subView.frame ;
			frame.size.height = self.frame.origin.y;
			subView.frame = frame;
		}
	}
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [subView removeFromSuperview];
        }
    }
    self.backgroundColor = [UIColor clearColor];
}

@end
