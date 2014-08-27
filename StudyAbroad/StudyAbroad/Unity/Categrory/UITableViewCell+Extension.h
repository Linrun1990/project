//
//  UITableViewCell+Extension.h
//  InstalledNecessary
//
//  Created by Lin Feihong on 13-10-25.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

@interface UITableViewCell (Extension)

+ (id)dequeOrCreateInTable:(UITableView *)tableView;
+ (id)dequeOrCreateInTable:(UITableView *)tableView ofType:(Class)tp fromNib:(NSString *)nibName withId: (NSString *)reuseId;
+ (id)dequeOrCreateInTable:(UITableView *)tableView withId:(NSString *)reuseId andStyle:(UITableViewCellStyle)style;

+ (id)loadCellOfType:(Class)tp fromNib:(NSString*)nibName withId:(NSString*)reuseId;
+ (id)loadFromNibWithSelectBackgroundColor;
+ (id)loadFromNibWithoutSelectBackgroundColor;
+ (id)loadFromNibWithReuseFlag:(BOOL)toBeReused;

- (void)setSelectedBackgroundImageView:(NSString *)imageName;
- (void)setSelectedBackgroundViewColor:(UIColor *)color;

@end