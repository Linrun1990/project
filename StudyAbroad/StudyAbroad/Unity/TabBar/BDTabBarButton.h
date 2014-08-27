//
//  BDTabBarButton.h
//  BDKit
//
//  Created by Liu Jinyong on 13-8-21.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDTabBarButton : UIControl

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *selectedBGImage;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIColor *selectTitleColor;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIImage *badgeImage;

@property (nonatomic, assign) float titleOffset;    // default is 12
@property (nonatomic, assign) float imageOffset;    // default is 37

@end