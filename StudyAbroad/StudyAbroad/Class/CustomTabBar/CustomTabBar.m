//
//  CustomTabBar.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-12.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CustomTabBar.h"
#import "MainViewController.h"

@implementation CustomTabBar


- (IBAction)button5Clicked:(UIButton *)sender {
    MainViewController *view = [[[MainViewController alloc] init] autorelease];
    [self.superViewController.navigationController pushViewController:view animated:YES];
     NSLog(@"button5Clicked");
}
- (IBAction)button4Clicked:(id)sender {
     NSLog(@"button4Clicked");
}
- (IBAction)button3Clicked:(id)sender {
     NSLog(@"button3Clicked");
}
- (IBAction)button2Clicked:(id)sender {
    NSLog(@"button2Clicked");
}

- (IBAction)button1Clicked:(id)sender {
     NSLog(@"button1Clicked");
}
@end
