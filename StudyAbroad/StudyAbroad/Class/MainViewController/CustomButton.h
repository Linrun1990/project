//
//  CustomButton.h
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

@interface CustomButton : UIControl

@property (retain, nonatomic) IBOutlet UIView *content;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *backView;

- (void)reloadWithImage:(NSString *)imageName title:(NSString *)title;

@end
