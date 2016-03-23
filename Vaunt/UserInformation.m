//
//  UserInformation.m
//  Vaunt
//
//  Created by PandaSoft on 8/24/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

+(UserInformation*)sharedInstance
{
    static UserInformation *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id) init {
    self = [super init];
    
    return self;
}

- (void)removeInformation
{
    
    self.firstName          = nil;
    self.lastName           = nil;
    self.email              = nil;
    self.zipCode            = nil;
    self.avatarImage        = nil;
    self.userAccountName    = nil;
    self.authTokenKey       = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: kUDEmail];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: kUDAuthToken];

    return;
}

- (void)setInformation:(id)jsonData
{
    id dataJson = jsonData[kWSApiResponseData];
    NSDictionary* userJson = (NSDictionary*)dataJson[USERINFO_SUBSCRIBER_KEY];
    
    self.email              =   (NSString*)([userJson objectForKey:USERINFO_EMAIL_KEY]);
    self.firstName          =   (NSString*)([userJson objectForKey:USERINFO_FIRSTNAME_KEY]);
    self.lastName           =   (NSString*)([userJson objectForKey:USERINFO_LASTNAME_KEY]);
    self.zipCode            =   (NSString*)([userJson objectForKey:USERINFO_ZIPCODE_KEY]);
    self.userAccountName    =   (NSString*)([userJson objectForKey:USERINFO_USERNAME_KEY]);
    self.avatarImage        =   (NSString*)([userJson objectForKey:USERINFO_AVATAR_KEY]);
    
    NSLog(@"email : %@, first name : %@, last name : %@, zip code : %@, user account name : %@ avatar image : %@ user auth : %@", self.email, self.firstName, self.lastName, self.zipCode, self.userAccountName, self.avatarImage, self.authTokenKey);
}


@end
