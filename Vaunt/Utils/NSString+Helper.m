//
//  NSString+Helper.m
//  VauntBroadcaster
//
//  Created by Kuznetsov Andrey on 11/08/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (BOOL)hasContent {
    
    if (((NSNull *)self == [NSNull null]) || (self == nil)) {
        return NO;
    }
    
    if (![self isKindOfClass:[NSString class]]) {
        return  NO;
    }
    
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedString isEqualToString:@""]) {
        return  NO;
    }
    
    return YES;
}

@end
