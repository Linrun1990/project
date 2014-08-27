//
//  OrganizationTableViewCell.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "OrganizationTableViewCell.h"
#import "DJStarRatingControl.h"

@interface OrganizationTableViewCell ()

@property (nonatomic, retain) DJStarRatingControl *starRatingController;

@property (retain, nonatomic) IBOutlet UIImageView *iconImageview;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *describeLabel;



@end

@implementation OrganizationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconImageview setCornerRadius:3.0];
    [self buildStarRatingController];
}

- (void)buildStarRatingController {
    _starRatingController = [[DJStarRatingControl alloc] initWithFrame:CGRectMake(85, 95, 125, 16) andStars:5 isFractional:YES defaultStar:@"big_star_normal.png" highlightedStar:@"big_star_selected.png"];
    _starRatingController.enabled = NO;
    [self addSubview:_starRatingController];
}

- (void)reloadViewWithInfo:(NSDictionary *)info {
    [self.iconImageview setImageWithURL:[NSURL URLWithString:info[@"lx_picurl"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    self.titleLabel.text = info[@"lx_name"];
    self.describeLabel.text = info[@"lx_describe"];
    [self.starRatingController setRating:[info[@"lx_star"] floatValue]];
}

- (void)dealloc {
    RELEASE_SAFELY(_starRatingController);
    [_iconImageview release];
    [_titleLabel release];
    [_describeLabel release];
    [_callButton release];
    [super dealloc];
}

@end
