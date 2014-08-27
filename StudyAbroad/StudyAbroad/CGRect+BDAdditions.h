//
//  CGRect+Additions.h
//  BDKit
//
//  Created by Liu Jinyong on 14-2-19.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

static __inline__ CGRect CGRectFromCGSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
};

static __inline__ CGRect CGRectMakeWithCenterAndSize(CGPoint center, CGSize size) {
    return CGRectMake(center.x - size.width * 0.5, center.y - size.height * 0.5, size.width, size.height);  
};

static __inline__ CGRect CGRectMakeWithOriginAndSize(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
};

static __inline__ CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
};