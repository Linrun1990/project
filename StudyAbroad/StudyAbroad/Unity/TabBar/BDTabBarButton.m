//
//  BDTabBarButton.m
//  BDKit
//
//  Created by Liu Jinyong on 13-8-21.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import "BDTabBarButton.h"

#define DEFAULT_TITLE_FONT_SIZE 9

#define DEFAULT_IMAGE_OFFSET 12
#define DEFAULT_TITLE_OFFSET 37

@implementation BDTabBarButton

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		self.titleFont = [UIFont systemFontOfSize:DEFAULT_TITLE_FONT_SIZE];
        self.imageOffset = DEFAULT_IMAGE_OFFSET;
        self.titleOffset = DEFAULT_TITLE_OFFSET;
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_normalImage release];
    [_selectedBGImage release];
    [_selectedImage release];
    [_title release];
    [_selectTitleColor release];
    [_titleFont release];
    [_badgeImage release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	if (self.selected){
        [self drawSelectedUI:rect];
	}else {
        [self drawNormalUI:rect];
    }

    if (_badgeImage) {
        CGSize size = _badgeImage.size;
        [_badgeImage drawInRect:CGRectMake(rect.size.width - size.width - 5, 5, size.width, size.height)];
    }
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	[self setNeedsDisplay];
}

- (void)drawSelectedUI:(CGRect)rect {
    [_selectedBGImage drawInRect:rect];
    CGRect imageRect = CGRectMake((self.bounds.size.width - _selectedImage.size.width) / 2,
                                  _imageOffset,
                                  _selectedImage.size.width ,_selectedImage.size.height);
    [_selectedImage drawInRect:imageRect];
    
    [_selectTitleColor set];
    CGRect titleRect = CGRectMake(0, _titleOffset, rect.size.width, self.titleFont.lineHeight);
    
    [_title drawInRect:titleRect withFont:self.titleFont lineBreakMode:UILineBreakModeClip
             alignment:UITextAlignmentCenter];
}

- (void)drawNormalUI:(CGRect)rect {
    CGRect imageRect = CGRectMake((self.bounds.size.width - _normalImage.size.width) / 2,
                                  _imageOffset,
                                  _normalImage.size.width ,_normalImage.size.height);
    [_normalImage drawInRect:imageRect];
    
    [_titleColor set];
    CGRect titleRect = CGRectMake(0, _titleOffset, rect.size.width, self.titleFont.lineHeight);
    
    [_title drawInRect:titleRect withFont:self.titleFont lineBreakMode:UILineBreakModeClip
             alignment:UITextAlignmentCenter];
}

@end

