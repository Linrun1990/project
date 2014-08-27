//
//  WaterFlowView.m
//  MBaoBao
//
//  Created by yi_dq on 20/2/14.
//  Copyright (c) 2014 Bodong Baidu. All rights reserved.
//

#import "WaterFlowView.h"

#define TABLE_VIEW_TAG_OFFSET 1000
#define CELL_SUBVIEW_TAG_OFFSET 10000

@interface WaterFlowView ()

@property (nonatomic, retain) NSMutableArray *tableviews;
@property (nonatomic, assign) float cellWidth;

@end

@implementation WaterFlowView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    for (UITableView *tableview in _tableviews) {
        [tableview setFrame:CGRectMake(tableview.frame.origin.x, self.contentOffset.y, CGRectGetWidth(tableview.frame), CGRectGetHeight(tableview.frame))];
        [tableview setContentOffset:self.contentOffset animated:NO];
    }
    [super layoutSubviews];
}

- (void)relayoutDisplaySubviews {
   int columnCount = [self.waterFlowViewDataSource numberOfColumsInWaterFlowView:self];
    if (columnCount == 0) {
        return;
    }
    self.cellWidth = CGRectGetWidth(self.frame) / columnCount;
    if (_tableviews == nil || self.tableviews.count != columnCount) {
        for (UIView *subview in self.subviews) {
            if([subview isKindOfClass:[UITableView class]]){
                [subview removeFromSuperview];
            }
        }
        self.tableviews = [[[NSMutableArray alloc] initWithCapacity:columnCount] autorelease];
        for (int i = 0; i < columnCount; i++) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(_cellWidth*i, 0, _cellWidth, CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tag = i + TABLE_VIEW_TAG_OFFSET;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.scrollEnabled = NO;
            tableView.scrollsToTop = NO;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = [UIColor clearColor];
            [self addSubview:tableView];
            [_tableviews addObject:tableView];
            [tableView release];
        }
    }
}

- (void)dealloc {
    _waterFlowViewDelegate = nil;
    _waterFlowViewDataSource = nil;
    [_tableviews release];
    [super dealloc];
}

#pragma mark - public methods

- (void)reloadData {
    [self relayoutDisplaySubviews];
    float contenSizeHeight = 0.0f;
    for (UITableView *tabelview in _tableviews) {
        [tabelview reloadData];
        if (contenSizeHeight < tabelview.contentSize.height) {
            contenSizeHeight = tabelview.contentSize.height;
        }
    }
    contenSizeHeight = contenSizeHeight < CGRectGetHeight(self.frame) ? CGRectGetHeight(self.frame)  : contenSizeHeight;
    self.contentSize = CGSizeMake(self.contentSize.width, contenSizeHeight);
    self.rowHeight = contenSizeHeight;
    [super reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int numberOfRows = 0;
    if(tableView == self){
        numberOfRows = 1;
    }else {
        numberOfRows = [_waterFlowViewDataSource waterFlowView:self numberOfRowsInColumn:tableView.tag - TABLE_VIEW_TAG_OFFSET];
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    if(tableView == self){
        rowHeight = self.contentSize.height;
    }else {
        WFIndexPath *_indextPath = [WFIndexPath initWithRow:indexPath.row  withColumn:tableView.tag - TABLE_VIEW_TAG_OFFSET];
        CGFloat cellHeight = [self.waterFlowViewDelegate waterFlowView:self heightForRowAtIndexPath:_indextPath];
        rowHeight = cellHeight;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == self){
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
    }else {
        WFIndexPath *waterFlowIndexPath = [WFIndexPath initWithRow:indexPath.row  withColumn:tableView.tag - TABLE_VIEW_TAG_OFFSET];
        cell = [self.waterFlowViewDataSource tableView:tableView cellForRowAtIndexPath:waterFlowIndexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WFIndexPath *indextPath = [WFIndexPath initWithRow:indexPath.row  withColumn:tableView.tag - TABLE_VIEW_TAG_OFFSET];
    [self.waterFlowViewDelegate waterFlowView:self didSelectRowAtIndexPath:indextPath];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self customTableViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self customTableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self customTableViewDidEndDragging:scrollView];
}

@end
