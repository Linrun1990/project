//
//  DianJinUIView+Addtion.m
//  91Market
//
//  Created by Lin Benjie on 12-7-24.
//  Copyright (c) 2012 Bodong ND. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@implementation UIView (AddtionSetCorner)

+ (NSString*)nibName {
    return [self description];
}

+ (id)loadFromNIB {
    NSString *nibName = [self nibName];
    return [self loadFromNIBNamed:nibName];
}

+ (id)loadFromNIBNamed:(NSString *)nibName {
    Class klass = [self class];
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:klass]) {
            return object;
        }
    }
    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", nibName, NSStringFromClass(klass)];
    return nil;
}

- (void)setCornerRadius:(float)radius {
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
}

- (void)setBorderLineWithColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)setBorderLineWithColor:(UIColor *)borderColor lineWidth:(CGFloat)lineWidth {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = lineWidth;
}

- (void)drawBottomLineWithHeight:(CGFloat)height
{
    UIView *bottomBlackLine = [[[UIView alloc] initWithFrame:CGRectMake(0, height-1, self.frame.size.width, 0.5)] autorelease];
    bottomBlackLine.backgroundColor = [UIColor colorWithRed:216.0 / 255.0 green:216.0 / 255.0 blue:216.0 / 255.0 alpha:1];
    [self addSubview:bottomBlackLine];
    UIView *bottomWhiteLine = [[[UIView alloc] initWithFrame:CGRectMake(0, height-0.5, self.frame.size.width, 0.5)] autorelease];
    bottomWhiteLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomWhiteLine];
}

@end
