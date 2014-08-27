//
//  CheckViewController.m
//  StudyAbroad
//
//  Created by LR on 14-8-10.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

#import "CheckViewController.h"
#import "CheckViewTableViewCell.h"

@interface CheckViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *commentArray;


@end

@implementation CheckViewController

- (id)initWithCommentList:(NSArray *)commentArray {
    if (self = [super init]) {
        if ([commentArray isKindOfClass:[NSArray class]]) {
            self.commentArray = commentArray;
        }else {
            self.commentArray = [NSArray array];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CheckViewTableViewCell";
    CheckViewTableViewCell *cell = (CheckViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [CheckViewTableViewCell loadFromNIB];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell reloadCell:self.commentArray[indexPath.row]];
    return cell;
}

- (void)dealloc {
    [_tableView release];
    RELEASE_SAFELY(_commentArray);
    [super dealloc];
}
@end
