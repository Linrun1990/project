//
//  CommentViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-19.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CommentViewController.h"
#import "ASIFormDataRequest.h"

@interface CommentViewController ()

@property (retain, nonatomic) IBOutlet UITextView *content;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, assign) NSInteger starNumber;
@property (retain, nonatomic) IBOutlet UILabel *flagLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) ASIFormDataRequest *requestComment;
@property (nonatomic, assign) NSInteger schoolId;

@end

@implementation CommentViewController

- (id)initWithSchoolId:(NSInteger)schoolId {
    if (self = [super init]) {
        self.schoolId = schoolId;
        self.starNumber = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.content setBorderLineWithColor:[UIColor blackColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)buttonCLicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    self.starNumber = button.tag + 1;
    for (UIButton *btn in self.buttons) {
        if (btn.tag <= button.tag) {
            [btn setImage:[UIImage imageNamed:@"big_star_selected"] forState:UIControlStateNormal];
        }else {
            [btn setImage:[UIImage imageNamed:@"big_star_normal"] forState:UIControlStateNormal];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.flagLabel.hidden = textView.text.length > 0;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _scrollView.height = SCREEN_HEIGHT - 260;
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _scrollView.height = SCREEN_HEIGHT - 50;
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) animated:NO];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self hideLoadingViewAnimated:YES];
    NSDictionary *result = [self parseResponseData:request];
    NSInteger errorCode = [result[@"error"] intValue];
    if (errorCode == 0) {
        [[Toast makeText:@"提交成功"] show];
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    if (self.content.text.length == 0) {
        [[Toast makeText:@"评论不能为空"] show];
    }else if (self.starNumber == -1) {
        [[Toast makeText:@"请进行星级评价"] show];
    }else {
        [self requestReport];
    }
}

- (void)requestReport {
    self.requestComment = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.requestComment setRequestMethod:HTTP_TYPE];
    [self.requestComment setPostValue:@14 forKey:@"act"];
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    [self.requestComment setPostValue:userId forKey:@"uid"];
    [self.requestComment setPostValue:[NSNumber numberWithInt:self.schoolId] forKey:@"lx_id"];
    [self.requestComment setPostValue:self.content.text forKey:@"comment"];
    [self.requestComment setPostValue:[NSNumber numberWithInt:self.starNumber] forKey:@"star"];
    self.requestComment.delegate = self;
    [self.requestComment startAsynchronous];
}


- (void)dealloc {
    [_content release];
    [_submitButton release];
    [_buttons release];
    [_flagLabel release];
    [_scrollView release];
    RELEASE_SAFELY(_requestComment);
    [super dealloc];
}
@end
