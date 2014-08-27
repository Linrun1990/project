//
//  AboutMineViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "AboutMineViewController.h"
#import "TopMenuBarController.h"
#import "ASIFormDataRequest.h"
#import "CounselSubViewController.h"
#import "DetailViewController.h"
#import "AboutMineTableViewCell.h"

@interface AboutMineViewController ()

@property (nonatomic, retain) TopMenuBarController *topMenuBarController;
@property (nonatomic, retain) ASIFormDataRequest *requestTitles;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ASIFormDataRequest *requestPeople;
@property (nonatomic, retain) NSArray *peopleList;

@end

@implementation AboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沃留学";
    self.peopleList = [NSArray array];
    [self requestNewsTypes];
    [self requestPeoples];
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)dealloc {
    RELEASE_SAFELY(_topMenuBarController);
    RELEASE_SAFELY(_requestTitles);
    RELEASE_SAFELY(_requestPeople);
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_peopleList);
    [super dealloc];
}


- (void)buildTopMenuBarController:(NSDictionary *)model {
    NSArray *titles = [NSArray arrayWithObjects:@"协会服务", @"协会业务", @"协会背景", nil];
    NSMutableArray *viewControllers = [NSMutableArray array];
    DetailViewController *subView = [[[DetailViewController alloc] initWithDetai:model[@"service"]] autorelease];
    [viewControllers addObject:subView];
    DetailViewController *subView1 = [[[DetailViewController alloc] initWithDetai:model[@"business"]] autorelease];
    [viewControllers addObject:subView1];
    DetailViewController *subView2 = [[[DetailViewController alloc] initWithDetai:model[@"background"]] autorelease];
    [viewControllers addObject:subView2];
    self.topMenuBarController = [[[TopMenuBarController alloc] initWithItemTitles:titles viewControllers:viewControllers] autorelease];
    self.topMenuBarController.view.frame = CGRectMake(0, 80, self.view.width, 130);
    self.topMenuBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    UIView *menuBarBackgroundView = [self buildMenuBarBackgroundView];
    self.topMenuBarController.menuBar.backgroundView = menuBarBackgroundView;
    UIView *menuIndicatorView = [self buildMenuBarIndicatorView];
    self.topMenuBarController.menuBar.indicatorView = menuIndicatorView;
    self.topMenuBarController.menuBar.itemNormalColor = [UIColor blackColor];
    self.topMenuBarController.menuBar.itemSelectedColor = [UIColor blackColor];
    [self.view addSubview:self.topMenuBarController.view];
    [self addChildViewController:self.topMenuBarController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peopleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AboutMineTableViewCell";
    AboutMineTableViewCell *cell = (AboutMineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [AboutMineTableViewCell loadFromNIB];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    [cell reloadImage:self.peopleList[indexPath.row][@"mem_picurl"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *info = self.list[indexPath.row];
//    SchoolDetailViewController *detailViewController = [[[SchoolDetailViewController alloc] initWithSchoolId:info] autorelease];
//    detailViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *data = request.responseData;
    NSString *response = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    response = JSON_EXCLUDE_NULL(response);
    NSMutableDictionary *result = [response objectFromJSONString];
    NSInteger errorCode = [result[@"error"] intValue];
    if (request == self.requestTitles) {
        if (errorCode == 0) {
            [self buildTopMenuBarController:result];
        }else {
            [[Toast makeText:NETWORK_ERROR] show];
        }
    }else {
        if (errorCode == 0) {
            if ([result[@"list"] isKindOfClass:[NSArray class]]) {
                self.peopleList = result[@"list"];
                [self.tableView reloadData];
            }
        }else {
            [[Toast makeText:NETWORK_ERROR] show];
        }
    }
}

- (UIView *)buildMenuBarBackgroundView {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35.0)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    UIView *indicatorView = [[[UIView alloc] initWithFrame:CGRectMake(0, 31, 320, 4)] autorelease];
    indicatorView.backgroundColor = RGB(255, 210, 155);
    [view addSubview:indicatorView];
    return view;
}

- (UIView *)buildMenuBarIndicatorView {
    UIView *view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor clearColor];
    UIView *indicatorView = [[[UIView alloc] initWithFrame:CGRectMake(30, 31, 40, 4)] autorelease];
    indicatorView.backgroundColor = RGB(177, 0, 62);
    [view addSubview:indicatorView];
    return view;
}

- (void)requestNewsTypes {
    self.requestTitles = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestTitles setRequestMethod:HTTP_TYPE];
    [self.requestTitles setPostValue:@19 forKey:@"act"];
    self.requestTitles.delegate = self;
    [self.requestTitles startAsynchronous];
}

- (void)requestPeoples {
    self.requestPeople = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestPeople setRequestMethod:HTTP_TYPE];
    [self.requestPeople setPostValue:@20 forKey:@"act"];
    self.requestPeople.delegate = self;
    [self.requestPeople startAsynchronous];
}

@end





