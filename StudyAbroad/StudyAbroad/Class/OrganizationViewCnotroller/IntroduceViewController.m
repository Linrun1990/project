//
//  IntroduceViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@property (nonatomic, retain) NSString *comment;

@property (retain, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IntroduceViewController

- (id)initWithComment:(NSString *)comment {
    if (self = [super init]) {
        self.comment = comment;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.comment;
}

- (void)dealloc {
    RELEASE_SAFELY(_comment);
    [_textView release];
    [super dealloc];
}

@end
