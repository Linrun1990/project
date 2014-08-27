//
//  BaseNotHaveOrderView.h
//  DianJinApp
//
//  Created by tqnd on 14-6-29.
//  Copyright (c) 2014年 BoDong Baidu. All rights reserved.
//

@interface BaseNotHaveDataView : UIView

@property (retain, nonatomic) IBOutlet UIImageView *iamgeView;
@property (retain, nonatomic) IBOutlet UILabel *promptLabel;

- (void)reloadView:(NSString *)imageName prompt:(NSString *)prompt;

@end
