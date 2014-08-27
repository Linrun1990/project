//
//  WFIndexPath.m
//  MBaoBao
//
//  Created by yi_dq on 20/2/14.
//  Copyright (c) 2014 Bodong Baidu. All rights reserved.
//

#import "WFIndexPath.h"

@implementation WFIndexPath

+ (WFIndexPath *)initWithRow:(int)indexRow withColumn:(int)indexColumn{
    
    WFIndexPath *indexPath = [[WFIndexPath alloc] init];
    indexPath.row = indexRow;
    indexPath.column = indexColumn;
    return [indexPath autorelease];
}

@end
