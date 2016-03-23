//
//  ImageUtil.m
//  Vaunt
//
//  Created by Master on 6/28/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

+ (CGRect) rectForImage:(UIImage *)image andVisibleWidth:(CGFloat) visibleWidth {
    CGFloat visibleHeight = ceilf(visibleWidth * IMAGE_RATIO);
    
    CGFloat x, y, width, height;
    if (image.size.width * IMAGE_RATIO > image.size.height) {
        height = visibleHeight;
        width = ceilf(height * (image.size.width / image.size.height));
        x = (visibleWidth - width) / 2;
        y = 0;
    } else {
        width = visibleWidth;
        height = ceilf(width * (image.size.height / image.size.width));
        x = 0;
        y = 0;
    }
    
    return CGRectMake(x, y, width, height);
}

@end
