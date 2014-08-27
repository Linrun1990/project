//
//  wangjianhui
//
//  Created by wangjianhui on 14-5-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DianJinDDPageControl.h"

typedef enum {
    CarouselTypeNone = 1 ,
    CarouselTypeChanel,
    CarouselTypeActivity,
    CarouselTypeWeb,
    CarouselTypeDownLoad
}CarouselType;

@interface DJPageView : UIView<UIScrollViewDelegate>

@property(copy,nonatomic)void(^didTap)(NSNumber* index);
@property (assign,nonatomic) NSUInteger count;
@property(copy,nonatomic)UIView *(^fetchView)(NSNumber* index,CGRect frame);

-(void)loadView;
- (void)update;
- (void)updateWithView:(UIView *(^)(NSNumber* index, CGRect frame)) fetch;
- (void)updateWithView:(UIView *(^)(NSNumber* index, CGRect frame)) fetch count:(int) count;
-(void) startPlay; //开始自动滚动
-(void)endPlay;   //停止自动滚动

@end
