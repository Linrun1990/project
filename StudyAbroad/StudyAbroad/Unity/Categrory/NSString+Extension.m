//
//  NSString+Extension.m
//  BaseTool
//
//  Created by Lin Feihong on 14-2-3.
//  Copyright (c) 2014年 Libraies. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width {
    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(width, MAXFLOAT)
                lineBreakMode:UILineBreakModeWordWrap];
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height {
    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(MAXFLOAT, height)
                lineBreakMode:UILineBreakModeWordWrap];
}

- (CGSize)boundingRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes {
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:attributes
                              context:nil].size;
}

#endif

@end
