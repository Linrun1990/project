//
//  SchoolListViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SchoolListViewController.h"
#import "TopMenuBarController.h"
#import "SchoolListSubViewController.h"
#import "CustomTabBar.h"

@interface SchoolListViewController ()

@property (nonatomic, retain) NSNumber *countryId;
@property (nonatomic, retain) TopMenuBarController *topMenuBarController;

@end

@implementation SchoolListViewController

- (id)initWithCountryId:(NSNumber *)countryId {
    if (self = [super init]) {
        self.countryId = countryId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cuntry;
    [self buildTopMenuBarController];
}

- (void)dealloc {
    RELEASE_SAFELY(_topMenuBarController);
    [super dealloc];
}

- (void)buildTopMenuBarController {
    NSArray *titles = [NSArray arrayWithObjects:@"大学", @"高中", nil];
    SchoolListSubViewController *universerty = [[[SchoolListSubViewController alloc] initWithSchoolType:1 countryId:self.countryId] autorelease];
    universerty.contry = self.cuntry;
    SchoolListSubViewController *highSchool = [[[SchoolListSubViewController alloc] initWithSchoolType:2 countryId:self.countryId] autorelease];
    highSchool.contry = self.cuntry;
    NSArray *viewControllers = [NSArray arrayWithObjects:universerty, highSchool, nil];
    self.topMenuBarController = [[[TopMenuBarController alloc] initWithItemTitles:titles viewControllers:viewControllers] autorelease];
    //    self.balanceTopMenuBarController.delegate = self;
    self.topMenuBarController.view.frame = CGRectMake(10, 10, self.view.width - 20, self.view.height - 20);
    self.topMenuBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIView *menuBarBackgroundView = [self buildMenuBarBackgroundView];
    self.topMenuBarController.menuBar.backgroundView = menuBarBackgroundView;
    UIView *menuIndicatorView = [self buildMenuBarIndicatorView];
    self.topMenuBarController.menuBar.indicatorView = menuIndicatorView;
    self.topMenuBarController.menuBar.itemNormalColor = [UIColor blackColor];
    self.topMenuBarController.menuBar.itemSelectedColor = [UIColor blackColor];
    [self.view addSubview:self.topMenuBarController.view];
    [self addChildViewController:self.topMenuBarController];
}

- (UIView *)buildMenuBarBackgroundView {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 35.0)] autorelease];
    view.backgroundColor = RGB(231.0, 231.0, 231.0);
    [view setCornerRadius:5.0];
    return view;
}

- (UIView *)buildMenuBarIndicatorView {
    UIView *view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor clearColor];
    UIView *indicatorView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 35)] autorelease];
    indicatorView.backgroundColor = RGB(133, 133, 133);
    [indicatorView setCornerRadius:5.0];
    [view addSubview:indicatorView];
    return view;
    return  nil;
}


@end
