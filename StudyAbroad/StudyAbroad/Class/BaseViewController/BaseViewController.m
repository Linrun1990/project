//
//  BaseViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-5.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseLoadingView.h"
#import "BaseErrorView.h"
#import "BaseNotHaveDataView.h"

@interface BaseViewController () {
    BaseLoadingView *_loadingView;
    BaseErrorView *_errorView;
    BaseNotHaveDataView *_notHaveDataView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"沃留学";
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if (self.navigationController.viewControllers[0] != self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 18.0, 18.0);
        [button setImage:[UIImage imageNamed:@"but_return.png"] forState:UIControlStateNormal];
        if (IOS7_OR_LATER) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        }
        [button addTarget:self action:@selector(leftButtonClickBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barBtn = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
        self.navigationItem.leftBarButtonItem = barBtn;
    }
}

- (void)leftButtonClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildRightButton {
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 28)] autorelease];
    [button setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)rightButtonClicked {
    NSLog(@"se.viewController = %@==进入地图", self);
}

#pragma mark - Overlay View

- (UIView *)showLoadingViewAnimated:(BOOL)animated {
    if (_loadingView == nil) {
        _loadingView = [[BaseLoadingView loadFromNIB] retain];
    }
    [self showOverlay:_loadingView animated:animated];
    return _loadingView;
}

- (void)hideLoadingViewAnimated:(BOOL)animated {
    [self hideOverlay:_loadingView animated:animated];
}

- (void)showOverlay:(UIView *)view animated:(BOOL)animated {
    view.frame = self.view.bounds;
    view.alpha = 0;
    [self.view addSubview:view];
    double duration = animated ? OVERLAY_ANIMATION_DURATION : 0.0f;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1.0f;
    }];
}

- (void)hideOverlay:(UIView *)view animated:(BOOL)animated {
    double duration = animated ? OVERLAY_ANIMATION_DURATION : 0.0f;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        //必须判断是否finished。如果finished为NO，很可能是因为移除动画还未完成时，已经又显示该view。
        if (finished) {
            [view removeFromSuperview];
        }
    }];
}

- (UIView *)showErrorViewAnimated:(BOOL)animated {
    if (_errorView == nil) {
        _errorView = [[BaseErrorView loadFromNIB] retain];
        [_errorView.button addTarget:self action:@selector(handelButtonPressEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.navigationController.navigationBarHidden) {
        _errorView.top = 20;
    }
    
    [self showOverlay:_errorView animated:animated];
    return _errorView;
}
- (void)hideErrorViewAnimated:(BOOL)animated {
    [self hideOverlay:_errorView animated:animated];
}

- (void)errorViewButtonDidPress {
    
}

- (void)handelButtonPressEvent {
    [self hideErrorViewAnimated:YES];
    [self errorViewButtonDidPress];
}

- (UIView *)showNotHaveDataView:(NSString *)imageName prompt:(NSString *)text animated:(BOOL)animated {
    if (_notHaveDataView == nil) {
        _notHaveDataView = [[BaseNotHaveDataView loadFromNIB] retain];
        [_notHaveDataView reloadView:imageName prompt:text];
    }
    [self showOverlay:_notHaveDataView animated:animated];
    return _notHaveDataView;
}

- (void)hideNotHaveDataAnimated:(BOOL)animated {
    [self hideOverlay:_notHaveDataView animated:animated];
}

- (void)showNotHaveDataOnView:(UIView *)view {
    if (_notHaveDataView == nil) {
        _notHaveDataView = [[BaseNotHaveDataView loadFromNIB] retain];
        [_notHaveDataView reloadView:@"" prompt:@"暂无数据"];
    }
    _notHaveDataView.frame = view.bounds;
    _notHaveDataView.alpha = 0;
    [view addSubview:_notHaveDataView];
    [UIView animateWithDuration:OVERLAY_ANIMATION_DURATION animations:^{
        _notHaveDataView.alpha = 1.0f;
    }];
}

- (void)showLoadingViewOnView:(UIView *)view {
    if (_loadingView == nil) {
        _loadingView = [[BaseLoadingView loadFromNIB] retain];
    }
    _loadingView.frame = view.bounds;
    _loadingView.alpha = 0;
    [view addSubview:_loadingView];
    [UIView animateWithDuration:OVERLAY_ANIMATION_DURATION animations:^{
        _loadingView.alpha = 1.0f;
    }];
    
}

- (void)showErrorViewOnView:(UIView *)view {
    if (_errorView == nil) {
        _errorView = [[BaseErrorView loadFromNIB] retain];
        [_errorView.button addTarget:self action:@selector(handelButtonPressEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    _errorView.frame = view.bounds;
    if (self.navigationController.navigationBarHidden) {
        _errorView.top = 20;
    }
    _errorView.alpha = 0;
    [view addSubview:_errorView];
    [UIView animateWithDuration:OVERLAY_ANIMATION_DURATION animations:^{
        _errorView.alpha = 1.0f;
    }];
    
}

- (NSDictionary *)parseResponseData:(ASIHTTPRequest *)request {
    NSData *data = request.responseData;
    NSString *response = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    response = JSON_EXCLUDE_NULL(response);
    NSDictionary *result = [response objectFromJSONString];
    return result;
}

@end















