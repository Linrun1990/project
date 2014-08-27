//
//  SchoolCounselCell.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-12.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SchoolCounselCell.h"

@implementation SchoolCounselCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)] autorelease];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}


- (void)dealloc {
    [_titleLabel release];
    [super dealloc];
}
@end
