//
//  WaterFlowView.h
//  MBaoBao
//
//  Created by yi_dq on 20/2/14.
//  Copyright (c) 2014 Bodong Baidu. All rights reserved.
//

#import "WFIndexPath.h"
#import "PullToRefreshTableView.h"

@protocol WaterFlowViewDataSource;
@protocol WaterFlowViewDelegate;

@class WaterFlowView;

@interface WaterFlowView : PullToRefreshTableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<WaterFlowViewDelegate> waterFlowViewDelegate;
@property (nonatomic, assign) id<WaterFlowViewDataSource> waterFlowViewDataSource;

- (void)reloadData;

@end

@protocol WaterFlowViewDelegate <NSObject>
@optional

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath;
- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath;

@end

@protocol WaterFlowViewDataSource <NSObject>
@optional

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(WFIndexPath *)indexPath;
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView;
- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumn:(NSInteger)colunm;

@end


