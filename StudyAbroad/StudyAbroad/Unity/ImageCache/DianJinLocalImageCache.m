//
//  LocalImageCache.m
//  91Market
//
//  Created by lory qing on 3/22/12.
//  Copyright (c) 2013年 BoDong NetDragon. All rights reserved.
//

#import "DianJinLocalImageCache.h"

@interface DianJinLocalImageCache()

- (void)clearMemory;

@end

@implementation DianJinLocalImageCache

#pragma mark - init

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        #ifdef __IPHONE_4_0
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clearMemory)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
        #endif
        
        _imageCache = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    RELEASE_SAFELY(_imageCache);
    [super dealloc];
}

#pragma mark - Public func

+ (DianJinLocalImageCache *)sharedInstance {
    static DianJinLocalImageCache *kDJLocalImageCache = nil;
    if (nil == kDJLocalImageCache) {
        kDJLocalImageCache = [[DianJinLocalImageCache alloc] init];
    }
    return kDJLocalImageCache;
}

- (UIImage *)imageCacheWithName:(NSString *)imageName {
     NSString *imgFilePath = [NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] bundlePath]];
    return [self imageForPath:imgFilePath imageName:imageName];
}

- (UIImage *)imageForPath:(NSString *)imagePath imageName:(NSString *)imageName {
    UIImage *img = [self.imageCache objectForKey:imageName];
    if (nil != img) {
        return img;
    }
    
    img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",imagePath,imageName]];
    if (nil != img) {
        [self.imageCache setObject:img forKey:imageName];
    }
    return img;
}

- (void)clearCache {
    [self.imageCache removeAllObjects];
}

#pragma mark - Private func

- (void)clearMemory {
    [self clearCache];
}

@end
