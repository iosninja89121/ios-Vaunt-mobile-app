//
//  DBUtil.h
//  Vaunt
//
//  Created by Master on 6/30/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DRAKE_PROFILE_INDEX 0
#define KENDAL_JENNAR_PROFILE_INDEX 1
#define KEVIN_HART_PROFILE_INDEX 0
#define CHRIS_BROWN_PROFILE_INDEX 2
#define JEN_SELTER_PROFILE_INDEX 3
#define NICKI_MINAJ_PROFILE_INDEX 13
#define AMBER_ROSE_PROFILE_INDEX 9

@interface DBUtil : NSObject

@property (nonatomic, strong) NSArray *channelsArray;
@property (nonatomic, strong) NSArray *liveProfiles;
//@property (nonatomic, strong) NSMutableArray *messages;

+(DBUtil*)sharedInstance;

- (NSArray *)searchItems:(NSString *)searchText;

@end
