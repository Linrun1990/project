//
//  CustomTableView.m
//  TableViewPull
//
//  Created by lory qing on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullToRefreshTableView.h"

@interface PullToRefreshTableView()

- (void)addHeaderRefreshView;
- (void)addFooterRefreshView;
- (void)removeHeaderAndFooterView;

@end

@implementation PullToRefreshTableView

@synthesize customTableDelegate = _customTableDelegate;
@synthesize isLoadedAllTheData = _isLoadedAllTheData;

#pragma mark - view lifestyle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)reloadData{
    [super reloadData];
    float y = self.frame.size.height > self.contentSize.height ? self.frame.size.height : self.contentSize.height;
    _refreshFooterView.frame = CGRectMake(0.0f, y, self.frame.size.width, 650);
}

- (void)dealloc{
    RELEASE_SAFELY(_refreshHeaderView);
    RELEASE_SAFELY(_refreshFooterView);
    [super dealloc];
}

#pragma mark - public methods

- (void)setRefreshCategory:(RefreshCategory)refreshCategory{
    [self removeHeaderAndFooterView];
    if (refreshCategory == DropdownRefresh) {
        [self addHeaderRefreshView];
    }else if(refreshCategory == PullRefresh){
        [self addFooterRefreshView];
    }else if(refreshCategory == BothRefresh){
        [self addHeaderRefreshView];
        [self addFooterRefreshView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

// 此下两个函数是触发动作的开始  即拖拽动作
- (void)customTableViewWillBeginDragging:(UIScrollView *)scrollView{
	_point =scrollView.contentOffset;
}

- (void)customTableViewDidScroll:(UIScrollView *)scrollView{	
    if (_reloading) {
        return;
    }

	CGPoint pt =scrollView.contentOffset;
    if (_point.y > pt.y) {//向下拉加载更多
        [_refreshHeaderView egoRefreshScrollViewDidScroll:self];
    }else if(!_isLoadedAllTheData){//向上提加载更多 且 没有加载完服务器端数据
        [_refreshFooterView egoRefreshScrollViewDidScroll:self];
    }
	
}

- (void)customTableViewDidEndDragging:(UIScrollView *)scrollView{
    if (_reloading) {
        return;
    }
    
    CGPoint pt =scrollView.contentOffset;
    if (_point.y > pt.y) {//向下拉加载更多
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
    }else if(!_isLoadedAllTheData){ //向上提加载更多 且 没有加载完服务器端数据
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:self];
    }	
}

#pragma mark - Data Source Loading / Reloading Methods

- (void)reloadTableViewHeaderDataSource{
    _reloading = YES;
    if (_isLoadedAllTheData) {
        _isLoadedAllTheData = NO;
        [self addSubview:_refreshFooterView];
    }
    DELEGATE_CALLBACK(_customTableDelegate, getHeaderDataSoure);
}

- (void)reloadTableViewFooterDataSource{
    _reloading = YES;
    DELEGATE_CALLBACK(_customTableDelegate, getFooterDataSoure);
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
	[_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    if (_isLoadedAllTheData && _refreshFooterView != nil) {
        [_refreshFooterView  removeFromSuperview];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(DianJinEGORefreshTableHeaderView*)view{
	
	[self reloadTableViewHeaderDataSource];	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(DianJinEGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark EGORefreshTableFooterDelegate Methods

- (void)egoRefreshTableFooterDidTriggerRefresh:(DianJinEGORefreshTableFooterView*)view{
	
	[self reloadTableViewFooterDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];	
}


#pragma mark - private methods

- (void)addHeaderRefreshView {
	if (_refreshHeaderView == nil) {
		_refreshHeaderView =  [[DianJinEGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
		_refreshHeaderView.delegate = self;
	}
    [self addSubview:_refreshHeaderView];
}

- (void)addFooterRefreshView {
	if (_refreshFooterView == nil) {
        float y = self.frame.size.height > self.contentSize.height ? self.frame.size.height : self.contentSize.height;
		_refreshFooterView = [[DianJinEGORefreshTableFooterView alloc] initWithFrame: CGRectMake(0.0f, y, self.frame.size.width, 650)];
		_refreshFooterView.delegate = self;  
        _refreshFooterView.backgroundColor = [UIColor clearColor];
	}
    [self addSubview:_refreshFooterView];
}

- (void)removeHeaderAndFooterView {
    if(_refreshHeaderView != nil) {
        [_refreshHeaderView removeFromSuperview];
    }
    if(_refreshFooterView != nil) {
        [_refreshFooterView removeFromSuperview];
    }
}
@end
