//
//  CustomButton.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ContentView" owner:self options:nil];
    self.content.frame = self.bounds;
    [self.backView setCornerRadius:5.0f];
    [self addSubview:self.content];
}

- (void)reloadWithImage:(NSString *)imageName title:(NSString *)title {
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    self.titleLabel.text = title;
}

- (void)dealloc {
    [_content release];
    [_iconImageView release];
    [_titleLabel release];
    [super dealloc];
}
@end
