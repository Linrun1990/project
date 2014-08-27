//
//  OrganizationViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "OrganizationViewController.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationDetailViewController.h"
#import "CustomTabBar.h"
#import "PullToRefreshTableView.h"

@interface OrganizationViewController () <UITableViewDelegate, UITableViewDataSource, PullToRefreshTableViewDelegate>

@property (retain, nonatomic) PullToRefreshTableView *pullToRefreshTableView;
@property (retain, nonatomic) ASIFormDataRequest *requestOrganization;
@property (retain, nonatomic) NSMutableArray *organizationList;



@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沃留学";
    self.organizationList = [NSMutableArray array];
    [self buildPullToRefreshTableView];
    [self requestList:0];
    [self buildRightButton];
}

- (void)dealloc {
    RELEASE_SAFELY(_pullToRefreshTableView);
    [super dealloc];
}


#pragma mark - PullToRefreshTableViewDelegate

- (void)getHeaderDataSoure {
	[self requestList:0];
    [self.pullToRefreshTableView reloadData];
}

- (void)getFooterDataSoure {
    if (!self.pullToRefreshTableView.isLoadedAllTheData) {
        [self requestList:self.organizationList.count];
    }else {
        [self.pullToRefreshTableView doneLoadingTableViewData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.organizationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"OrganizationTableViewCell";
    OrganizationTableViewCell *cell = (OrganizationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [OrganizationTableViewCell loadFromNIB];
    }
    [cell reloadViewWithInfo:self.organizationList[indexPath.row]];
    cell.callButton.tag = indexPath.row;
    [cell.callButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.pullToRefreshTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.organizationList[indexPath.row];
    NSNumber *id = info[@"lx_id"];
    OrganizationDetailViewController *detailViewController = [[[OrganizationDetailViewController alloc] initWithOrganizationId:id] autorelease];
    detailViewController.title = info[@"lx_name"];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pullToRefreshTableView customTableViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullToRefreshTableView customTableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pullToRefreshTableView customTableViewDidEndDragging:scrollView];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        NSArray *newsList = result[@"list"];
        if (newsList.count > 0) {
            for (NSDictionary *info in newsList) {
                [self.organizationList addObject:info];
            }
        }
        NSInteger totals = [result[@"total"] intValue];
        self.pullToRefreshTableView.isLoadedAllTheData = self.organizationList.count >= totals;
        [self.pullToRefreshTableView reloadData];
    }
    else if (self.organizationList.count == 0) {
        [self showErrorViewAnimated:YES];
    }else {
        [[Toast makeText:NETWORK_ERROR] show];
    }
    [self.pullToRefreshTableView doneLoadingTableViewData];
    
}

- (void)errorViewButtonDidPress {
    [self hideErrorViewAnimated:YES];
    [self requestList:0];
}

- (void)buildPullToRefreshTableView {
    self.pullToRefreshTableView = [[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)] autorelease];
    self.pullToRefreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullToRefreshTableView.dataSource = self;
    self.pullToRefreshTableView.delegate = self;
    self.pullToRefreshTableView.customTableDelegate = self;
    self.pullToRefreshTableView.rowHeight = 135;
    self.pullToRefreshTableView.backgroundColor = [UIColor colorWithString:@"#f1f1f1"];
    self.pullToRefreshTableView.showsVerticalScrollIndicator = NO;
    [self.pullToRefreshTableView setRefreshCategory:BothRefresh];
    [self.view addSubview:self.pullToRefreshTableView];
}

- (void)requestList:(NSInteger)start {
    [self showLoadingViewAnimated:YES];
    if (start == 0) {
        [self.organizationList removeAllObjects];
    }
    self.requestOrganization = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestOrganization setRequestMethod:HTTP_TYPE];
    [self.requestOrganization setPostValue:@9 forKey:@"act"];
    [self.requestOrganization setPostValue:@"北京市" forKey:@"city"];
    [self.requestOrganization setPostValue:[NSNumber numberWithInt:start] forKey:@"start"];
    self.requestOrganization.delegate = self;
    [self.requestOrganization startAsynchronous];
}

- (void)callPhone:(id)sender {
    UIButton *call = (UIButton *)sender;
    NSDictionary *info = self.organizationList[call.tag];
    // 拨打电话
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", info[@"lx_phone"]]]];
}

@end







