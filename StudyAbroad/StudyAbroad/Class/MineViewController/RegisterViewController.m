//
//  RegisterViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-12.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomTabBar.h"
#import "loginSuccessViewController.h"

@interface RegisterViewController ()

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UITextField *userNameLabel;
@property (retain, nonatomic) IBOutlet UITextField *mailBoxLabel;
@property (retain, nonatomic) IBOutlet UITextField *phoneLabel;

@property (retain, nonatomic) ASIFormDataRequest *requestRegister;

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沃留学";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_scrollView release];
    [_userNameLabel release];
    [_mailBoxLabel release];
    [_phoneLabel release];
    RELEASE_SAFELY(_requestRegister);
    [super dealloc];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _scrollView.height = SCREEN_HEIGHT - 260;
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _scrollView.height = SCREEN_HEIGHT - 50;
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) animated:NO];
}
- (IBAction)register:(id)sender {
    if(self.userNameLabel.text.length <= 0 || self.mailBoxLabel.text.length <= 0 || self.phoneLabel.text.length <= 0) {
        [[Toast makeText:@"信息填写不完整!"] show];
        
    }else {
        [self doRegister];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *data = request.responseData;
    NSString *response = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    response = JSON_EXCLUDE_NULL(response);
    NSMutableDictionary *result = [response objectFromJSONString];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        [[Toast makeText:@"注册成功!"] show];
        loginSuccessViewController *viewController = [[[loginSuccessViewController alloc] init] autorelease];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (errorCode == 20001) {
        [[Toast makeText:@"用户名为空!"] show];
    }else if (errorCode == 20002) {
        [[Toast makeText:@"手机号码格式错误!"] show];
    }else if (errorCode == 20003) {
        [[Toast makeText:@"密码太简单!"] show];
    }else if (errorCode == 20004) {
        [[Toast makeText:@"用户名不存在!"] show];
    }else {
        [[Toast makeText:NETWORK_ERROR] show];
    }
    
}

- (void)doRegister {
    self.requestRegister = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestRegister setRequestMethod:HTTP_TYPE];
    [self.requestRegister setPostValue:@2 forKey:@"act"];
    [self.requestRegister setPostValue:self.userNameLabel.text forKey:@"username"];
    [self.requestRegister setPostValue:self.mailBoxLabel.text forKey:@"password"];
    [self.requestRegister setPostValue:self.phoneLabel.text forKey:@"phone"];
    self.requestRegister.delegate = self;
    [self.requestRegister startAsynchronous];
}

@end










