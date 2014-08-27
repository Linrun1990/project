//
//  CheckViewTableViewCell.h
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJStarRatingControl.h"

@interface CheckViewTableViewCell : UITableViewCell

@property (nonatomic, retain) DJStarRatingControl *starRatingController;

- (void)reloadCell:(NSDictionary *)info;

@end
