//
//  SchoolListSubTableViewCell.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SchoolListSubTableViewCell.h"
#import "DJStarRatingControl.h"

@interface SchoolListSubTableViewCell ()

@property (nonatomic, retain) DJStarRatingControl *starRatingController;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation SchoolListSubTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self buildStarRatingController];
}

- (void)buildStarRatingController {
    _starRatingController = [[DJStarRatingControl alloc] initWithFrame:CGRectMake(83, 72, 125, 16) andStars:5 isFractional:YES defaultStar:@"big_star_normal.png" highlightedStar:@"big_star_selected.png"];
    _starRatingController.enabled = NO;
    [self addSubview:_starRatingController];
}

- (void)reloadViewWithDictionary:(NSDictionary *)info {
    [self.iconImageView setImageWithURL:[NSURL URLWithString:info[@"co_picurl"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    self.titleLabel.text = info[@"co_name"];
    self.commentLabel.text  =info[@"co_describe"];
}

- (void)dealloc {
    [_iconImageView release];
    [_titleLabel release];
    [_commentLabel release];
    [super dealloc];
}
@end
