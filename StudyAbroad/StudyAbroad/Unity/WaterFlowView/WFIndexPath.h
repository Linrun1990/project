//
//  WFIndexPath.h
//  MBaoBao
//
//  Created by yi_dq on 20/2/14.
//  Copyright (c) 2014 Bodong Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFIndexPath : NSObject

@property (nonatomic, assign) int row;
@property (nonatomic, assign) int column;

+ (WFIndexPath *)initWithRow:(int)indexRow withColumn:(int)indexColumn;

@end
