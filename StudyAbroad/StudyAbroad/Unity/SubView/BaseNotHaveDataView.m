//
//  BaseNotHaveOrderView.m
//  DianJinApp
//
//  Created by tqnd on 14-6-29.
//  Copyright (c) 2014年 BoDong Baidu. All rights reserved.
//

#import "BaseNotHaveDataView.h"

@implementation BaseNotHaveDataView

- (void)reloadView:(NSString *)imageName prompt:(NSString *)prompt {
    [self.iamgeView setImage:[UIImage imageNamed:imageName]];
    self.promptLabel.text  =prompt;
}

- (void)dealloc {
    [_iamgeView release];
    [_promptLabel release];
    [super dealloc];
}
@end
