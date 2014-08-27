//
//  SettingViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-19.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SettingViewController.h"
#import "ToolViewController.h"
#import "PirceCalculateViewController.h"
#import "AboutMineViewController.h"

@interface SettingViewController ()

@property (retain, nonatomic) IBOutlet UIButton *aboutMine;
@property (retain, nonatomic) IBOutlet UIButton *pieceCalculate;
@end

@implementation SettingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"沃留学";
    [self.aboutMine setCornerRadius:7.0];
    [self.pieceCalculate setCornerRadius:7.0];

}

- (IBAction)showAboutMe:(id)sender {
    AboutMineViewController *viewController = [[[AboutMineViewController alloc] init] autorelease];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)showPirce:(id)sender {
    PirceCalculateViewController *viewcontroller = [[[PirceCalculateViewController alloc] init] autorelease];
    viewcontroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)dealloc {
    [_aboutMine release];
    [_pieceCalculate release];
    [super dealloc];
}

@end
