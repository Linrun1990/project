//
//  TopMenuBar.m
//  Pocket91
//
//  Created by yi_dq on 28/8/13.
//  Copyright (c) 2013 Bodong Baidu. All rights reserved.
//


#import "TopMenuBar.h"

#define BD_CUSTOMSEGMENT_TAG_OFFSET 1000
#define SHOW_ITEM_MAX_COUNT 5
#define DEFAULT_SHOW_ITEM_INDEX 0
#define INDICATOR_VIEW_HEIGHT 20.0f
#define INDICATOR_VIEW_DEFAULT 72.0f
#define ITEM_COLOR_NORMAL RGBA(255.0, 255.0, 255.0, 1);
#define ITEM_COLOR_SELECT RGBA(255.0, 255.0, 255.0, 1);

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define BDTextAlignmentCenter NSTextAlignmentCenter
#else
#define BDTextAlignmentCenter UITextAlignmentCenter
#endif

@interface TopMenuBar () {
    UIScrollView *_scrollView;
    NSUInteger _itemCount;
    CGFloat _itemWidth;
    NSMutableDictionary *_items;
    float _oldX;
}

@end

@implementation TopMenuBar

@synthesize itemNormalColor = _itemNormalColor;
@synthesize itemSelectedColor = _itemSelectedColor;

#pragma mark - view life

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        _itemWidth = 0.0f;
        _itemCount = 0;
        _oldX = 0.0;
        _selectedItemIndex = 0;
        self.itemNormalColor = ITEM_COLOR_NORMAL;
        self.itemSelectedColor = ITEM_COLOR_SELECT;
        _items = [[NSMutableDictionary alloc] init];
        [self setupScrollView];
        [self setupTapGestureRecognizer];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)setupScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_scrollView];
}

- (void)setupItemWithIndex:(int)index {
    NSString *title =  [self.dataSource menuBar:self titleAtItemIndex:index];
    UIColor *itemColor = _itemNormalColor;
    if(index == _selectedItemIndex){
        itemColor = _itemSelectedColor;
    }
    TopMenuBarItem *item = [[TopMenuBarItem alloc] initWithFrame:CGRectMake(index * _itemWidth, 0, _itemWidth, self.frame.size.height)
                                                           title:title
                                                      titleColor:itemColor];
    item.tag = index + BD_CUSTOMSEGMENT_TAG_OFFSET;
    [_items setObject:item forKey:title];
    [_scrollView addSubview:item];
    [item release];
}

- (void)setupTapGestureRecognizer {
    UITapGestureRecognizer *tapGesReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesRecoDetected:)];
    [_scrollView addGestureRecognizer:tapGesReco];
    [tapGesReco release];
}

- (void)dealloc {
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_indicatorView);
    RELEASE_SAFELY(_items);
    [super dealloc];
}

#pragma mark - overwirte setMethod

- (void)setItemNormalColor:(UIColor *)itemColorNormal {
    UIColor *newColor = [itemColorNormal retain];
    if(_itemNormalColor != nil) {
        RELEASE_SAFELY(_itemNormalColor);
    }
    _itemNormalColor = newColor;
    [_itemNormalColor retain];
    [newColor release];
    [self resetItemColor];
}

- (UIColor *)itemNormalColor {
    return _itemNormalColor;
}

- (void)setItemSelectedColor:(UIColor *)itemColorSelected {
    UIColor *newColor = [itemColorSelected retain];
    if(_itemSelectedColor != nil) {
        RELEASE_SAFELY(_itemSelectedColor);
    }
    _itemSelectedColor = newColor;
    [_itemSelectedColor retain];
    [newColor release];
    [self resetItemColor];
}

- (UIColor *)itemSelectedColor {
    return _itemSelectedColor;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    UIView *barBackgroundView = [backgroundView retain];
    if(_backgroundView != nil) {
        [_backgroundView removeFromSuperview];
        RELEASE_SAFELY(_backgroundView);
    }
    _backgroundView = barBackgroundView;
    [_backgroundView retain];
    [barBackgroundView release];
    [self addSubview:_backgroundView];
    [self sendSubviewToBack:_backgroundView];
}

- (void)setIndicatorView:(UIView *)indicatorView {
    UIView *newIndicatorView = [indicatorView retain];
    if(_indicatorView != nil) {
        [_indicatorView removeFromSuperview];
        RELEASE_SAFELY(_indicatorView);
    }
    _indicatorView = newIndicatorView;
    [_indicatorView retain];
    [newIndicatorView release];
    _indicatorView.frame = CGRectMake(_selectedItemIndex * _itemWidth, 0, _itemWidth, self.frame.size.height);
    [_scrollView addSubview:_indicatorView];
    [_scrollView sendSubviewToBack:_indicatorView];
}

#pragma mark - public method

- (void)reloadData {
    _itemCount = [self.dataSource numberOfItemsInMenuBar:self];
    _itemWidth = _itemCount < SHOW_ITEM_MAX_COUNT ? self.width /_itemCount : self.bounds.size.width / SHOW_ITEM_MAX_COUNT;
    [self reloadItemLabel];
    _scrollView.contentSize = CGSizeMake([self calculateBarLength], _scrollView.frame.size.height);
    _indicatorView.frame = CGRectMake(_selectedItemIndex * _itemWidth, 0,
                                                _itemWidth, self.frame.size.height);

}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex {
    [self resetScrollViewFrameAtIndex:selectedItemIndex];
    [self resetItemColorAtIndex:selectedItemIndex];
    _selectedItemIndex = selectedItemIndex;
}

#pragma mark - private method

- (void)reloadItemLabel {
    NSArray *oldItemKeys = [_items allKeys];
    for (int i = 0; i < [oldItemKeys count]; i++)
    {
        UILabel *oldItem = [_items objectForKey:[oldItemKeys objectAtIndex:i]];
        [oldItem removeFromSuperview];
    }
    [_items removeAllObjects];
    for (int i = 0; i < _itemCount; i++)
    {
        NSString *title =  [self.dataSource menuBar:self titleAtItemIndex:i];
        UILabel *itemLabel = [_items objectForKey:title];
        if(itemLabel == nil){
            [self setupItemWithIndex:i];
        }
    }
}

- (void)resetScrollViewFrameAtIndex:(NSUInteger)itemIndex {
    CGFloat desiredX = [self getCenterOfItemAtIndex:itemIndex] - (_scrollView.bounds.size.width / 2);
    if (desiredX < 0){
        desiredX = 0;
    }
    if (desiredX > [self calculateBarLength] - _scrollView.bounds.size.width){
        desiredX = [self calculateBarLength] - _scrollView.bounds.size.width;
    }
    [_scrollView setContentOffset:CGPointMake(desiredX, 0) animated:YES];
    _oldX = desiredX;
}

- (void)animationScrollViewFrameAtIndex:(CGFloat)offsetRate animated:(BOOL)animated {
    float currentX = offsetRate * [self calculateBarLength];
    [_scrollView setContentOffset:CGPointMake(currentX, 0) animated:animated];
}

- (void)resetItemColorAtIndex:(NSInteger)index {
    TopMenuBarItem *currentSelectItem = (TopMenuBarItem *)[self viewWithTag:_selectedItemIndex + BD_CUSTOMSEGMENT_TAG_OFFSET];
    TopMenuBarItem *targetSelectItem = (TopMenuBarItem *)[self viewWithTag:index + BD_CUSTOMSEGMENT_TAG_OFFSET];
    currentSelectItem.titleColor = _itemNormalColor;
    targetSelectItem.titleColor = _itemSelectedColor;
}

- (void)resetItemColor {
    NSArray *itemKeys = [_items allKeys];
    for(NSString *itemTitle in itemKeys){
        TopMenuBarItem *item = [_items objectForKey:itemTitle];
        item.titleColor = (item.tag == _selectedItemIndex + BD_CUSTOMSEGMENT_TAG_OFFSET) ? _itemSelectedColor : _itemNormalColor;
    }
}

- (void)animationOfIndicatorView:(CGFloat)offsetRate {
    float currentX = offsetRate * [self calculateBarLength];
    _indicatorView.frame = CGRectMake(currentX, 0, _itemWidth, self.frame.size.height);
}

- (TopMenuBarItem *)getItemWithTitle:(NSString *)title {
    return [_items objectForKey:title];
}

- (CGFloat)getCenterOfItemAtIndex:(NSInteger)index {
    return index*_itemWidth + (_itemWidth/2);
}

- (CGFloat)calculateBarLength {
    return _itemCount*_itemWidth;
}

- (void)tapGesRecoDetected:(UITapGestureRecognizer *)tapGesture {
    CGPoint pos = [tapGesture locationInView:_scrollView];
    NSUInteger activeIndex = [self selectedIndexFromTouchPoint:pos];
    if (activeIndex != NSNotFound)
    {
        [self.delegate menuBar:self didSelectItemAtIndex:activeIndex];
        [self setSelectedItemIndex:activeIndex];
    }
}

- (NSUInteger)selectedIndexFromTouchPoint:(CGPoint)point {
    NSUInteger selectedIndex = NSNotFound;
    CGFloat currentX = 0;
    for (int i = 0; i < _itemCount; i++)
    {
        float itemWidth = _itemWidth;
        if (point.x >= currentX && point.x <= (currentX + itemWidth))
        {
            selectedIndex = i;
            break;
        }
        currentX += itemWidth;
    }
    return selectedIndex;
}

@end

