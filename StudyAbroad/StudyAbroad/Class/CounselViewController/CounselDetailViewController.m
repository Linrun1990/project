//
//  CounselDetailViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CounselDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomTabBar.h"

@interface CounselDetailViewController ()

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageView;                             
@property (retain, nonatomic) IBOutlet UITextView *describeLabel;
@property (retain, nonatomic) NSNumber *newsId;
@property (retain, nonatomic) ASIFormDataRequest *requestNewDetail;

@end

@implementation CounselDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestDetail];
    self.title = @"沃留学";
//    [self buildRightButton];
}

- (void)dealloc {
    [_titleLabel release];
    [_iconImageView release];            
    [_describeLabel release];
    RELEASE_SAFELY(_newsId);
    [super dealloc];
}

- (id)initWithNewsId:(NSNumber *)newsId {
    if (self = [super init]) {
        self.newsId = newsId;
    }
    return self;
}

- (void)reloadView:(NSString *)title icon:(NSString *)icon describe:(NSString *)describe {
    self.titleLabel.text = title;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    self.describeLabel.text = describe;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        NSDictionary *info = result[@"list"];
        NSString *title = info[@"news_title"];
        NSString *icon = info[@"news_picurl"];
        NSString *content = info[@"news_content"];
        [self reloadView:title icon:icon describe:content];
    }else {
        [self showErrorViewAnimated:YES];
    }
}

- (void)errorViewButtonDidPress {
    [self hideErrorViewAnimated:YES];
    [self requestDetail];
}

- (void)requestDetail {
    [self showLoadingViewAnimated:YES];
    self.requestNewDetail = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestNewDetail setRequestMethod:HTTP_TYPE];
    [self.requestNewDetail setPostValue:@21 forKey:@"act"];
    [self.requestNewDetail setPostValue:self.newsId forKey:@"news_id"];
    self.requestNewDetail.delegate = self;
    [self.requestNewDetail startAsynchronous];
}

@end
