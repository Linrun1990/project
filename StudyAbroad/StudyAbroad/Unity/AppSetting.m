//
//  AppSetting.m
//  InstalledNecessary
//
//  Created by Lin Feihong on 13-10-28.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

#import "AppSetting.h"

#define IS_FIRST_LAUNCH   @"isFirstLaunch"

@implementation AppSetting

SYNTHESIZE_SINGLETON_FOR_CLASS(AppSetting)

- (id)init {
    if (self = [super init]) {
        NSDictionary *defaultSetting = @{IS_FIRST_LAUNCH      :@YES,
                                         };
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSetting];
    }
    return self;
}

-(void)setIsFirstLaunch:(BOOL)isFirstLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:isFirstLaunch forKey:IS_FIRST_LAUNCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isFirstLaunch{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:IS_FIRST_LAUNCH] boolValue];
}

@end
