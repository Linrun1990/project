//
//  ViewController.m
//  Pocket91
//
//  Created by yi_dq on 28/8/13.
//  Copyright (c) 2013 Bodong Baidu. All rights reserved.
//

#import "TopMenuBarController.h"

#define TOP_MENU_BAR_HEIGHT 35.0f
#define WIDTHA_TITEM_INDEX 80.0f
#define DEFAULT_SHOW_VIEW_INDEX 0

@interface TopMenuBarController () {
    TopMenuBar *_menuBar;
}

@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) NSMutableArray *addedTitles;

- (void)setupMenuBar;
- (void)setupContentScrollView;
- (void)setupSubViewAtIndex:(NSInteger)index;
- (void)showContentViewAtIndex:(NSInteger)index;

@end

@implementation TopMenuBarController

#pragma mark - view life

- (id)initWithItemTitles:(NSArray *)itemTitles viewControllers:(NSArray *)viewControllers {
    if (self = [super init]){
        self.itemTitles = itemTitles;
        self.viewControllers = viewControllers;
        self.addedTitles = [NSMutableArray arrayWithCapacity:[self.itemTitles count]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [_menuBar reloadData];
     _contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*[self.itemTitles count], 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBar];
    [self setupContentScrollView];
    [self showContentViewAtIndex:DEFAULT_SHOW_VIEW_INDEX];
}

- (void)setupMenuBar {
    _menuBar = [[TopMenuBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_MENU_BAR_HEIGHT)];
    _menuBar.backgroundColor = [UIColor clearColor];
    _menuBar.delegate = self;
    _menuBar.dataSource = self;
    [self.view addSubview:_menuBar];
}

- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_MENU_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - TOP_MENU_BAR_HEIGHT)];
    _contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _contentScrollView.scrollsToTop = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.delegate = self;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
}

- (void)setupSubViewAtIndex:(NSInteger)index {
    UIViewController *targetController = [self.viewControllers objectAtIndex:index];
    if([targetController isKindOfClass:[UIViewController class]]){
        [self addChildViewController:targetController];
        targetController.view.frame = CGRectMake(self.view.frame.size.width * index, 0, self.view.frame.size.width, _contentScrollView.frame.size.height);
        [_contentScrollView addSubview:targetController.view];
    }
}

- (void)dealloc {
    RELEASE_SAFELY(_contentScrollView);
    RELEASE_SAFELY(_menuBar);
    RELEASE_SAFELY(_selectedViewController);
    RELEASE_SAFELY(_itemTitles);
    RELEASE_SAFELY(_viewControllers);
    [super dealloc];
}

#pragma mark - public method

- (void)reloadWithItemTitles:(NSArray *)itemTitles viewControllers:(NSArray *)viewControllers {
    for(int i=0; i<[itemTitles count]; i++){
        NSString *itemTitle = [itemTitles objectAtIndex:i];
        if([self.addedTitles containsObject:itemTitle]){
            UIViewController *contentController = [viewControllers objectAtIndex:i];
            contentController.view.frame = CGRectMake(self.view.frame.size.width * i, contentController.view.frame.origin.y, self.view.frame.size.width, _contentScrollView.frame.size.height);
        }
    }
    for(int i=0; i<[self.itemTitles count]; i++){
        NSString *oldItemTitle = [self.itemTitles objectAtIndex:i];
        if(![itemTitles containsObject:oldItemTitle] && [self.addedTitles containsObject:oldItemTitle]){
            UIViewController *contentController = [self.viewControllers objectAtIndex:i];
            [contentController.view removeFromSuperview];
            [contentController beginAppearanceTransition:NO animated:NO];
            [contentController removeFromParentViewController];
        }
    }
    self.itemTitles = itemTitles;
    self.viewControllers = viewControllers;
    _contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*[self.itemTitles count], 0);
    [_menuBar reloadData];
    [self.addedTitles removeAllObjects];
    [self showContentViewAtIndex:DEFAULT_SHOW_VIEW_INDEX];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [_menuBar setSelectedItemIndex:selectedIndex];
    [self showContentViewAtIndex:selectedIndex];
}

#pragma mark - UIScrollerDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_menuBar animationOfIndicatorView:scrollView.contentOffset.x / scrollView.contentSize.width];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage = scrollView.contentOffset.x / pageWidth;
    [_menuBar setSelectedItemIndex:currentPage];
    [self showContentViewAtIndex:currentPage];
}

- (void)scrollViewEnableScroll:(BOOL)enable {
    _contentScrollView.scrollEnabled = enable;
}

#pragma mark LightMenuBarDatasource

- (NSUInteger)numberOfItemsInMenuBar:(TopMenuBar *)menuBar {
    return [self.viewControllers count];
}

- (NSString *)menuBar:(TopMenuBar *)menuBar titleAtItemIndex:(NSUInteger)index {
    return [self.itemTitles objectAtIndex:index];
}

#pragma mark LightMenuBarDelegate

- (void)menuBar:(TopMenuBar *)menuBar didSelectItemAtIndex:(NSUInteger)index {
    [self showContentViewAtIndex:index];
}

#pragma mark - private method

- (void)showContentViewAtIndex:(NSInteger)index {
    if(_selectedViewController != nil){
        [_selectedViewController viewWillDisappear:YES];
    }
    UIViewController *targetController = [self.viewControllers objectAtIndex:index];
    if(targetController.parentViewController == nil){
        [self setupSubViewAtIndex:index];
    }else{
        targetController.view.frame = CGRectMake(self.view.frame.size.width * index, targetController.view.frame.origin.y, self.view.frame.size.width, _contentScrollView.frame.size.height);
        [targetController viewWillAppear:YES];
    }
    [self.addedTitles addObject:[self.itemTitles objectAtIndex:index]];
    self.selectedViewController = targetController;
    CGPoint targetPoint = CGPointMake(index * self.view.frame.size.width, 0);
    [_contentScrollView setContentOffset:targetPoint animated:YES];
    _selectedIndex = index;
    DELEGATE_CALLBACK_ARRAY(_delegate, topMenuBarController:didSelectViewController:didSelectItemTitle:, (@[self, targetController, _itemTitles[index]]));
}

@end

@implementation UIViewController (TopMenuBarControllerItem)

- (TopMenuBarController*)topMenuBarController {
    TopMenuBarController *topMenuBarController = nil;
    if([self.parentViewController isKindOfClass:[TopMenuBarController class]]){
        topMenuBarController = (TopMenuBarController*)self.parentViewController;
    }
    else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
            [self.parentViewController.parentViewController isKindOfClass:[TopMenuBarController class]]){
        topMenuBarController = (TopMenuBarController*)[self.parentViewController parentViewController];
    }
    return topMenuBarController;
}

- (TopMenuBarItem *)topMenuBarItem {
    TopMenuBarController *topMenuBarController = self.topMenuBarController;
    int index = [topMenuBarController.viewControllers indexOfObject:self];
    NSString *title = [topMenuBarController.itemTitles objectAtIndex:index];
    return [topMenuBarController.menuBar getItemWithTitle:title];
}

@end
