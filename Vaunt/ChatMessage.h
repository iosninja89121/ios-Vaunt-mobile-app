//
//  ChatMessage.h
//  Vaunt
//
//  Created by Master on 7/6/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject

@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSNumber *sentTime;
@property (nonatomic, strong) NSString *message;

+ (instancetype)chatMessageWithJson:(NSDictionary *)json;

- (NSDictionary *)getJson;

@end