//
//  SchoolDetailViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SchoolDetailViewController.h"
#import "CustomTabBar.h"
#import "DetailViewController.h"

@interface SchoolDetailViewController ()

@property (retain, nonatomic) IBOutlet UIImageView *bigIconImageView;
@property (retain, nonatomic) IBOutlet UIImageView *smallIconImageView;
@property (retain, nonatomic) IBOutlet UILabel *shcoolNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *englishNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *countryLabel;
@property (retain, nonatomic) IBOutlet UILabel *schoolTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *buildTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *ratingLabel;
@property (retain, nonatomic) IBOutlet UILabel *numbersLabel;

@property (retain, nonatomic) IBOutlet UILabel *schoolAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *schoolWebLabel;

@property (retain, nonatomic) NSNumber *schoolId;
@property (retain, nonatomic) ASIFormDataRequest *requestSchoolDetail;
@property (retain, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) NSDictionary *model;

@end

@implementation SchoolDetailViewController

- (id)initWithSchoolId:(NSDictionary *)info {
    if (self = [super init]) {
        self.model = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沃留学";
    self.schoolId = self.model[@"co_id"];
    [self requestDetail];
    [self.topView setBorderLineWithColor:RGB(163, 163, 163)];
    [self.bottomView setBorderLineWithColor:RGB(163, 163, 163)];
    [self.topView setCornerRadius:5.0];
    [self.bottomView setCornerRadius:5.0];
}

- (void)dealloc {
    RELEASE_SAFELY(_model);
    [_bigIconImageView release];
    [_smallIconImageView release];
    [_shcoolNameLabel release];
    [_englishNameLabel release];
    [_countryLabel release];
    [_schoolTypeLabel release];
    [_buildTimeLabel release];
    [_ratingLabel release];
    [_schoolAddressLabel release];
    [_schoolWebLabel release];
    RELEASE_SAFELY(_schoolId);
    RELEASE_SAFELY(_requestSchoolDetail);
    [super dealloc];
}

- (IBAction)showSchoolDetail:(id)sender {
    DetailViewController *viewController = [[[DetailViewController alloc] initWithDetai:self.model[@"co_describe"]] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)showSchoolSchdues:(id)sender {
    DetailViewController *viewController = [[[DetailViewController alloc] initWithDetai:self.model[@"co_study"]] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        NSArray *detail = result[@"list"];
        [self reloadView:detail[0]];
    }else {
        [[Toast makeText:NETWORK_ERROR] show];
    }

}

- (void)requestDetail {
    self.requestSchoolDetail = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestSchoolDetail setRequestMethod:HTTP_TYPE];
    [self.requestSchoolDetail setPostValue:@13 forKey:@"act"];
    [self.requestSchoolDetail setPostValue:self.schoolId forKey:@"id"];
    self.requestSchoolDetail.delegate = self;
    [self.requestSchoolDetail startAsynchronous];
}

- (void)reloadView:(NSDictionary *)info {
    [self.bigIconImageView setImageWithURL:[NSURL URLWithString:info[@"co_picurl"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    self.shcoolNameLabel.text = info[@"co_name"];
    self.englishNameLabel.text = info[@"co_enname"];
    self.countryLabel.text = [NSString stringWithFormat:@"所属国家: %@  私利", self.model[@"guojia"]];
    self.schoolTypeLabel.text = [NSString stringWithFormat:@"学校类型: %@", self.model[@"leixing"]];
    self.buildTimeLabel.text = [NSString stringWithFormat:@"创建时间: %@", info[@"co_buildtime"]];
    self.ratingLabel.text = [NSString stringWithFormat:@"全球排名: %@", info[@"co_rank"]];
    self.numbersLabel.text = [NSString stringWithFormat:@"学生人数: %@", info[@"co_student"]];
    self.schoolAddressLabel.text = [NSString stringWithFormat:@"院校地址: %@", info[@"co_address"]];
    self.schoolWebLabel.text = [NSString stringWithFormat:@"官方网站: %@", info[@"co_website"]];
}

@end




