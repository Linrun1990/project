//
//  RAMCollectionViewCell.m
//  RAMCollectionViewFlemishBondLayoutDemo
//
//  Created by Rafael Aguilar Martín on 20/10/13.
//  Copyright (c) 2013 Rafael Aguilar Martín. All rights reserved.
//

#import "RAMCollectionViewCell.h"

@interface RAMCollectionViewCell ()
    @property (nonatomic, strong) UILabel *label;
@end

@implementation RAMCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup
- (void)setup
{
    [self setupView];
    [self setupLabel];
}

- (void)setupView
{
    self.backgroundColor = [UIColor randomColor];
}

- (void)setupLabel
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    [self addSubview:self.label];
}

#pragma mark - Configure
- (void)configureCellWithIndexPath:(NSString *)title
{
    self.label.frame = CGRectMake(0, 0, self.width, self.height);
    self.label.text = title;
}

@end
