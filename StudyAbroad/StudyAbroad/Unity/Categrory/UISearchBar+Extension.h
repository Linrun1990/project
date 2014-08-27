//
//  UISearchBar+Extension.h
//  InstalledNecessary
//
//  Created by Lin Feihong on 13-10-25.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

@interface UISearchBar (Extension)

- (void)setupTextField:(UIImage *)leftViewImage backgroundImage:(UIImage *)backgroundImage placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor textColor:(UIColor *)textColor;
- (void)setupBackgroundColor:(UIColor *)backgroundColor;
- (void)setupCancelButtonWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName;

@end
