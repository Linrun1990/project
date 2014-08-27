//
//  BaseEmptyView.m
//  Pocket91
//
//  Created by Liu Jinyong on 13-9-26.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

#import "BaseEmptyDataView.h"

@interface BaseEmptyDataView () {
    IBOutlet UILabel *_messageLabel;
    IBOutlet UIView *_topSeparator;
    IBOutlet UIView *_bottomSeparator;
}

@end

@implementation BaseEmptyDataView

- (void)dealloc {
    RELEASE_SAFELY(_topSeparator);
    RELEASE_SAFELY(_bottomSeparator);
    RELEASE_SAFELY(_icon);
    RELEASE_SAFELY(_messageLabel);
    [super dealloc];
}

- (void)setTitle:(NSString *)title {
    _messageLabel.text = title;
    CGSize size = [title sizeWithFont:_messageLabel.font constrainedToSize:CGSizeMake(_messageLabel.width, _messageLabel.height) lineBreakMode:UILineBreakModeWordWrap];
    _topSeparator.width = size.width;
    _bottomSeparator.width = size.width;
    _topSeparator.left = (self.width - size.width)/2;
    _bottomSeparator.left = (self.width - size.width)/2;
}

@end
