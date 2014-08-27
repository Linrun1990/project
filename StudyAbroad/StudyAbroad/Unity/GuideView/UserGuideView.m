//
//  UserGuideView.m
//  Pocket91
//
//  Created by Lin Feihong on 13-9-5.
//  Copyright (c) 2013年 Bodong Baidu. All rights reserved.
//

#import "UserGuideView.h"
#import "DianJinDDPageControl.h"

#define FADE_ANIMATION_TIME 1.0f

@interface UserGuideView () <UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) UIScrollView *containerView;
@property (nonatomic, retain) DianJinDDPageControl *pageControl;

@end

@implementation UserGuideView

#pragma mark - Public method

+ (UserGuideView *)userGuideView {
    UserGuideView *userGuideView = [[UserGuideView alloc] initWithFrame:SCREEN_BOUNDS];
    return [userGuideView autorelease];
}

- (void)show {
    if (self.hidden) {
        self.hidden = NO;
        self.containerView.alpha = 0.0f;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        DELEGATE_CALLBACK_ONE_PARAMETER(_delegate, userGuideViewWillShow:, self);
        [UIView animateWithDuration:FADE_ANIMATION_TIME animations:^{
            self.containerView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            DELEGATE_CALLBACK_ONE_PARAMETER(_delegate, userGuideViewDidShow:, self);
        }];
    }
}

- (void)dismiss {
    if (!self.hidden) {
        DELEGATE_CALLBACK_ONE_PARAMETER(_delegate, userGuideViewWillHide:, self);
        [UIView animateWithDuration:FADE_ANIMATION_TIME animations:^{
            self.containerView. alpha = 0.4f;
        } completion:^(BOOL finished) {
            DELEGATE_CALLBACK_ONE_PARAMETER(_delegate, userGuideViewDidHide:, self);
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - Init & dealloc

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        [self setupImagesDataSource];
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    RELEASE_SAFELY(_images);
    RELEASE_SAFELY(_containerView);
    RELEASE_SAFELY(_pageControl);
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    CGFloat offsetX = scrollView.frame.size.width * ([self.images count] - 1) + scrollView.frame.size.width / 2;
    self.pageControl.hidden = scrollView.contentOffset.x > offsetX;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.frame.size.width * ([self.images count] - 2);
    if (scrollView.contentOffset.x >= offsetX) {
        [self dismiss];
    }
}

#pragma mark - Private method

- (void)setupImagesDataSource {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserGuideConfig" ofType:@"plist"];
    NSDictionary *imageDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.images = (iPhone5) ? [imageDict objectForKey:@"iPhone5"] : [imageDict objectForKey:@"Below iPhone5"];
}

- (void)setupSubviews {
    self.containerView = [[[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS] autorelease];
    self.containerView.delegate = self;
    self.containerView.pagingEnabled = YES;
    self.containerView.contentSize = CGSizeMake(SCREEN_WIDTH * [self.images count], 0.0f);
    self.containerView.showsHorizontalScrollIndicator = NO;
    self.containerView.showsVerticalScrollIndicator = NO;
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.bounces = NO;
    [self addSubview:self.containerView];
    
    [self.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *imageName = (NSString *)obj;
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0.0f + idx * SCREEN_WIDTH, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);
//        if (idx == [self.images count] - 1) {
//            UIButton *enter = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
//            enter.center = self.containerView.center;
//            enter.backgroundColor = [UIColor clearColor];
//            [enter addTarget:self action:@selector(showRootViewController) forControlEvents:UIControlEventTouchUpInside];
//            [imageView addSubview:enter];
//            imageView.userInteractionEnabled = YES;
//        }
        [self.containerView addSubview:imageView];
        [imageView release];
    }];
    self.pageControl = [[[DianJinDDPageControl alloc] initWithFrame:CGRectZero] autorelease];
    self.pageControl.type = DDPageControlTypeOnFullOffFull;
    [self.pageControl setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height - 30.0f)];
    [self.pageControl setOnColor:RGBA(23.0f, 23.0f, 23.0f, 1.0f)];
    [self.pageControl setOffColor:RGBA(171.0f, 171.0f, 171.0f, 1.0f)];
    [self.pageControl setNumberOfPages:(self.images.count)];
    [self.pageControl setCurrentPage:0];
    [self.pageControl setDefersCurrentPageDisplay:NO];
    [self.pageControl setUserInteractionEnabled:NO];
    //[self addSubview:self.pageControl];
}

- (void)showRootViewController {
    [self dismiss];
}

@end
