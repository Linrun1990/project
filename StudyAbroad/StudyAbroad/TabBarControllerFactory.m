//
//  TabBarControllerFactory.m
//  BDKitDemo
//
//  Created by Liu Jinyong on 14-2-24.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import "TabBarControllerFactory.h"
#import "CGRect+BDAdditions.h"
#import "BDTabBarButton.h"

@implementation TabBarControllerFactory
//test push
+ (BDTabBarController *)tabBarControllerWithPlistName:(NSString *)plistName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *configInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    BDTabBarController *tabbarController = [self initTabBarControllerWithConfig:configInfo];
    tabbarController.viewControllers = [self viewControllersWithComfig:configInfo];
    [self configItemsWithConfig:configInfo controller:tabbarController];
    
    tabbarController.selectedIndex = 0;
    
    if (IOS7_OR_LATER) {
        if (![configInfo[BD_TAB_BAR_NEED_SHADOW_IN_IOS7] boolValue]) {
            [tabbarController.tabBar setShadowImage:[[[UIImage alloc] init] autorelease]];
            [tabbarController.tabBar setBackgroundImage:[[[UIImage alloc] init] autorelease]];
        }
    }
    
    return tabbarController;
}

+ (BDTabBarController *)initTabBarControllerWithConfig:(NSDictionary *)configInfo {
    BDTabBarController *tabbarController = [[[BDTabBarController alloc] init] autorelease];
    
//    UIImage *backgroundImage = [UIImage imageNamed:configInfo[BD_TAB_BAR_BACKGROUND_IMAGE]];
    UIImageView *backgroundView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    //backgroundView.image = backgroundImage;
    backgroundView.backgroundColor = RGB(0, 172, 249);
    tabbarController.backgroundView = backgroundView;
    
    return tabbarController;
}

+ (UINavigationController *)navigationWithContentViewController:(UIViewController *)viewController config:(NSDictionary *)configInfo {
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    if (configInfo[BD_NAVIGATION_BAR_IMAGE]) {
        UIImage *stretchedImage = [[UIImage imageNamed:configInfo[BD_NAVIGATION_BAR_IMAGE]] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        [navigationController.navigationBar setBackgroundImage:stretchedImage forBarMetrics:UIBarMetricsDefault];
        UIFont *font = [UIFont boldSystemFontOfSize:[configInfo[BD_NAVIGATION_BAR_TITLE_FONT_SIZE] intValue]];
        UIColor *titleColor = [UIColor colorWithString:configInfo[BD_NAVIGATION_BAR_TITLE_COLOR]];
        NSDictionary *textAttributes = @{UITextAttributeFont        : font,
                                         UITextAttributeTextColor   : titleColor};
        navigationController.navigationBar.titleTextAttributes = textAttributes;
    }
    NSString *color = configInfo[BD_NAVIGATION_BAR_TINT_COLOR];    
    if (IOS7_OR_LATER) {
            navigationController.navigationBar.barTintColor = [UIColor colorWithString:color];
        }else {
            navigationController.navigationBar.tintColor = [UIColor colorWithString:color];
        }
    return navigationController;
}

+ (NSArray *)viewControllersWithComfig:(NSDictionary *)configInfo {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i=0; i<[configInfo[BD_TAB_BAR_ITEM] count]; i++) {
        NSDictionary *itemInfo = configInfo[BD_TAB_BAR_ITEM][i];
        id viewController = nil;
        id contentViewController = nil;
        NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
        if (i == 3) {
            if (userId != nil) {
                contentViewController = [[[NSClassFromString(@"loginSuccessViewController") alloc] init] autorelease];
            }else {
                contentViewController = [[[NSClassFromString(itemInfo[BD_TAB_BAR_ITEM_VIEW_CONTROLLER]) alloc] init] autorelease];
            }
        }else {
          contentViewController = [[[NSClassFromString(itemInfo[BD_TAB_BAR_ITEM_VIEW_CONTROLLER]) alloc] init] autorelease];
        }
        if (itemInfo[BD_TAB_BAR_ITEM_NEED_NAVIGATION]) {
            viewController = [self navigationWithContentViewController:contentViewController config:configInfo];
        }else {
            viewController = contentViewController;
        }
        [viewControllers addObject:viewController];
    }
    return viewControllers;
}

+ (void)configItemsWithConfig:(NSDictionary *)configInfo
                   controller:(BDTabBarController *)tabbarController {
    for (int i=0; i<[configInfo[BD_TAB_BAR_ITEM] count]; i++) {
        NSDictionary *itemInfo = configInfo[BD_TAB_BAR_ITEM][i];
        BDTabBarButton * btn = [[[BDTabBarButton alloc] initWithFrame:CGRectZero] autorelease];
        btn.title = itemInfo[BD_TAB_BAR_ITEM_TITLE];
        btn.titleColor = [UIColor colorWithString:configInfo[BD_TAB_BAR_ITEM_TITLE_NORMAL_COLOR]];
        btn.titleFont = [UIFont systemFontOfSize:12.0];
        btn.imageOffset = 4.0;
        btn.titleOffset = 35.0;
        btn.selectTitleColor = [UIColor colorWithString:configInfo[BD_TAB_BAR_ITEM_TITLE_SELECTED_COLOR]];
        btn.normalImage = [UIImage imageNamed:itemInfo[BD_TAB_BAR_ITEM_NORMAL_IMAGE]];
        btn.selectedImage = [UIImage imageNamed:itemInfo[BD_TAB_BAR_ITEM_SELECTED_IMAGE]];
        [tabbarController setButton:btn atIndex:i];
    }
}

@end
