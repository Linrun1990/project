//
//  FavoriteListViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "FavoriteListTableViewCell.h"
#import "OrganizationDetailViewController.h"

@interface FavoriteListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *list;

@end

@implementation FavoriteListViewController

- (id)initWithLiat:(NSArray *)list {
    if (self = [super init]) {
        self.list = list;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.list.count == 0) {
        [self showNotHaveDataOnView:self.view];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"OrganizationTableViewCell";
    FavoriteListTableViewCell *cell = (FavoriteListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [FavoriteListTableViewCell loadFromNIB];
    }
    [cell reloadWithInfo:self.list[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.list[indexPath.row];
    
    OrganizationDetailViewController *viewController = [[[OrganizationDetailViewController alloc] initWithOrganizationId:info[@"fav_lx_id"]] autorelease];
    viewController.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)dealloc {
    [_tableView release];
    RELEASE_SAFELY(_list);
    [super dealloc];
}
@end
