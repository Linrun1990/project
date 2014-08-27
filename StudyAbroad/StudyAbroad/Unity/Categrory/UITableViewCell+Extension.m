//
//  UITableViewCell+Extension.m
//  InstalledNecessary
//
//  Created by Lin Feihong on 13-10-25.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//


@implementation UITableViewCell (Extension)

+ (NSString*)cellID { return [self description]; }

+ (NSString*)nibName { return [self description]; }

+ (id)dequeOrCreateInTable:(UITableView*)tableView ofType:(Class)tp fromNib:(NSString*)nibName withId:(NSString*)reuseId {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
	return cell ? cell : [self loadCellOfType:tp fromNib:nibName withId:reuseId];
}

+ (id)dequeOrCreateInTable:(UITableView *)tableView {
	return [self dequeOrCreateInTable:tableView ofType:self fromNib:[self nibName] withId:[self cellID]];
}

+ (id)dequeOrCreateInTable:(UITableView*)tableView withId:(NSString*)reuseId andStyle:(UITableViewCellStyle)style {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseId] autorelease];
	}
	return cell;
}

+ (id)loadCellOfType:(Class)tp fromNib:(NSString*)nibName withId:(NSString*)reuseId {
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
	for (id object in objects) {
		if ([object isKindOfClass:tp]) {
			UITableViewCell *cell = object;
			[cell setValue:reuseId forKey:@"_reuseIdentifier"];
			return cell;
		}
	}
	[NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one TableViewCell, and its class must be '%@'", nibName, tp];
	return nil;
}

+ (id)loadFromNibWithSelectBackgroundColor {
    UITableViewCell *cell = [self loadCellOfType:self fromNib:[self nibName] withId:[self cellID]];
    [cell setSelectedBackgroundViewColor:RGB(204, 229, 246)];
	return cell;
}

+ (id)loadFromNibWithoutSelectBackgroundColor {
    UITableViewCell *cell = [self loadCellOfType:self fromNib:[self nibName] withId:[self cellID]];
    return cell;
}

+ (id)loadFromNibWithReuseFlag:(BOOL)toBeReused {
	if(toBeReused)
		return [self loadCellOfType:self fromNib:[self nibName] withId:[self cellID]];
	else
		return [self loadCellOfType:self fromNib:[self nibName] withId:@""];		
}

- (void)setSelectedBackgroundImageView:(NSString *)imageName {
    self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
}

- (void)setSelectedBackgroundViewColor:(UIColor *)color {
    self.selectedBackgroundView = [[[UIView alloc] init] autorelease];
    self.selectedBackgroundView.backgroundColor = color;
}

@end