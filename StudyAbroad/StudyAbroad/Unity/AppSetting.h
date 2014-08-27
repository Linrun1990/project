//
//  AppSetting.h
//  InstalledNecessary
//
//  Created by Lin Feihong on 13-10-28.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

@interface AppSetting : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AppSetting)

@property (nonatomic, assign) BOOL isFirstLaunch;

@end

