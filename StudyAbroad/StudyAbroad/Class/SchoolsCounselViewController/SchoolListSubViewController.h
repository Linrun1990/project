//
//  SchoolListSubViewController.h
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "BaseViewController.h"

@interface SchoolListSubViewController : BaseViewController

@property (nonatomic, retain) NSString *contry;

- (id)initWithSchoolType:(NSInteger)type countryId:(NSNumber *)countryId;

@end
