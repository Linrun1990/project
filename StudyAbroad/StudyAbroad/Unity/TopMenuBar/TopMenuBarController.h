//
//  ViewController.h
//  Pocket91
//
//  Created by yi_dq on 28/8/13.
//  Copyright (c) 2013 Bodong Baidu. All rights reserved.
//  2013-09-03 review


#import "TopMenuBar.h"
#import "TopMenuBarItem.h"

@protocol TopMenuBarControllerDelegate;

@interface TopMenuBarController : UIViewController<TopMenuBarDataSource, TopMenuBarDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) NSArray *itemTitles;
@property (nonatomic, retain) UIScrollView *contentScrollView;
@property (nonatomic, readonly) TopMenuBar *menuBar; 
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) id<TopMenuBarControllerDelegate> delegate;

- (id)initWithItemTitles:(NSArray *)itemTitles viewControllers:(NSArray *)viewControllers;
- (void)reloadWithItemTitles:(NSArray *)itemTitles viewControllers:(NSArray *)viewControllers;

@end

@protocol TopMenuBarControllerDelegate <NSObject>
@optional

- (void)topMenuBarController:(TopMenuBarController *)
Controller didSelectViewController:(UIViewController *)viewController didSelectItemTitle:(NSString *)itemTitle;

@end

@interface UIViewController (TopMenuBarControllerItem)

@property(nonatomic, assign, readonly) TopMenuBarController *topMenuBarController;
@property(nonatomic, assign, readonly) TopMenuBarItem *topMenuBarItem;

@end