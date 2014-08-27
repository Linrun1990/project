//
//  LoginViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-7.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTabBar.h"
#import "RegisterViewController.h"
#import "loginSuccessViewController.h"
#import "TabBarControllerFactory.h"

@interface LoginViewController ()
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *registerButton;
@property (retain, nonatomic) ASIFormDataRequest *requestLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.title = @"沃留学";
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _scrollView.height = SCREEN_HEIGHT - 260;
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _scrollView.height = SCREEN_HEIGHT - 50;
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) animated:NO];
}

- (IBAction)endEditingView:(id)sender {
    [self.view endEditing:YES];
}


- (void)dealloc {
    [_scrollView release];
    [_userNameTextfield release];
    [_passwordTextfield release];
    [_loginButton release];
    [_registerButton release];
    [super dealloc];
}

- (IBAction)login:(id)sender {
    if (self.userNameTextfield.text.length <= 0 || self.passwordTextfield.text.length <= 0) {
        [[Toast makeText:@"用户名或者密码不能为空!"] show];
    }else {
        [self login];
        [self.view endEditing:YES];
    }
}

- (IBAction)register:(id)sender {
    [self.view endEditing:YES];
    RegisterViewController *registerViewController = [[[RegisterViewController alloc] init] autorelease];
    registerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        [[Toast makeText:@"登入成功!"] show];
        [[NSUserDefaults standardUserDefaults] setObject:result[@"uid"] forKey:USER_ID];
        [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextfield.text forKey:USER_Name];
        loginSuccessViewController *viewController = [[[loginSuccessViewController alloc] init] autorelease];
//        viewController.hidesBottomBarWhenPushed = NO;
//        [self.navigationController pushViewController:viewController animated:YES];

        if ([self.navigationController.viewControllers count] == 1) {
            
            [self.navigationController pushViewController:viewController animated:YES];
        }else {
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TabBarConfig" ofType:@"plist"];
            NSDictionary *configInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
//            self.tabBarController.viewControllers = nil;
            self.tabBarController.viewControllers = [TabBarControllerFactory viewControllersWithComfig:configInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (errorCode == 3001) {
        [[Toast makeText:@"用户不存在!"] show];
    }else if (errorCode == 3002) {
        [[Toast makeText:@"密码错误!"] show];
    }else {
        [[Toast makeText:@"网络错误!"] show];
    }
}

- (void)login {
    self.requestLogin = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestLogin setRequestMethod:HTTP_TYPE];
    [self.requestLogin setPostValue:@3 forKey:@"act"];
    [self.requestLogin setPostValue:self.userNameTextfield.text forKey:@"username"];
    [self.requestLogin setPostValue:self.passwordTextfield.text forKey:@"password"];
    self.requestLogin.delegate = self;
    [self.requestLogin startAsynchronous];
}

@end
