//
//  ToolViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-7.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "ToolViewController.h"
#import "CustomButton.h"
#import "CustomTabBar.h"
#import "UIView+Convenience.h"

@interface ToolViewController ()

@property (retain, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation ToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [_backgroundView release];
    [super dealloc];
}

- (IBAction)showTimeCalculateTable:(id)sender {
    NSLog(@"showTimeCalculateTable");
}

- (IBAction)showPayTabel:(id)sender {
     NSLog(@"showTimeCalculateTable");
}
- (IBAction)showViasaTable:(id)sender {
     NSLog(@"showTimeCalculateTable");
}
- (IBAction)showCertificationTable:(id)sender {
     NSLog(@"showTimeCalculateTable");
}

@end

