//
//  UISearchBar+Extension.m
//  InstalledNecessary
//
//  Created by Lin Feihong on 13-10-25.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

@implementation UISearchBar (Extension)

- (void)setupTextField:(UIImage *)leftViewImage backgroundImage:(UIImage *)backgroundImage placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor textColor:(UIColor *)textColor {
    NSArray *subviewContainer = IOS7_OR_LATER ? ((UIView *)self.subviews[0]).subviews : self.subviews;
    for (id subView in subviewContainer) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)subView;
            NSString *autoPlaceholder = nil;
            CGRect leftViewFrame = CGRectZero;
            if (IOS7_OR_LATER) {
                if (placeholder.length <= 24) {
                    NSMutableString *iOS7AutoPlaceholder = [NSMutableString stringWithFormat:@"%@", placeholder];
                    for (int i = 0; i <= 24 - placeholder.length; i++) {
                        [iOS7AutoPlaceholder appendString:@" "];
                    }
                    autoPlaceholder = iOS7AutoPlaceholder;
                }
                [self setSearchFieldBackgroundImage:backgroundImage forState:UIControlStateNormal];
                [self setSearchFieldBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
                leftViewFrame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
            }else {
                autoPlaceholder = [NSString stringWithFormat:@"%@", placeholder];
                [textField setBackground:backgroundImage];
                leftViewFrame = CGRectMake(0.0f, 0.0f, 18.0f, 18.0f);
            }
            UIImageView *leftView = [[[UIImageView alloc] initWithImage:leftViewImage] autorelease];
            leftView.frame = leftViewFrame;
            [textField setLeftView:leftView];
            [textField setFont:[UIFont boldSystemFontOfSize:13.0f]];
            [textField setTextColor:textColor];
            [textField setKeyboardAppearance:UIKeyboardAppearanceAlert];
            [textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
            self.placeholder = autoPlaceholder;
            break;
        }
    }
}

- (void)setupBackgroundColor:(UIColor *)backgroundColor {
    if (IOS7_OR_LATER) {
        if ([self respondsToSelector:@selector(barTintColor)]) {
            [self setBarTintColor:backgroundColor];
        }
    }else {
        for (id subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subView removeFromSuperview];
                [self setBackgroundColor:backgroundColor];
                break;
            }
        }
    }
}

- (void)setupCancelButtonWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName {
    NSArray *subviewContainer = IOS7_OR_LATER ? ((UIView *)self.subviews[0]).subviews : self.subviews;
    NSString *autoTitle = IOS7_OR_LATER ? [NSString stringWithFormat:@" %@ ", title] : title;
    for (id subView in subviewContainer) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton *)subView;
            [cancelButton setTitle:autoTitle forState:UIControlStateNormal];
            [cancelButton setTitle:autoTitle forState:UIControlStateHighlighted];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [cancelButton setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
            CGRect rect = cancelButton.frame;
            rect.origin.x = 268.0f;
            rect.origin.y = 6.5f;
            cancelButton.frame = rect;
            break;
        }
    }
}

@end












