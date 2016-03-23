//
//  Constants.h
//  Vaunt
//
//  Created by Kuznetsov Andrey on 23/07/15.
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#ifndef Vaunt_Constants_h
#define Vaunt_Constants_h

// Web Service Apis
#define kWSApiBaseUrl               @"http://52.21.152.22/api/v1"

#define kWSApiSharedKey             @"44wmqFv2caT6F2hXwclqakFt8jFqYUdq3Mt90WNwHCWqO3LPQBbybr0aysatOEMW"

#define kWSApiVerifyAuthToken       @"subscriber/verify"
#define kWSApiRegister              @"subscriber/register"
#define kWSApiLogin                 @"subscriber/login"
#define kWSApiUpdate                @"subscriber/profile/update"
#define kWSApiProfile               @"subscriber/profile"
#define kVODWatchList               @"VODWatchList"
#define kLIVEWatchList              @"LiveWatchList"

#define kS3AWSImageBaseUrl          @"http://d2mfxjpe4qh8ou.cloudfront.net/images"
#define kS3CoreImage                @"coverimages"

#define kWSApiResponseSuccess       @"success"
#define kWSApiResponseMessage       @"message"
#define kWSApiResponseCode          @"code"
#define kWSApiResponseData          @"data"

#define SUCCESS_CODE                200

// NSUserDefaults Keys
#define kUDAppLastStartTime         @"appLastStartTime"
#define kUDEmail                    @"email"
#define kUDAuthToken                @"auth_token"
#define kUDPushDeviceToken          @"pushDeviceToken"

// NSNotification Names
#define     kPNPublishMessageNotification           @"PNPublishMessageNotification"
#define     kPNDidReceiveMessageNotification        @"PNDidReceiveMessageNotification"

// NSNotification UserInfo Keys
#define     kNUChatMessage                          @"chatMessage"
#define     kNUTimeToken                            @"timeToken"
#define     kNUSender                               @"sender"

// PN Message Keys
#define     kPMMessage                              @"message"
#define     kPMSender                               @"sender"

//#define     kStandardPortfolio                      @"StandardPortfolio"
#define     kPortfolioFileName                      @"PortfolioName"
#define     kUserAccountName                        @"UserAccountName"

#define     kNotificationUpdatePortfolio            @"updatePortfolio"

#define     SIDEBAR_TITLE_TAG                       @"title"
#define     SIDEBAR_ICON_TAG                        @"icon"

#define     SIDEBAR_HOME_TITLE                      @"Home"
#define     SIDEBAR_LIVE_TITLE                      @"Live"
#define     SIDEBAR_WATCH_TITLE                     @"Watch"
#define     SIDEBAR_DISCOVER_TITLE                  @"Discover"
#define     SIDEBAR_BROWSER_TITLE                   @"Browse"
#define     SIDEBAR_SETTINGS_TITLE                  @"Settings"
#define     SIDEBAR_LOGOUT_TITLE                    @"Logout"

#define     SIDEBAR_LIVE_ICON                       @"live_sidebar.png"
#define     SIDEBAR_WATCH_ICON                      @"myvaunt_sidebar.png"
#define     SIDEBAR_DISCOVER_ICON                   @"discover_sidebar.png"
#define     SIDEBAR_BROWSER_ICON                    @"browse_sidebar.png"
#define     SIDEBAR_HOME_ICON                       @"profile_sidebar.png"
#define     SIDEBAR_SETTINGS_ICON                   @"settings_sidebar.png"
#define     SIDEBAR_LOGOUT_ICON                     @""

#define     CROPIMAGE_SIZE_WIDTH                    300
#define     CROPIMAGE_SIZE_HEIGHT                   300

typedef enum{
    SIDEBAR_HOME_ITEM = 0,
    SIDEBAR_LIVE_ITEM,
    SIDEBAR_WATCH_ITEM,
    SIDEBAR_DISCOVER_ITEM,
    SIDEBAR_BROWSER_ITEM,
    SIDEBAR_SETTING_ITEM,
    SIDEBAR_LOGOUT_ITEM
}SIDEBAR_ITEMS;

#define     SIDEBAR_WIDTH_RATE                      0.6f

//webservice post param keywords
#define     USERINFO_HASH_KEY                       @"hashed_shared_key"
#define     USERINFO_FIRSTNAME_KEY                  @"first_name"
#define     USERINFO_LASTNAME_KEY                   @"last_name"
#define     USERINFO_EMAIL_KEY                      @"email"
#define     USERINFO_PASSWORD_KEY                   @"password"
#define     USERINFO_ZIPCODE_KEY                    @"zip_code"
#define     USERINFO_DEVICETOKEN_KEY                @"device_token"
#define     USERINFO_DEVICEMODEL_KEY                @"device_model"
#define     USERINFO_DEVICEUID_KEY                  @"device_uid"
#define     USERINFO_USERNAME_KEY                   @"username"
#define     USERINFO_AVATAR_KEY                     @"avatar"
#define     USERINFO_HASHEDPASSWORK_KEY             @"hashed_password"
#define     USERINFO_USER_KEY                       @"user"
#define     USERINFO_SUBSCRIBER_KEY                 @"subscriber"


//Notification Key
// #define     kLogOutNotify                           @"LogOutNotification"


#endif
