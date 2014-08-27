//
//  AboutMineTableViewCell.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "AboutMineTableViewCell.h"

@interface AboutMineTableViewCell ()

@property (retain, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation AboutMineTableViewCell

- (void)reloadImage:(NSString *)image {
    [self.iconImage setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"default_icon"]];
}

- (void)dealloc {
    [_iconImage release];
    [super dealloc];
}
@end
