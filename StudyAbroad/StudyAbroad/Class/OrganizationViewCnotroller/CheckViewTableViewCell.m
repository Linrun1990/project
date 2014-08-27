//
//  CheckViewTableViewCell.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CheckViewTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CheckViewTableViewCell ()

@property (retain, nonatomic) IBOutlet UILabel *describeLabel;
@property (retain, nonatomic) IBOutlet UILabel *englishNameLabel;

@end

@implementation CheckViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self buildStarRatingController];
}

- (void)buildStarRatingController {
     _starRatingController = [[DJStarRatingControl alloc] initWithFrame:CGRectMake(97, 36, 125, 16) andStars:5 isFractional:YES defaultStar:@"big_star_normal.png" highlightedStar:@"big_star_selected.png"];
    _starRatingController.enabled = NO;
    [self addSubview:_starRatingController];
}

- (void)reloadCell:(NSDictionary *)info {
    self.describeLabel.text = info[@"c_comment"];
    self.englishNameLabel.text = info[@"c_username"];
    float rating = [info[@"c_star"] floatValue];
    [self.starRatingController setRating:rating];
}

- (void)dealloc {
    [_describeLabel release];
    [_englishNameLabel release];
    [super dealloc];
}
@end
