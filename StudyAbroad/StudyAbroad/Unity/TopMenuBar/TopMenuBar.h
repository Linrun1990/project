//
//  TopMenuBar.h
//  Pocket91
//
//  Created by yi_dq on 28/8/13.
//  Copyright (c) 2013 Bodong Baidu. All rights reserved.
//  2013-09-03 review


#import "TopMenuBarItem.h"

@protocol TopMenuBarDataSource;
@protocol TopMenuBarDelegate;

@interface TopMenuBar : UIView

@property (nonatomic, assign) id<TopMenuBarDataSource> dataSource;
@property (nonatomic, assign) id<TopMenuBarDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedItemIndex;
@property (nonatomic, retain) UIColor *itemNormalColor;
@property (nonatomic, retain) UIColor *itemSelectedColor;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *indicatorView;

- (void)reloadData;
- (void)animationOfIndicatorView:(CGFloat)offsetRate;
- (TopMenuBarItem *)getItemWithTitle:(NSString *)title;

@end

@protocol TopMenuBarDataSource

@required

- (NSUInteger)numberOfItemsInMenuBar:(TopMenuBar *)menuBar;
- (NSString *)menuBar:(TopMenuBar *)menuBar titleAtItemIndex:(NSUInteger)index;

@end

@protocol TopMenuBarDelegate

@required

- (void)menuBar:(TopMenuBar *)menuBar didSelectItemAtIndex:(NSUInteger)index;

@end