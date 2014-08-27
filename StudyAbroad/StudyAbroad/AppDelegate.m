//
//  AppDelegate.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-5.
//  Copyright (c) 2014年 tqnd. All rights reserved.

#import "AppDelegate.h"
#import "ConnectManager.h"
#import "AppSetting.h"
#import "TabBarControllerFactory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil] autorelease];
//    self.window.backgroundColor = [UIColor whiteColor];
//    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:self.mainViewController] autorelease];
//    if (IOS7_OR_LATER) {
//        navigationController.navigationBar.barTintColor = RGB(33.0, 145.0, 248.0);
//    }else {
//        navigationController.navigationBar.tintColor = RGB(33.0, 145.0, 248.0);
//    }
//    21 91f8
//    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
//    UIColor *titleColor = [UIColor whiteColor];
//    NSDictionary *textAttributes = @{UITextAttributeFont        : font,
//                                     UITextAttributeTextColor   : titleColor};
//    navigationController.navigationBar.titleTextAttributes = textAttributes;
//    [UINavigationBar appearance];
//    
//    
//    self.window.rootViewController = navigationController;
//    [self.window makeKeyAndVisible];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.tabbarController = [TabBarControllerFactory tabBarControllerWithPlistName:@"TabBarConfig"];
    self.window.rootViewController = self.tabbarController;
    [self.window makeKeyAndVisible];
    
    [self showUserGuideView];
    
   // ConnectManager *manager = [[ConnectManager alloc] init];
   // [manager doActionWithAct:1 params:nil delegate:self];
    
    return YES;
}

- (void)userGuideViewWillShow:(UserGuideView *)userGuideView {
    self.window.rootViewController.view.hidden = YES;
}

- (void)userGuideViewDidHide:(UserGuideView *)userGuideView {
    self.window.rootViewController.view.hidden = NO;
}

- (void)showUserGuideView {
    if ([AppSetting sharedInstance].isFirstLaunch) {
        [AppSetting sharedInstance].isFirstLaunch = NO;
        self.userGuideView = [UserGuideView userGuideView];
        self.userGuideView.delegate = self;
        [self.userGuideView show];
    }
    
}

- (void)dealloc {
    RELEASE_SAFELY(_window);
    RELEASE_SAFELY(_userGuideView);
    RELEASE_SAFELY(_mainViewController);
    RELEASE_SAFELY(_tabbarController);
    [super dealloc];
}

@end
