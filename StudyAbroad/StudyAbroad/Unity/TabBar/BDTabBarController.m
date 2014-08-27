//
//  BDTabBarController.m
//  BDKit
//
//  Created by Liu Jinyong on 13-8-21.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BDTabBarController.h"
#import "BDTabBarButton.h"
#import "UITabBar+FreeStyle.h"

#define TAB_SELECTED_ANIMATION_DURATION 0.3
#define ITEM_TAG_OFFSET                 100

#define SELECTION_VIEW_TOP self.tabBar.frame.size.height - 14
#define SELECTION_VIEW_HEIGHT 9

@interface BDTabBarController() {
    NSMutableArray *_buttons;
}

@end


@implementation BDTabBarController

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttons = [[NSMutableArray alloc] initWithCapacity:4];
    
    _selectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SELECTION_VIEW_TOP, 0, SELECTION_VIEW_HEIGHT)];
    [self setBackgroundView:[[[UIView alloc] init] autorelease]];
}

- (void)dealloc {
    [_buttons release];
    [_backgroundView release];
    [_selectionView release];
    [super dealloc];
}

- (void)addNewTipAtIndex:(NSInteger)index {
    NSParameterAssert(index < [_buttons count]);
    
    BDTabBarButton * btn = _buttons[index];
    [btn setNeedsDisplay];
}

- (void)removeTipAtIndex:(NSInteger)index {
    NSParameterAssert(index < [_buttons count]);
    
    BDTabBarButton * btn = _buttons[index];
    btn.badgeImage = nil;
    [btn setNeedsDisplay];
}

- (void)setBackgroundView:(UIView *)backgroundView {
    [backgroundView retain];
    
    [_backgroundView removeFromSuperview];
    [_backgroundView release];
    
    _backgroundView = backgroundView;
    
    [self.tabBar addSubview:_backgroundView];
	self.tabBar.clipsToBounds = NO;
    [self.tabBar drawRect:CGRectZero];
    CGRect frame = _backgroundView.frame;
    frame.origin.y = self.tabBar.frame.size.height - frame.size.height;
    _backgroundView.frame = frame;
}

- (void)setViewControllers:(NSArray*)viewControllers animated:(BOOL)animated {
	[super setViewControllers:viewControllers animated:animated];

    if ([viewControllers count] == 0) {
        return; 
    }

    if (_selectionView != nil) {
        CGFloat width = self.tabBar.frame.size.width / viewControllers.count;
        CGRect frame = _selectionView.frame;
        frame.size.width = width;
        frame.origin.x = self.selectedIndex * width;
        _selectionView.frame = frame;
        
        [self.tabBar insertSubview:_selectionView aboveSubview:_backgroundView];
    }
    [self.tabBar drawRect:CGRectZero];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSUInteger currentIndex = self.selectedIndex;
    
    [super setSelectedIndex:selectedIndex];
    
    if (_buttons.count > selectedIndex && _buttons.count > currentIndex) {
        UIButton *currentBtn = [_buttons objectAtIndex:currentIndex];
        UIButton *selectBtn  = [_buttons objectAtIndex:selectedIndex];
        selectBtn.userInteractionEnabled = NO;
        currentBtn.userInteractionEnabled = YES;
        
        currentBtn.selected = NO;
        selectBtn.selected = YES;
        
        [self animateSelectionToItemAtIndex:selectedIndex];
    }
    
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)] && selectedIndex < [_buttons count]) {
        [self.delegate tabBarController:self didSelectViewController:self.viewControllers[selectedIndex]];
    }
}

- (void)animateSelectionToItemAtIndex:(NSUInteger)itemIndex; {
	CGRect frame = _selectionView.frame;
	
	frame.origin.x = self.selectedIndex * frame.size.width;
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGRectIsEmpty(_selectionView.frame) ? 0 : TAB_SELECTED_ANIMATION_DURATION)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _selectionView.frame = frame;
    [UIView commitAnimations];
}

- (void)setButton:(UIButton *)btn atIndex:(NSInteger)index {
    NSParameterAssert(btn != nil);
    
    if ([_buttons count] > index) {
        [_buttons removeObjectAtIndex:index];
    }
    [_buttons insertObject:btn atIndex:index];
    
    CGFloat width = self.tabBar.frame.size.width / [self.viewControllers count];
    
    btn.frame = CGRectMake(index * width, 0, width, self.tabBar.frame.size.height);
   
    [self.tabBar addSubview:btn];
    btn.tag = index + ITEM_TAG_OFFSET;
    [btn addTarget:self action:@selector(handelClickEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handelClickEvent:(UIButton *)btn {
    NSUInteger selectedIndex = btn.tag - ITEM_TAG_OFFSET;
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        BOOL shouldSelect = [self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[selectedIndex]];
        if (!shouldSelect) {
            return;
        }
    }
    self.selectedIndex = selectedIndex;
}

@end
