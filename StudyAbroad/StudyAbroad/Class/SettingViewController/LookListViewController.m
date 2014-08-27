//
//  LookListViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "LookListViewController.h"
#import "ASIFormDataRequest.h"
#import "LookListViewTableViewCell.h"
#import "SchoolDetailViewController.h"

@interface LookListViewController ()

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *list;
@property (retain, nonatomic) ASIFormDataRequest *requestList;
@property (retain, nonatomic) NSNumber *money;
@end

@implementation LookListViewController

- (id)initWithMoney:(NSNumber *)money {
    if (self = [super init]) {
        self.money = money;
        self.list = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLists];
}

- (void)dealloc {
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_list);
    RELEASE_SAFELY(_requestList);
    RELEASE_SAFELY(_money);
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LookListViewTableViewCell";
    LookListViewTableViewCell *cell = (LookListViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [LookListViewTableViewCell loadFromNIB];
    }
    [cell reloadViewWithInfo:self.list[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.list[indexPath.row];
    SchoolDetailViewController *viewController = [[[SchoolDetailViewController alloc] initWithSchoolId:info] autorelease];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        if ([result[@"list"] isKindOfClass:[NSArray class]]) {
            self.list = result[@"list"];
            [self.tableView reloadData];
        }else {
            [self showNotHaveDataOnView:self.view];
        }
    }
    else if (self.list.count == 0) {
        [self showErrorViewAnimated:YES];
    }
}

- (void)errorViewButtonDidPress {
    [self requestLists];
}

- (void)requestLists {
    [self showLoadingViewAnimated:YES];
    self.requestList = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestList setRequestMethod:HTTP_TYPE];
    [self.requestList setPostValue:@23 forKey:@"act"];
    [self.requestList setPostValue:self.money forKey:@"money"];
    self.requestList.delegate = self;
    [self.requestList startAsynchronous];
}

@end
