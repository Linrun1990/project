//
//  NSString+Extension.h
//  BaseTool
//
//  Created by Lin Feihong on 14-2-3.
//  Copyright (c) 2014年 Libraies. All rights reserved.
//


@interface NSString (Extension)

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
- (CGSize)boundingRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes;
#endif


@end

