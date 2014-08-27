//
//  BaseErrorView.m
//  Pocket91
//
//  Created by Liu Jinyong on 13-8-30.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

#import "BaseErrorView.h"

@implementation BaseErrorView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (IBAction)cancelClick:(id)sender {
    [self removeFromSuperview];
}

@end
