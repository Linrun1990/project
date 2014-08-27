//
//  DetailViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (retain, nonatomic) IBOutlet UITextView *detail;
@property (retain, nonatomic) NSString *detaiString;

@end

@implementation DetailViewController


- (id)initWithDetai:(NSString *)detail {
    if (self = [super init]) {
        self.detaiString = detail;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detail.text = self.detaiString;
}

- (void)dealloc {
//    [_detailLabel release];
    [_detail release];
    [super dealloc];
}
@end
