//
//  ImageUtil.h
//  Vaunt
//
//  Created by Master on 6/28/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define IMAGE_RATIO 0.646
#define PROFILE_IMAGE_RATIO 0.267

@interface ImageUtil : NSObject

+ (CGRect) rectForImage:(UIImage *)image andVisibleWidth:(CGFloat) width;

@end
