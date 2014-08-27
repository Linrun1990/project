//
//  ReportViewControllerViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-20.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#define DROP_DOWN_ICON_NAME                     @"arrow_down.png"
#define DROP_UP_ICON_NAME                       @"arrow_up.png"

#define ADJUST_HEIGTH_KEYBOARD_SHOW   180
#define MAX_ADVICES_LENGHT       250
#define DEFAULT_FEEDBACK_TYPE    -1

#import "ReportViewControllerViewController.h"
#import "DropDownListTableViewCell.h"
#import "ASIFormDataRequest.h"

@interface ReportViewControllerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIControl *chooseType;
@property (retain, nonatomic) IBOutlet UITextView *content;
@property (retain, nonatomic) IBOutlet UIButton *submit;
@property (retain, nonatomic) IBOutlet UILabel *flagLabel;
@property (nonatomic, retain) UITableView *dropTableView;
@property (nonatomic, retain) NSArray *dropDownConfig;
@property (nonatomic, assign) NSInteger feedbackMark;
@property (retain, nonatomic) IBOutlet UIImageView *promptImageView;
@property (retain, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (retain, nonatomic) ASIFormDataRequest *submitRequest;

@end

@implementation ReportViewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _feedbackMark = -1;
    [self buildDropdownTableView];
    [self setupChooseTypeControl];
    [self buildDropdownList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_scrollView release];
    [_chooseType release];
    [_content release];
    [_submit release];
    [_flagLabel release];
    [_promptImageView release];
    [_typeNameLabel release];
    RELEASE_SAFELY(_submitRequest);
    RELEASE_SAFELY(_dropDownConfig);
    RELEASE_SAFELY(_dropTableView);
    [super dealloc];
}

- (IBAction)submit:(id)sender {
    if (self.feedbackMark == -1) {
        [[Toast makeText:@"请选择举报类型"] show];
    }else if (self.content.text.length == 0) {
        [[Toast makeText:@"描述不能为空"] show];
    }else {
        [self requestReport];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _scrollView.height = SCREEN_HEIGHT - 260;
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _scrollView.height = SCREEN_HEIGHT - 50;
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) animated:NO];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.flagLabel.hidden = textView.text.length > 0;
}

- (void)buildDropdownList {
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"DJCustomSupportList" ofType:@"plist"];
    self.dropDownConfig = [NSArray arrayWithContentsOfFile:plistFilePath];
    [self reloadData];
}
- (IBAction)touchScreen:(id)sender {
    _dropTableView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)reloadData {
    self.dropTableView.height = [self.dropDownConfig count] * _dropTableView.rowHeight;
    [self.dropTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.dropDownConfig count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DropDownListTableViewCell";
    DropDownListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [DropDownListTableViewCell loadFromNIB];
    }
    cell.titleLabel.text = self.dropDownConfig[indexPath.row][@"name"];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.feedbackMark = [self.dropDownConfig[indexPath.row][@"id"] intValue];
    self.dropTableView.hidden = YES;
    [self.promptImageView setImage:[UIImage imageNamed:DROP_DOWN_ICON_NAME]];
    [self.typeNameLabel setText:self.dropDownConfig[indexPath.row][@"name"]];
}

- (void)buildDropdownTableView {
    self.dropTableView = [[[UITableView alloc] initWithFrame:CGRectMake(6, 76, 153, 0)] autorelease];
    self.dropTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dropTableView.rowHeight = 32.0;
    self.dropTableView.delegate = self;
    self.dropTableView.dataSource = self;
    self.dropTableView.scrollEnabled = NO;
    _dropTableView.backgroundColor = RGB(241.0, 241.0, 241.0);
    self.dropTableView.hidden = YES;
    [self.scrollView addSubview:_dropTableView];
}

- (void)setupChooseTypeControl {
    [self.chooseType addTarget:self action:@selector(chooseQuestionType:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseType setBorderLineWithColor:RGB(216.0, 216.0, 216.0)];
}

- (void)chooseQuestionType:(UIControl *)sender {
    self.dropTableView.hidden = !self.dropTableView.hidden;
    NSString *dropDownIconName = !self.dropTableView.hidden ? DROP_UP_ICON_NAME : DROP_DOWN_ICON_NAME;
    [self.promptImageView setImage:[UIImage imageNamed:dropDownIconName]];
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

- (void)requestReport {
    self.submitRequest = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:CONNECT_URL]] autorelease];
    [self.submitRequest setRequestMethod:HTTP_TYPE];
    [self.submitRequest setPostValue:@18 forKey:@"act"];
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    [self.submitRequest setPostValue:userId forKey:@"uid"];
    [self.submitRequest setPostValue:[NSNumber numberWithInt:self.feedbackMark] forKey:@"type"];
    [self.submitRequest setPostValue:self.content.text forKey:@"describe"];
    self.submitRequest.delegate = self;
    [self.submitRequest startAsynchronous];
}
    
@end
