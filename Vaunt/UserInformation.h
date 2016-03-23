//
//  UserInformation.h
//  Vaunt
//
//  Created by PandaSoft on 8/24/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject

+(UserInformation*)sharedInstance;

@property(nonatomic, strong) NSString* firstName;
@property(nonatomic, strong) NSString* lastName;
@property(nonatomic, strong) NSString* email;
@property(nonatomic, strong) NSString* zipCode;
@property(nonatomic, strong) NSString* userAccountName;
@property(nonatomic, strong) NSString*  avatarImage;
@property(nonatomic, strong) NSString* authTokenKey;

- (void)removeInformation; 
- (void)setInformation:(id)jsonData;

@end
