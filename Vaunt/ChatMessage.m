//
//  ChatMessage.m
//  Vaunt
//
//  Created by Master on 7/6/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "ChatMessage.h"

@interface ChatMessage ()

@end

@implementation ChatMessage

+ (instancetype)chatMessageWithJson:(NSDictionary *)json {
    ChatMessage *chatMessage = [[ChatMessage alloc] init];
    [chatMessage updateWithJson:json];
    
    return chatMessage;
}

- (id)init {
    self = [super init];
    if (self) {
        self.sender = @"";
        self.avatar = @"";
        self.sentTime = nil;
        self.message = @"";
    }
    
    return self;
}

- (void)updateWithJson:(NSDictionary *)json {
    id sender = [json objectForKey:@"sender"];
    if (sender != [NSNull null]) {
        self.sender = sender;
    }
    
    id avatar = [json objectForKey:@"avatar"];
    if (avatar != [NSNull null]) {
        self.avatar = avatar;
    }
    
    id sentTime = [json objectForKey:@"sent_time"];
    if (sentTime != [NSNull null]) {
        self.sentTime = sentTime;
    }
    
    id message = [json objectForKey:@"message"];
    if (message != [NSNull null]) {
        self.message = message;
    }
}

- (NSDictionary *)getJson {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    
    if ([self.sender hasContent]) {
        [json setValue:self.sender forKey:@"sender"];
    }
    
    if ([self.avatar hasContent]) {
        [json setValue:self.avatar forKey:@"avatar"];
    }
    
    if (self.sentTime != nil) {
        [json setValue:self.sentTime forKey:@"sent_time"];
    }
    
    if ([self.message hasContent]) {
        [json setValue:self.message forKey:@"message"];
    }
    
    return json;
}

@end
