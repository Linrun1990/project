//
//  OrganizationTableViewCell.h
//  StudyAbroad
//
//  Created by tqnd on 14-8-6.
//  Copyright (c) 2014年 tqnd. All rights reserved.
//

@interface OrganizationTableViewCell : UITableViewCell

- (void)reloadViewWithInfo:(NSDictionary *)info;

@property (retain, nonatomic) IBOutlet UIButton *callButton;

@end
