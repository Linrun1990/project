//
//  CounselSubViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CounselSubViewController.h"
#import "DJPageView.h"
#import "PullToRefreshTableView.h"
#import "CounselSubViewTableViewCell.h"
#import "CounselDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomTabBar.h"

@interface CounselSubViewController () <PullToRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) PullToRefreshTableView *pullToRefreshTableView;
@property (retain, nonatomic) DJPageView *carouselPageView;
@property (retain, nonatomic) ASIFormDataRequest *requestNewsList;
@property (retain, nonatomic) ASIFormDataRequest *requestCarousel;
@property (retain, nonatomic) NSNumber *typeId;
@property (retain, nonatomic) NSMutableArray *list;
@property (retain, nonatomic) NSMutableArray *carouselList;
@property (assign, nonatomic) BOOL isRequestNext;

@end

@implementation CounselSubViewController

- (id)initWithNewTypeId:(NSNumber *)typeId {
    if (self = [super init]) {
        self.typeId = typeId;
        self.list = [NSMutableArray array];
        self.carouselList = [NSMutableArray array];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沃留学";
    [self requestCarousels];
    [self requestNewsLists:0];
    [self buildPullToRefreshTableView];
    [self buildCarouselPageView];
    self.pullToRefreshTableView.tableHeaderView = self.carouselPageView;
}

- (void)dealloc {
    RELEASE_SAFELY(_carouselPageView);
    RELEASE_SAFELY(_pullToRefreshTableView);
    RELEASE_SAFELY(_requestNewsList);
    RELEASE_SAFELY(_requestCarousel);
    RELEASE_SAFELY(_list);
    RELEASE_SAFELY(_typeId);
    RELEASE_SAFELY(_carouselList);
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.carouselPageView startPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.carouselPageView endPlay];
    [super viewWillDisappear:animated];
}

#pragma mark - PullToRefreshTableViewDelegate

- (void)getHeaderDataSoure {
	[self requestNewsLists:0];
    [self.pullToRefreshTableView reloadData];
}

- (void)getFooterDataSoure {
    if (!self.pullToRefreshTableView.isLoadedAllTheData) {
        [self requestNewsLists:self.list.count];
    }else {
        [self.pullToRefreshTableView doneLoadingTableViewData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CounselSubViewTableViewCell";
    CounselSubViewTableViewCell *cell = (CounselSubViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [CounselSubViewTableViewCell loadFromNIB];
    }
    [cell reloadWithInfo:self.list[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.pullToRefreshTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.list[indexPath.row];
    NSNumber *newId = info[@"news_id"];
    CounselDetailViewController *detailViewController = [[[CounselDetailViewController alloc] initWithNewsId:newId] autorelease];
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
    self.pullToRefreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullToRefreshTableView.dataSource = self;
    self.pullToRefreshTableView.delegate = self;
    self.pullToRefreshTableView.customTableDelegate = self;
    self.pullToRefreshTableView.rowHeight = 60;
    self.pullToRefreshTableView.backgroundColor = [UIColor whiteColor];
    self.pullToRefreshTableView.showsVerticalScrollIndicator = NO;
    [self.pullToRefreshTableView setRefreshCategory:BothRefresh];
    [self.view addSubview:self.pullToRefreshTableView];
}

- (void)buildCarouselPageView {
    self.carouselPageView = [[[DJPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)] autorelease];
    self.carouselPageView.backgroundColor = [UIColor blueColor];
    [self.carouselPageView loadView];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (request == self.requestNewsList) {
        if (errorCode == 0) {
            NSArray *newsList = result[@"list"];
            for (NSDictionary *info in newsList) {
                [self.list addObject:info];
            }
            NSInteger totals = [result[@"total"] intValue];
            self.pullToRefreshTableView.isLoadedAllTheData = self.list.count >= totals;
            [self.pullToRefreshTableView reloadData];
        }else if (self.list.count == 0) {
            [self showErrorViewAnimated:YES];
        }else {
            [[Toast makeText:NETWORK_ERROR] show];
        }
        [self.pullToRefreshTableView doneLoadingTableViewData];
    }else if(request == self.requestCarousel){
        if (errorCode == 0) {
            NSArray *requestList = result[@"list"];
            for (NSDictionary *info in requestList) {
                [self.carouselList addObject:info];
            }
            [self reloadPageView];
        }else {
            [[Toast makeText:NETWORK_ERROR] show];
        }
    }
    
}

- (void)errorViewButtonDidPress {
    [self hideErrorViewAnimated:YES];
    [self requestCarousel];
    [self requestNewsLists:0];
}

- (void)reloadPageView {
    self.carouselPageView.count = self.carouselList.count;
    __block CounselSubViewController *selfTemp = self;
    self.carouselPageView.didTap = ^(NSNumber *index){
        NSDictionary *info = self.carouselList[[index intValue]];
        NSNumber *newId = info[@"news_id"];
        CounselDetailViewController *detailViewController = [[[CounselDetailViewController alloc] initWithNewsId:newId] autorelease];
        detailViewController.hidesBottomBarWhenPushed = YES;
        [selfTemp.navigationController pushViewController:detailViewController animated:YES];
    };
    [self.carouselPageView updateWithView:^UIView *(NSNumber *index, CGRect frame) {
        NSDictionary *item = self.carouselList[[index intValue]];
        NSString *imageUrl = item[@"news_picurl"];
        UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_horizontal.9.png"]];
        imageView.frame = frame;
        return imageView;
    }];
}

- (void)requestNewsLists:(NSInteger)start {
    [self showLoadingViewAnimated:YES];
    if (start == 0) {
        [self.list removeAllObjects];
    }
    self.requestNewsList = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestNewsList setRequestMethod:HTTP_TYPE];
    [self.requestNewsList setPostValue:@8 forKey:@"act"];
    [self.requestNewsList setPostValue:self.typeId forKey:@"type"];
    [self.requestNewsList setPostValue:[NSNumber numberWithInt:start] forKey:@"start"];
    self.requestNewsList.delegate = self;
    [self.requestNewsList startAsynchronous];
}

- (void)requestCarousels {
    [self.carouselList removeAllObjects];
    self.requestCarousel = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestCarousel setRequestMethod:HTTP_TYPE];
    [self.requestCarousel setPostValue:@22 forKey:@"act"];
    [self.requestCarousel setPostValue:self.typeId forKey:@"type"];
    self.requestCarousel.delegate = self;
    [self.requestCarousel startAsynchronous];
}

@end






