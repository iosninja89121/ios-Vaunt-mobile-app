//
//  Utils.m
//  Vaunt
//
//  Created by Kuznetsov Andrey on 01/08/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (BOOL)validateEmail: (NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (UIImage *)blankAvatarImage {
    static UIImage *blankAvatarImage = nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        blankAvatarImage = [UIImage imageNamed:@"avatar_placeholder.png"];
    });
    return blankAvatarImage;
}

@end
