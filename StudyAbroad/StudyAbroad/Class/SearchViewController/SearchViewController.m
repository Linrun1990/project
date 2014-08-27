//
//  SearchViewController.m
//  StudyAbroad
//
//  Created by tqnd on 14-8-12.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "UISearchBar+Extension.h"

@interface SearchViewController ()

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    [_searchBar release];
    [super dealloc];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (IOS7_OR_LATER) {
        [self searchBarBeginEditing];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (!IOS7_OR_LATER) {
        [self searchBarBeginEditing];
    }
}

- (void)searchBarBeginEditing {
    [_searchBar setShowsCancelButton:YES];
    [_searchBar setupCancelButtonWithTitle:@"取消" normalImageName:@"searchbar_cancel_btn" highlightedImageName:@"searchbar_cancel_btn_click"];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    [_searchViewController searchTextDidChange];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}


@end
