//
//  AppDelegate.h
//  StudyAbroad
//
//  Created by tqnd on 14-8-5.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "UserGuideView.h"
#import "MainViewController.h"
#import "BDTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UserGuideViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UserGuideView *userGuideView;
@property (retain, nonatomic) MainViewController *mainViewController;

@property (retain, nonatomic) BDTabBarController *tabbarController;

@end
