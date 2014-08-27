//
//  DianJinEGORefreshTableFooterView.h
//  Tmart
//
//  Created by zongteng on 12-1-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum{
    kDJEGOOFooterPullRefreshPulling = 0,
    kDJEGOOFooterPullRefreshNormal,
    kDJEGOOFooterPullRefreshLoading
} EGOFooterPullRefreshState;

@protocol DianJinEGORefreshTableFooterDelegate;

@interface DianJinEGORefreshTableFooterView : UIView {
    id _delegate;
    EGOFooterPullRefreshState _state;
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <DianJinEGORefreshTableFooterDelegate> delegate;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@protocol DianJinEGORefreshTableFooterDelegate<NSObject>

- (void)egoRefreshTableFooterDidTriggerRefresh:(DianJinEGORefreshTableFooterView*)view;

@end
