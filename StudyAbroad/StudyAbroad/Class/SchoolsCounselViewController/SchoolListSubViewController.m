//
//  SchoolListSubViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SchoolListSubViewController.h"
#import "SchoolListSubTableViewCell.h"
#import "SchoolDetailViewController.h"
#import "PullToRefreshTableView.h"

@interface SchoolListSubViewController () <PullToRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) PullToRefreshTableView *pullToRefreshTableView;
@property (assign, nonatomic) NSInteger type;
@property (nonatomic, retain) ASIFormDataRequest *requestSchools;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSNumber *countryId;

@end

@implementation SchoolListSubViewController

- (id)initWithSchoolType:(NSInteger)type countryId:(NSNumber *)countryId {
    if (self = [super init]) {
        self.type = type;
        self.countryId = countryId;
        self.list = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestCountry:0];
    [self buildPullToRefreshTableView];
}

- (void)dealloc {
    RELEASE_SAFELY(_pullToRefreshTableView);
    RELEASE_SAFELY(_requestSchools);
    RELEASE_SAFELY(_list);
    [super dealloc];
}

#pragma mark - PullToRefreshTableViewDelegate

- (void)getHeaderDataSoure {
	[self requestCountry:0];
}

- (void)getFooterDataSoure {
    if (!self.pullToRefreshTableView.isLoadedAllTheData) {
        [self requestCountry:self.list.count];
    }else {
        [self.pullToRefreshTableView doneLoadingTableViewData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SchoolListSubTableViewCell";
    SchoolListSubTableViewCell *cell = (SchoolListSubTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [SchoolListSubTableViewCell loadFromNIB];
    }
    [cell reloadViewWithDictionary:self.list[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.pullToRefreshTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.list[indexPath.row];
    NSMutableDictionary *model = [NSMutableDictionary dictionaryWithDictionary:info];
    [model setObject:self.contry forKey:@"guojia"];
    NSString *hightlight = self.type == 2 ? @"高中" : @"大学";
    [model setObject:hightlight forKey:@"leixing"];
    SchoolDetailViewController *detailViewController = [[[SchoolDetailViewController alloc] initWithSchoolId:model] autorelease];
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

- (void)buildPullToRefreshTableView {
    self.pullToRefreshTableView = [[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)] autorelease];
    self.pullToRefreshTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pullToRefreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullToRefreshTableView.dataSource = self;
    self.pullToRefreshTableView.delegate = self;
    self.pullToRefreshTableView.customTableDelegate = self;
    self.pullToRefreshTableView.rowHeight = 100;
    self.pullToRefreshTableView.backgroundColor = [UIColor whiteColor];
    self.pullToRefreshTableView.showsVerticalScrollIndicator = NO;
    [self.pullToRefreshTableView setRefreshCategory:BothRefresh];
    [self.view addSubview:self.pullToRefreshTableView];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        id newsList = result[@"list"];
        if ([newsList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *info in newsList) {
                [self.list addObject:info];
            }
        }
        NSInteger totals = [result[@"total"] intValue];
        self.pullToRefreshTableView.isLoadedAllTheData = self.list.count >= totals;
        [self.pullToRefreshTableView reloadData];
        if (self.list.count == 0) {
            [self showNotHaveDataOnView:self.view];
        }
    }
    else if (self.list.count == 0) {
        [self showErrorViewAnimated:YES];
    }else {
        [[Toast makeText:NETWORK_ERROR] show];
    }
    [self.pullToRefreshTableView doneLoadingTableViewData];
    
}

- (void)errorViewButtonDidPress {
    [self hideErrorViewAnimated:YES];
    [self requestCountry:0];
}

- (void)requestCountry:(NSInteger)start {
    [self showLoadingViewAnimated:YES];
    if (start == 0) {
        [self.list removeAllObjects];
    }
    self.requestSchools = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestSchools setRequestMethod:HTTP_TYPE];
    [self.requestSchools setPostValue:@12 forKey:@"act"];
    [self.requestSchools setPostValue:[NSNumber numberWithInt:self.type] forKey:@"type"];
    [self.requestSchools setPostValue:self.countryId forKey:@"cn_id"];
    [self.requestSchools setPostValue:[NSNumber numberWithInt:start] forKey:@"start"];
    self.requestSchools.delegate = self;
    [self.requestSchools startAsynchronous];
}

@end

