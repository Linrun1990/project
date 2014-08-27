//
//  TopMenuBarItem.h
//  MBaoBao
//
//  Created by yi_dq on 10/4/14.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMenuBarItem : UIView

@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic, retain) UIColor *titleColor;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
         titleColor:(UIColor *)titleColor;

@end
