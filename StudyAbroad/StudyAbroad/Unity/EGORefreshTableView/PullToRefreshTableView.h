//
//  CustomTableView.h
//  TableViewPull
//
//  Created by lory qing on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

typedef enum{
    BothRefresh = 0,
    DropdownRefresh,
    PullRefresh,
    NoRefresh
}RefreshCategory;

#import "DianJinEGORefreshTableFooterView.h"
#import "DianJinEGORefreshTableHeaderView.h"

@protocol PullToRefreshTableViewDelegate <NSObject>

@optional
- (void)getHeaderDataSoure;
- (void)getFooterDataSoure;

@end

@interface PullToRefreshTableView : UITableView<DianJinEGORefreshTableHeaderDelegate,DianJinEGORefreshTableFooterDelegate>{
    DianJinEGORefreshTableHeaderView *_refreshHeaderView;  //刷新的控件
	DianJinEGORefreshTableFooterView *_refreshFooterView;  //加载更多
    id<PullToRefreshTableViewDelegate> _customTableDelegate;
    RefreshCategory _refreshCategory;
    CGPoint _point; //判断是上拉还是下拉
    
    BOOL _reloading;
    BOOL _isLoadedAllTheData;//是否已经加载完服务器端所有的数据
}

@property (nonatomic, assign) BOOL isLoadedAllTheData;
@property (nonatomic, assign) id<PullToRefreshTableViewDelegate> customTableDelegate;

- (void)reloadTableViewHeaderDataSource;
- (void)reloadTableViewFooterDataSource;
- (void)doneLoadingTableViewData;
- (void)setRefreshCategory:(RefreshCategory)refreshCategory;

- (void)customTableViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)customTableViewDidScroll:(UIScrollView *)scrollView;
- (void)customTableViewDidEndDragging:(UIScrollView *)scrollView;

@end
