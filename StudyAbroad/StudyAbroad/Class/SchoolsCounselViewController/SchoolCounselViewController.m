//
//  SchoolCounselViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SchoolCounselViewController.h"
#import "SchoolListViewController.h"
#import "SchoolCounselCell.h"
#import "CustomTabBar.h"
#import "SchoolListViewController.h"
#import "SearchViewController.h"

#import "RAMViewController.h"
#import "RAMCollectionViewCell.h"
#import "RAMCollectionAuxView.h"

static NSString *const CellIdentifier = @"MyCell";
static NSString * const HeaderIdentifier = @"HeaderIdentifier";
static NSString * const FooterIdentifier = @"FooterIdentifier";


@interface SchoolCounselViewController () <UICollectionViewDataSource, UICollectionViewDelegate, RAMCollectionViewFlemishBondLayoutDelegate>

@property (retain, nonatomic) NSMutableArray *list;
@property (retain, nonatomic) ASIFormDataRequest *requestCountryList;

@property (nonatomic, strong) RAMCollectionViewFlemishBondLayout *collectionViewLayout;
@property (nonatomic, retain) UICollectionView *collectionView;

@end

@implementation SchoolCounselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self requestCountrys];
    self.title = @"院校库";
//    [self buildRightButton];
}

- (void)dealloc {
    RELEASE_SAFELY(_requestCountryList);
    RELEASE_SAFELY(_list);
    [super dealloc];
}

#pragma mark - Setup
- (void)setup
{
    self.collectionViewLayout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    self.collectionViewLayout.delegate = self;
    self.collectionViewLayout.numberOfElements = 3;
    self.collectionViewLayout.highlightedCellHeight = 120.f;
    self.collectionViewLayout.highlightedCellWidth = 160.f;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:self.collectionViewLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[RAMCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [_collectionView registerClass:[RAMCollectionAuxView class] forSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind withReuseIdentifier:HeaderIdentifier];
    [_collectionView registerClass:[RAMCollectionAuxView class] forSupplementaryViewOfKind:RAMCollectionViewFlemishBondFooterKind withReuseIdentifier:FooterIdentifier];
    
    [self.view addSubview:_collectionView];
}

- (UIColor*) colorForNumber:(NSInteger)num {
    return [UIColor colorWithHue:((200 * num * 2) % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RAMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *name = self.list[indexPath.row][@"cn_name"];
    
    [cell configureCellWithIndexPath:name];
    cell.backgroundColor = [self colorForNumber:indexPath.row];
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionReusableView *titleView;
    
    if (kind == RAMCollectionViewFlemishBondHeaderKind) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        ((RAMCollectionAuxView *)titleView).label.text = @"Header";
    } else if (kind == RAMCollectionViewFlemishBondFooterKind) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        ((RAMCollectionAuxView *)titleView).label.text = @"Footer";
    }
    
    return titleView;
}

#pragma mark - RAMCollectionViewVunityLayoutDelegate

- (RAMCollectionViewFlemishBondLayoutGroupDirection)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout highlightedCellDirectionForGroup:(NSInteger)group atIndexPath:(NSIndexPath *)indexPath
{
    RAMCollectionViewFlemishBondLayoutGroupDirection direction;
    
    if (indexPath.row % 2) {
        direction = RAMCollectionViewFlemishBondLayoutGroupDirectionRight;
    } else {
        direction = RAMCollectionViewFlemishBondLayoutGroupDirectionLeft;
    }
    return direction;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *countryId = self.list[indexPath.row][@"cn_id"];
    SchoolListViewController *listViewController = [[[SchoolListViewController alloc] initWithCountryId:countryId] autorelease];
    listViewController.cuntry = self.list[indexPath.row][@"cn_name"];
    listViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listViewController animated:YES];
}

- (void)buildRightButton {
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)] autorelease];
    [button setBackgroundImage:[UIImage imageNamed:@"n_search_iv"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"n_search_iv"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)rightButtonClicked {
    SearchViewController *loginViewController = [[[SearchViewController alloc] init] autorelease];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        self.list = result[@"list"];
        [self.collectionView reloadData];
    }else {
        [self showErrorViewAnimated:YES];
    }
}

- (void)errorViewButtonDidPress {
    [self hideErrorViewAnimated:YES];
    [self requestCountrys];
}

- (void)requestCountrys {
    [self showLoadingViewAnimated:YES];
    [self.list removeAllObjects];
    self.requestCountryList = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestCountryList setRequestMethod:HTTP_TYPE];
    [self.requestCountryList setPostValue:@11 forKey:@"act"];
    self.requestCountryList.delegate = self;
    [self.requestCountryList startAsynchronous];
}


@end


