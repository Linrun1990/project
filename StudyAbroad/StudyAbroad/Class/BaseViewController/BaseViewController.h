//
//  BaseViewController.h
//  StudyAbroad
//
//  Created by tqnd on 14-8-5.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OVERLAY_ANIMATION_DURATION 0.4

@interface BaseViewController : UIViewController <ASIHTTPRequestDelegate>

- (void)buildRightButton;

//Content View
- (UIView *)showLoadingViewAnimated:(BOOL)animated;
- (void)hideLoadingViewAnimated:(BOOL)animated;

- (UIView *)showErrorViewAnimated:(BOOL)animated;
- (void)hideErrorViewAnimated:(BOOL)animated;
- (void)errorViewButtonDidPress;    //错误页面按钮点击时调用

- (UIView *)showNotHaveDataView:(NSString *)imageName prompt:(NSString *)text animated:(BOOL)animated;
- (void)hideNotHaveDataAnimated:(BOOL)animated;


- (void)showNotHaveDataOnView:(UIView *)view;
- (void)showLoadingViewOnView:(UIView *)view;

- (void)showErrorViewOnView:(UIView *)view;

- (NSDictionary *)parseResponseData:(ASIHTTPRequest *)request;


@end
