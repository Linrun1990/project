//
//  OrganizationDetailViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-7.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "OrganizationDetailViewController.h"
#import "DJStarRatingControl.h"
#import "TopMenuBarController.h"
#import "CounselSubViewController.h"
#import "IntroduceViewController.h"
#import "CheckViewController.h"
#import "CustomTabBar.h"
#import "CommentViewController.h"
#import "ReportViewControllerViewController.h"
#import "LoginViewController.h"

@interface OrganizationDetailViewController ()

@property (retain, nonatomic) IBOutlet UIView *content;
@property (retain, nonatomic) IBOutlet UIImageView *leftImageView;
@property (retain, nonatomic) IBOutlet UIImageView *topImgeView;

@property (retain, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (retain, nonatomic) IBOutlet UIButton *reportButton;
@property (retain, nonatomic) IBOutlet UIButton *favoriteButton;
@property (retain, nonatomic) IBOutlet UIButton *phoneButton;

@property (retain, nonatomic) DJStarRatingControl *starRatingController;
@property (retain, nonatomic) TopMenuBarController *topMenuBarController;

@property (retain, nonatomic) NSNumber *organizationId;
@property (retain, nonatomic) ASIFormDataRequest *requestDetail;
@property (retain, nonatomic) ASIFormDataRequest *requestAddFavorite;
@property (retain, nonatomic) ASIFormDataRequest *requestCancelFavorite;
@property (retain, nonatomic) ASIFormDataRequest *requestReport;
@property (retain, nonatomic) NSString *phoneNumber;
@property (retain, nonatomic) NSDictionary *detailModel;
@property (retain, nonatomic) NSArray *commentList;

@property (retain, nonatomic) IBOutlet UIButton *thinkButton;
@end

@implementation OrganizationDetailViewController

- (id)initWithOrganizationId:(NSNumber *)id {
    if(self = [super init]) {
        self.organizationId = id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestOrganizationDetail];
    [self buildStarRatingController];
    [self buildRightButton];
    [self.thinkButton setCornerRadius:4.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    if (userId != nil) {
        [self.thinkButton setTitle:@"评论" forState:UIControlStateNormal];
    }else {
        [self.thinkButton setTitle:@"登入后进行评论" forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_leftImageView);
    RELEASE_SAFELY(_topImgeView);
    RELEASE_SAFELY(_bottomImageView);
    RELEASE_SAFELY(_reportButton);
    RELEASE_SAFELY(_favoriteButton);
    RELEASE_SAFELY(_phoneButton);
    RELEASE_SAFELY(_starRatingController);
    RELEASE_SAFELY(_topMenuBarController);
    RELEASE_SAFELY(_organizationId);
    RELEASE_SAFELY(_requestDetail);
    RELEASE_SAFELY(_requestAddFavorite);
    RELEASE_SAFELY(_requestCancelFavorite);
    RELEASE_SAFELY(_phoneNumber);
    RELEASE_SAFELY(_detailModel);
    RELEASE_SAFELY(_requestReport);
    RELEASE_SAFELY(_commentList);
    [_thinkButton release];
    [super dealloc];
}

- (void)buildStarRatingController {
    _starRatingController = [[DJStarRatingControl alloc] initWithFrame:CGRectMake(72, 16, 125, 16) andStars:5 isFractional:YES defaultStar:@"big_star_normal.png" highlightedStar:@"big_star_selected.png"];
    _starRatingController.enabled = NO;
    [self.content addSubview:_starRatingController];
}

- (void)buildTopMenuBarController {
    NSDictionary *detail = self.detailModel[@"list"];
    NSArray *titles = [NSArray arrayWithObjects:@"简介", @"评价", nil];
    IntroduceViewController *introceViwController = [[[IntroduceViewController alloc] initWithComment:detail[@"lx_describe"]] autorelease];
    CheckViewController *checkViewController = [[[CheckViewController alloc] initWithCommentList:self.commentList] autorelease];
    NSArray *viewControllers = [NSArray arrayWithObjects:introceViwController, checkViewController, nil];
    self.topMenuBarController = [[[TopMenuBarController alloc] initWithItemTitles:titles viewControllers:viewControllers] autorelease];
    float height = SCREEN_HEIGHT > 480 ? 180 : 150;
    self.topMenuBarController.view.frame = CGRectMake(20, 45, self.content.width - 40, height);
    self.topMenuBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIView *menuBarBackgroundView = [self buildMenuBarBackgroundView];
    self.topMenuBarController.menuBar.backgroundView = menuBarBackgroundView;
    UIView *menuIndicatorView = [self buildMenuBarIndicatorView];
    self.topMenuBarController.menuBar.indicatorView = menuIndicatorView;
    self.topMenuBarController.menuBar.itemNormalColor = [UIColor blackColor];
    self.topMenuBarController.menuBar.itemSelectedColor = [UIColor blackColor];
    [self.content addSubview:self.topMenuBarController.view];
    [self addChildViewController:self.topMenuBarController];
}

- (IBAction)reportClicked:(id)sender {
    ReportViewControllerViewController *viewCnotroller = [[[ReportViewControllerViewController alloc] init] autorelease];
    viewCnotroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewCnotroller animated:YES];
}

- (IBAction)favoriteClicked:(id)sender {
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    if (userId != nil) {
        if (!self.favoriteButton.selected) {
            [self favorite:@15];
        }else {
            [self favorite:@17];
        }
    }else {
        [self showLoginAlertView:@"提示" message:@"请先登入再进行收藏"];
    }
}

- (IBAction)phoneClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.phoneNumber]]];
}

- (IBAction)introduceClicked:(id)sender {
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    if (userId != nil) {
        NSDictionary *info = self.detailModel[@"list"];
        CommentViewController *commentViewController = [[[CommentViewController alloc] initWithSchoolId:[info[@"lx_id"] intValue]] autorelease];
        commentViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentViewController animated:YES];
    }else {
        [self showLoginAlertView:@"提示" message:@"请先登入再进行评论"];
    }
}

- (UIView *)buildMenuBarBackgroundView {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 35.0)] autorelease];
    view.backgroundColor = RGB(231, 231, 231);
    [view setCornerRadius:5.0];
    return view;
}

- (UIView *)buildMenuBarIndicatorView {
    UIView *view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor clearColor];
    UIView *indicatorView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 35)] autorelease];
    indicatorView.backgroundColor = RGB(133, 133, 133);
    [indicatorView setCornerRadius:5.0];
    [view addSubview:indicatorView];
    return view;
    return nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (request == self.requestDetail) {
        if (errorCode == 0) {
            self.detailModel = result;
            [self reloadView];
            [self buildTopMenuBarController];
        }else {
            [self showErrorViewAnimated:YES];
        }
    }else if (request == self.requestAddFavorite) {
        if (errorCode == 0) {
            [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"big_star_selected.png"] forState:UIControlStateNormal];
            self.favoriteButton.selected = YES;
            [[Toast makeText:@"收藏成功"] show];
        }else if (errorCode == 4001) {
            [[Toast makeText:@"已经收藏过了!"] show];
        }
    }else if (request == self.requestCancelFavorite) {
        if (errorCode == 0) {
            [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"big_star_normal.png"] forState:UIControlStateNormal];
            self.favoriteButton.selected = NO;
        }
    }
    
}

- (void)errorViewButtonDidPress {
    [self hideErrorViewAnimated:YES];
    [self requestOrganizationDetail];
}

- (void)requestOrganizationDetail {
    [self showLoadingViewAnimated:YES];
    self.requestDetail = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestDetail setRequestMethod:HTTP_TYPE];
    [self.requestDetail setPostValue:@10 forKey:@"act"];
    [self.requestDetail setPostValue:self.organizationId forKey:@"id"];
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    if (userId != nil) {
        [self.requestDetail setPostValue:userId forKey:@"uid"];
    }
    self.requestDetail.delegate = self;
    [self.requestDetail startAsynchronous];
}

- (void)reloadView {
    NSDictionary *info = self.detailModel[@"list"];
    self.commentList = self.detailModel[@"comment"];
    self.phoneNumber = info[@"lx_phone"];
    [self.leftImageView setImageWithURL:[NSURL URLWithString:info[@"lx_realpicurl1"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    [self.bottomImageView setImageWithURL:[NSURL URLWithString:info[@"lx_realpicurl3"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    [self.topImgeView setImageWithURL:[NSURL URLWithString:info[@"lx_realpicurl2"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    [self.starRatingController setRating:[info[@"lx_star"] floatValue]];
    NSString *name = [info[@"fav_id"] intValue] == 0 ? @"big_star_normal.png" : @"big_star_selected.png";
    self.favoriteButton.selected = [info[@"fav_id"] intValue] == 0 ? NO : YES;
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

- (void)favorite:(NSNumber *)act {
    if ([act intValue] == 15) {
        self.requestAddFavorite = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
        [self.requestAddFavorite setRequestMethod:HTTP_TYPE];
        [self.requestAddFavorite setPostValue:act forKey:@"act"];
        NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
        NSDictionary *detail = self.detailModel[@"list"];
        NSNumber *id = detail[@"lx_id"];
        [self.requestAddFavorite setPostValue:userId forKey:@"uid"];
        [self.requestAddFavorite setPostValue:id forKey:@"lx_id"];
        self.requestAddFavorite.delegate = self;
        [self.requestAddFavorite startAsynchronous];
    }else {
        self.requestCancelFavorite = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
        [self.requestCancelFavorite setRequestMethod:HTTP_TYPE];
        [self.requestCancelFavorite setPostValue:act forKey:@"act"];
        NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
        NSDictionary *detail = self.detailModel[@"list"];
        NSNumber *id = detail[@"lx_id"];
        [self.requestCancelFavorite setPostValue:userId forKey:@"uid"];
        [self.requestCancelFavorite setPostValue:id forKey:@"lx_id"];
        self.requestCancelFavorite.delegate = self;
        [self.requestCancelFavorite startAsynchronous];
    }
    
}

- (void)showLoginAlertView:(NSString *)title message:(NSString *)message {
    UIAlertView *view = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        LoginViewController *viewController = [[[LoginViewController alloc] init] autorelease];
        viewController.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end


