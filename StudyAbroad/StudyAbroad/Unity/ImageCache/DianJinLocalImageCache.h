//
//  LocalImageCache.h
//  91Market
//
//  Created by lory qing on 3/22/12.
//  Copyright (c) 2013年 BoDong NetDragon. All rights reserved.
//

@interface DianJinLocalImageCache : NSObject {
     NSMutableDictionary *_imageCache;
}

@property (nonatomic, retain) NSMutableDictionary *imageCache;

+ (DianJinLocalImageCache *)sharedInstance;
- (UIImage *)imageCacheWithName:(NSString *)imageName;
- (UIImage *)imageForPath:(NSString *)imagePath imageName:(NSString *)imageName;
- (void)clearCache;

@end