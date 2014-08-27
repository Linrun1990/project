//
//  CounselViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CounselViewController.h"
#import "TopMenuBarController.h"
#import "MainViewController.h"
#import "CounselSubViewController.h"

@interface CounselViewController ()

@property (nonatomic, retain) TopMenuBarController *topMenuBarController;
@property (nonatomic, retain) ASIFormDataRequest *requestNewsType;


@end

@implementation CounselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self buildRightButton];
    [self requestNewsTypes];
    self.title = @"沃留学";
}

- (void)dealloc {
    RELEASE_SAFELY(_topMenuBarController);
    [super dealloc];
}

- (void)buildTopMenuBarController:(NSArray *)titles ids:(NSArray *)ids {
    if (titles.count == 0) {
        titles = [NSArray arrayWithObjects:@"商品", @"应用", @"信息", @"我的", nil];
    }
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (NSNumber *typeId in ids) {
        CounselSubViewController *subView = [[[CounselSubViewController alloc] initWithNewTypeId:typeId] autorelease];
        [viewControllers addObject:subView];
    }
    self.topMenuBarController = [[[TopMenuBarController alloc] initWithItemTitles:titles viewControllers:viewControllers] autorelease];
    self.topMenuBarController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
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

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *result = [self parseResponseData:request];
    NSArray *newsTypeList = result[@"list"];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *ids = [NSMutableArray array];
    for (NSDictionary *info in newsTypeList) {
        [titles addObject:info[@"nt_name"]];
        [ids addObject:info[@"nt_id"]];
    }
    [self buildTopMenuBarController:titles ids:ids];
}

- (UIView *)buildMenuBarBackgroundView {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35.0)] autorelease];
    view.backgroundColor = RGB(239, 239, 239);
    return view;
}

- (UIView *)buildMenuBarIndicatorView {
    UIView *view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor clearColor];
    UIView *indicatorView = [[[UIView alloc] initWithFrame:CGRectMake(5, 5, 70, 25)] autorelease];
    indicatorView.backgroundColor = RGB(130, 189, 193);
    [indicatorView setCornerRadius:5.0];
    [view addSubview:indicatorView];
    return view;
}

- (void)requestNewsTypes {
    self.requestNewsType = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestNewsType setRequestMethod:HTTP_TYPE];
    [self.requestNewsType setPostValue:@7 forKey:@"act"];
    self.requestNewsType.delegate = self;
    [self.requestNewsType startAsynchronous];
}

@end






