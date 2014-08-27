//
//  BDTabBarController.h
//  BDKit
//
//  Created by Liu Jinyong on 13-8-21.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDTabBarController : UITabBarController

- (void)setButton:(UIControl *)btn atIndex:(NSInteger)index;

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIImageView *selectionView;

@end
