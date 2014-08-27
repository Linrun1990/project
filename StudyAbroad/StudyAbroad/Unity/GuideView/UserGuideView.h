//
//  UserGuideView.h
//  Pocket91
//
//  Created by Lin Feihong on 13-9-5.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

//  Code review记录
//  时间：2013-9-17 负责人：Lin Feihong
//  时间：2013-9-29 负责人：Lin Feihong

@protocol UserGuideViewDelegate;

@interface UserGuideView : UIView

@property (nonatomic, assign) id<UserGuideViewDelegate> delegate;

+ (UserGuideView *)userGuideView;
- (void)show;

@end

@protocol UserGuideViewDelegate <NSObject>

@optional

- (void)userGuideViewWillShow:(UserGuideView *)userGuideView;
- (void)userGuideViewDidShow:(UserGuideView *)userGuideView;
- (void)userGuideViewWillHide:(UserGuideView *)userGuideView;
- (void)userGuideViewDidHide:(UserGuideView *)userGuideView;

@end
