//
//  FavoriteListTableViewCell.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "FavoriteListTableViewCell.h"

@interface FavoriteListTableViewCell ()

@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FavoriteListTableViewCell

- (void)reloadWithInfo:(NSDictionary *)info {
    [self.icon setImageWithURL:[NSURL URLWithString:info[@"lx_picurl"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    self.nameLabel.text = info[@"lx_name"];
}

- (void)dealloc {
    [_icon release];
    [_nameLabel release];
    [super dealloc];
}
@end
