//
//  MainViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-5.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "MainViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomButton.h"
#import "CounselViewController.h"
#import "OrganizationViewController.h"
#import "ToolViewController.h"
#import "LoginViewController.h"
#import "SchoolCounselViewController.h"
#import "loginSuccessViewController.h"
#import "SearchViewController.h"

@interface MainViewController ()

@property (retain, nonatomic) IBOutlet CustomButton *studyAbroadCounselButton;
@property (retain, nonatomic) IBOutlet CustomButton *studyAbroadOrganizationButton;
@property (retain, nonatomic) IBOutlet CustomButton *schoolsCounselButton;
@property (retain, nonatomic) IBOutlet CustomButton *studyAbroadToolButton;
@property (retain, nonatomic) IBOutlet CustomButton *mineStudyAbroadButton;
@property (retain, nonatomic) IBOutlet CustomButton *aboutMineButton;


- (void)reloadPageView:(NSArray *)carouseInfo;
- (void)reloadButtons;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"carouselConfig" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    [self reloadPageView:array];
    [self reloadButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.carouselPageView startPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.carouselPageView endPlay];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    RELEASE_SAFELY(_carouselPageView);
    RELEASE_SAFELY(_studyAbroadCounselButton);
    RELEASE_SAFELY(_studyAbroadOrganizationButton);
    RELEASE_SAFELY(_schoolsCounselButton);
    RELEASE_SAFELY(_studyAbroadToolButton);
    RELEASE_SAFELY(_mineStudyAbroadButton);
    RELEASE_SAFELY(_aboutMineButton);
    [super dealloc];
}

- (void)reloadButtons {
    [self.studyAbroadCounselButton reloadWithImage:@"news.png" title:@"留学咨询"];
    [self.self.studyAbroadOrganizationButton reloadWithImage:@"jigou.png" title:@"留学机构"];
    [self.schoolsCounselButton reloadWithImage:@"account_tab.png" title:@"院校咨询"];
    [self.studyAbroadToolButton reloadWithImage:@"account.png" title:@"留学工具"];
    [self.mineStudyAbroadButton reloadWithImage:@"account.png" title:@"我的留学"];
    [self.aboutMineButton reloadWithImage:@"account.png" title:@"关于我们"];
}

- (IBAction)showCounselViewController:(id)sender {
    CounselViewController *counselViewController = [[[CounselViewController alloc] init] autorelease];
    [self.navigationController pushViewController:counselViewController animated:YES];
}

- (IBAction)showOrganizationViewController:(id)sender {
    OrganizationViewController *organizationViewController = [[[OrganizationViewController alloc] init] autorelease];
    [self.navigationController pushViewController:organizationViewController animated:YES];
}

- (IBAction)showSchoolCounselViewController:(id)sender {
    SchoolCounselViewController *schoolViewController = [[[SchoolCounselViewController alloc] init] autorelease];
    [self.navigationController pushViewController:schoolViewController animated:YES];
}

- (IBAction)showToolViewController:(id)sender {
    ToolViewController *toolViewController = [[[ToolViewController alloc] init] autorelease];
    [self.navigationController pushViewController:toolViewController animated:YES];
}

- (IBAction)mineViewController:(id)sender {
    LoginViewController *loginViewController = [[[LoginViewController alloc] init] autorelease];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
//    loginSuccessViewController *loginViewController = [[[loginSuccessViewController alloc] init] autorelease];
//    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)showAboutViewController:(id)sender {
    NSLog(@"showCounselViewController");
}

- (void)reloadPageView:(NSArray *)carouseInfo {
    if (![carouseInfo isKindOfClass:NSArray.class]) {
        return;
    }
    self.carouselPageView.count = carouseInfo.count;
    __block MainViewController *selfTemp = self;
    self.carouselPageView.didTap = ^(NSNumber *index){
        NSDictionary *item = carouseInfo[index.intValue];
        NSString *url = item[@"url"];
        NSLog(@"====Tap carousel =======");
        };
    [self.carouselPageView updateWithView:^UIView *(NSNumber *index, CGRect frame) {
        NSDictionary *item = carouseInfo[[index intValue]];
        NSString *imageUrl = item[@"image"];
        UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"scrollView"]];
        imageView.frame = frame;
        return imageView;
    }];
}

@end






