//
//  loginSuccessViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-12.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "loginSuccessViewController.h"
#import "CustomTabBar.h"
#import "ASIFormDataRequest.h"
#import "FavoriteListViewController.h"

@interface loginSuccessViewController ()
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *favoriteNumber;
@property (retain, nonatomic) ASIFormDataRequest *requestFavorite;
@property (retain, nonatomic) NSArray *favoriteList;


@end

@implementation loginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沃留学";
    self.favoriteList = [NSArray array];
    [self.favoriteNumber setCornerRadius:3.0];
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_Name];
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self favoriteLists];
}

- (void)dealloc {
    [_iconImageView release];
    [_nameLabel release];
    [_favoriteNumber release];
    RELEASE_SAFELY(_requestFavorite);
    [super dealloc];
}
- (IBAction)showFavoriteList:(id)sender {
    FavoriteListViewController *viewcontroller = [[[FavoriteListViewController alloc] initWithLiat:self.favoriteList] autorelease];
    viewcontroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        self.favoriteNumber.text = result[@"total"];
        if ([result[@"list"] isKindOfClass:[NSArray class]]) {
            self.favoriteList = result[@"list"];
        }else {
            [self.favoriteList release];
            self.favoriteList = [NSArray array];
        }
    }else {
        [[Toast makeText:@"网络错误!"] show];
    }
}

- (void)favoriteLists {
    self.requestFavorite = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestFavorite setRequestMethod:HTTP_TYPE];
    [self.requestFavorite setPostValue:@16 forKey:@"act"];
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    [self.requestFavorite setPostValue:userId forKey:@"uid"];
    [self.requestFavorite setPostValue:[NSNumber numberWithInt:0] forKey:@"star"];
    self.requestFavorite.delegate = self;
    [self.requestFavorite startAsynchronous];
}

@end
