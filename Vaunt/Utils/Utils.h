//
//  Utils.h
//  Vaunt
//
//  Created by Kuznetsov Andrey on 01/08/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (BOOL)validateEmail: (NSString *)candidate;

+ (UIImage *)blankAvatarImage;

@end
