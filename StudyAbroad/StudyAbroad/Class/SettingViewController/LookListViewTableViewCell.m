//
//  LookListViewTableViewCell.m
//  StudyAbroad
//
//  Created by LR on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "LookListViewTableViewCell.h"
#import "DJStarRatingControl.h"

@interface LookListViewTableViewCell ()

@property (nonatomic, retain) DJStarRatingControl *starRatingController;
@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *enlishName;

@end

@implementation LookListViewTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self buildStarRatingController];
}

- (void)buildStarRatingController {
    _starRatingController = [[DJStarRatingControl alloc] initWithFrame:CGRectMake(68, 56, 125, 16) andStars:5 isFractional:YES defaultStar:@"big_star_normal.png" highlightedStar:@"big_star_selected.png"];
    _starRatingController.enabled = NO;
    [self addSubview:_starRatingController];
}

- (void)reloadViewWithInfo:(NSDictionary *)info {
    [self.icon setImageWithURL:[NSURL URLWithString:info[@"co_picurl"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    self.name.text = info[@"co_name"];
    self.enlishName.text = info[@"co_enname"];
    float rating = [info[@"co_rank"] floatValue];
    [self.starRatingController setRating:rating];
}

- (void)dealloc {
    RELEASE_SAFELY(_starRatingController);
    [_icon release];
    [_name release];
    [_enlishName release];
    [super dealloc];
}

@end
