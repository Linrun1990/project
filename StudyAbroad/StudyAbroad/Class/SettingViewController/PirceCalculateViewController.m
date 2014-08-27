//
//  PirceCalculateViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-21.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "PirceCalculateViewController.h"
#import "LookListViewController.h"

@interface PirceCalculateViewController ()
@property (retain, nonatomic) IBOutlet UITextField *pirceNumber;

@end

@implementation PirceCalculateViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"留学费用计算器";
    [self.pirceNumber becomeFirstResponder];
}

- (IBAction)lookSchool:(id)sender {
    if (self.pirceNumber.text.length <= 0) {
        [[Toast makeText:@"请填写金额"] show];
    }else {
        NSNumber *money = [NSNumber numberWithFloat:[self.pirceNumber.text floatValue]];
        LookListViewController *viewcontroller = [[[LookListViewController alloc] initWithMoney:money] autorelease];
        viewcontroller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
    
}

- (void)dealloc {
    [_pirceNumber release];
    [super dealloc];
}
@end
