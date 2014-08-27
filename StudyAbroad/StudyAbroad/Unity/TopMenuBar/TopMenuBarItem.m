//
//  TopMenuBarItem.m
//  MBaoBao
//
//  Created by yi_dq on 10/4/14.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import "TopMenuBarItem.h"
#import "JSBadgeView.h"

#define ITEM_LABEL_FONT 15.0f
#define BADGE_VIEW_TAG 2001

@interface TopMenuBarItem () {
    UILabel *_titleLabel;
}

@end

@implementation TopMenuBarItem

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
         titleColor:(UIColor *)titleColor {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:ITEM_LABEL_FONT];
        _titleLabel.textColor = titleColor;
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    JSBadgeView *badgeView = (JSBadgeView *)[self viewWithTag:BADGE_VIEW_TAG];
    if(badgeView == nil){
        badgeView = [[[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentCenter] autorelease];
        badgeView.tag = BADGE_VIEW_TAG;
        badgeView.badgePositionAdjustment = CGPointMake(35, 0);
    }
    if(badgeValue == nil || [badgeValue isEqualToString:@"0"]){
        badgeView.badgeText = @"";
    }else {
        badgeView.badgeText = badgeValue;
    }
    [badgeView setNeedsLayout];
}

- (void)dealloc {
    RELEASE_SAFELY(_titleColor);
    RELEASE_SAFELY(_titleLabel);
    [super dealloc];
}

- (void)setTitleColor:(UIColor *)titleColor {
    UIColor *newColor = [titleColor retain];
    if(_titleColor != nil) {
        RELEASE_SAFELY(_titleColor);
    }
    _titleColor = newColor;
    [_titleColor retain];
    [newColor release];
    _titleLabel.textColor = _titleColor;
}

@end
