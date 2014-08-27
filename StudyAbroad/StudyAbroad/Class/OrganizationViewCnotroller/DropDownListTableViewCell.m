//
//  DropDownListTableViewCell.m
//  DianJinApp
//
//  Created by tqnd on 14-6-29.
//  Copyright (c) 2014年 BoDong Baidu. All rights reserved.
//

#import "DropDownListTableViewCell.h"

@implementation DropDownListTableViewCell

- (void)awakeFromNib {
    UIView *backGroundView = [[[UIView alloc] init] autorelease];
    backGroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backGroundView;
    UIView *selectBackGroundView = [[[UIView alloc] init] autorelease];
    selectBackGroundView.backgroundColor = [UIColor colorWithString:@"#f3f3f3"];
    self.selectedBackgroundView = selectBackGroundView;
}

- (void)dealloc {
    RELEASE_SAFELY(_titleLabel);
    [super dealloc];
}

@end
