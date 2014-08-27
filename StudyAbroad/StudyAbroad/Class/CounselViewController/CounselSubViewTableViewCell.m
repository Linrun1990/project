//
//  CounselSubViewTableViewCell.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CounselSubViewTableViewCell.h"

@interface CounselSubViewTableViewCell ()

@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *descripionLabel;
@property (retain, nonatomic) IBOutlet UILabel *isFirstLabel;

@end

@implementation CounselSubViewTableViewCell

- (void)reloadWithInfo:(NSDictionary *)info {
    [self.iconImageView setCornerRadius:7.0];
    self.titleLabel.text = info[@"news_title"];
    self.descripionLabel.text = info[@"news_content"];
    [self.iconImageView setImageWithURL:[NSURL URLWithString:info[@"news_smallpicurl"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    [self.isFirstLabel setCornerRadius:3.0f];
    BOOL isHide = [info[@"news_first"] intValue] == 1 ? NO : YES;
    self.isFirstLabel.hidden = isHide;
}

- (void)dealloc {
    [_iconImageView release];
    [_titleLabel release];
    [_descripionLabel release];
    [_isFirstLabel release];
    [super dealloc];
}
@end
