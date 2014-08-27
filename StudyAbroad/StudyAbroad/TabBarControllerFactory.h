//
//  TabBarControllerFactory.h
//  BDKitDemo
//
//  Created by Liu Jinyong on 14-2-24.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDTabBarController.h"

#define BD_TAB_BAR_BACKGROUND_IMAGE             @"Background Image"
#define BD_TAB_BAR_ITEM_TITLE_NORMAL_COLOR      @"Item Title Normal Color"
#define BD_TAB_BAR_ITEM_TITLE_SELECTED_COLOR    @"Item Title Selected Color"
#define BD_TAB_BAR_NEED_SHADOW_IN_IOS7          @"Need Shadow In iOS7"

#define BD_NAVIGATION_BAR_IMAGE                 @"Navigation Bar Image"
#define BD_NAVIGATION_BAR_TINT_COLOR            @"Navigation Bar Tint Color"
#define BD_NAVIGATION_BAR_TITLE_FONT_SIZE       @"Navigation Bar Title Font Size"
#define BD_NAVIGATION_BAR_TITLE_COLOR           @"Navigation Bar Title Color"

#define BD_TAB_BAR_ITEM                 @"Items"
#define BD_TAB_BAR_ITEM_TITLE           @"Title"
#define BD_TAB_BAR_ITEM_NORMAL_IMAGE    @"Normal Image"
#define BD_TAB_BAR_ITEM_SELECTED_IMAGE  @"Selected Image"
#define BD_TAB_BAR_ITEM_VIEW_CONTROLLER @"View Controller"
#define BD_TAB_BAR_ITEM_NEED_NAVIGATION @"Need Navigation Wrapper"


@interface TabBarControllerFactory : NSObject

+ (BDTabBarController *)tabBarControllerWithPlistName:(NSString *)plistName;

+ (NSArray *)viewControllersWithComfig:(NSDictionary *)configInfo;

@end
