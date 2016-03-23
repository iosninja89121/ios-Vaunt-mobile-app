//
//  AppDelegate.m
//
//  Copyright (c) 2015 Vaunt. All rights reserved.
//

#import "AppDelegate.h"
#import "VLC-Header.h"
#import "UIDevice+VLC.h"
#import <PubNub/PubNub.h>

@interface AppDelegate () <PNObjectEventListener>

// Stores reference on PubNub client to make sure what it won't be released.
@property (nonatomic) PubNub *client;

@end

@implementation AppDelegate

- (void)initializeVLC {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *skipLoopFilterDefaultValue;
    int deviceSpeedCategory = [[UIDevice currentDevice] speedCategory];
    if (deviceSpeedCategory < 3)
        skipLoopFilterDefaultValue = kVLCSettingSkipLoopFilterNonKey;
    else
        skipLoopFilterDefaultValue = kVLCSettingSkipLoopFilterNonRef;
    
    NSDictionary *appDefaults = @{kVLCSettingPasscodeKey : @"",
                                  kVLCSettingPasscodeOnKey : @(NO),
                                  kVLCSettingContinueAudioInBackgroundKey : @(YES),
                                  kVLCSettingStretchAudio : @(NO),
                                  kVLCSettingTextEncoding : kVLCSettingTextEncodingDefaultValue,
                                  kVLCSettingSkipLoopFilter : skipLoopFilterDefaultValue,
                                  kVLCSettingSubtitlesFont : kVLCSettingSubtitlesFontDefaultValue,
                                  kVLCSettingSubtitlesFontColor : kVLCSettingSubtitlesFontColorDefaultValue,
                                  kVLCSettingSubtitlesFontSize : kVLCSettingSubtitlesFontSizeDefaultValue,
                                  kVLCSettingSubtitlesBoldFont: kVLCSettingSubtitlesBoldFontDefaultValue,
                                  kVLCSettingDeinterlace : kVLCSettingDeinterlaceDefaultValue,
                                  kVLCSettingNetworkCaching : kVLCSettingNetworkCachingDefaultValue,
                                  kVLCSettingPlaybackGestures : [NSNumber numberWithBool:YES],
                                  kVLCSettingFTPTextEncoding : kVLCSettingFTPTextEncodingDefaultValue,
                                  kVLCSettingWiFiSharingIPv6 : kVLCSettingWiFiSharingIPv6DefaultValue,
                                  kVLCSettingEqualizerProfile : kVLCSettingEqualizerProfileDefaultValue,
                                  kVLCSettingPlaybackForwardSkipLength : kVLCSettingPlaybackForwardSkipLengthDefaultValue,
                                  kVLCSettingPlaybackBackwardSkipLength : kVLCSettingPlaybackBackwardSkipLengthDefaultValue,
                                  kVLCSettingOpenAppForPlayback : kVLCSettingOpenAppForPlaybackDefaultValue};
    [defaults registerDefaults:appDefaults];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self initializeVLC];
    
    // Register for Push Notifications
#if !TARGET_IPHONE_SIMULATOR
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // Registering for push notifications under iOS8
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        
        // Register for push notifications for pre-iOS8
        UIRemoteNotificationType type = (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
    }
#endif
    
    // Initialize PN instance
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-b720f963-b76b-40bb-b26a-0c81207c88b9"
                                                                     subscribeKey:@"sub-c-d91dcaf8-3146-11e5-a033-0619f8945a4f"];
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    [self.client subscribeToChannels:@[@"test_channel"] withPresence:YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(publishPNMessage:) name:kPNPublishMessageNotification object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:kPNPublishMessageNotification object:nil];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if(!self.allowRotation)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Push Notificaion

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"My device token is: %@", deviceToken);
    
    NSString *wdeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    wdeviceToken = [wdeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"My device token is: %@", wdeviceToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:wdeviceToken forKey:kUDPushDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSString *message = nil;
    id alert = [userInfo objectForKey:@"aps"];
    if ([alert isKindOfClass:[NSString class]]) {
        
        message = alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        
        message = [alert objectForKey:@"alert"];
    }
    
    if (alert) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                            message:@"is the message."  delegate:self
                                                  cancelButtonTitle:@"Yeah PubNub!"
                                                  otherButtonTitles:@"Cool PubNub!", nil];
        [alertView show];
    }
}

#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message
    if (message.data.actualChannel) {
        
        // Message has been received on channel group stored in
        // message.data.subscribedChannel	
    }
    else {
        
        // Message has been received on channel stored in
        // message.data.subscribedChannel
        
        
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary *pnMessage = message.data.message;
    ChatMessage *chatMessage = [ChatMessage chatMessageWithJson:pnMessage];
    chatMessage.sentTime = message.data.timetoken;
    
    NSDictionary *userInfo = @{kNUChatMessage: chatMessage};
    
    [center postNotificationName:kPNDidReceiveMessageNotification object:nil userInfo:userInfo];

    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.subscribedChannel, message.data.timetoken);
}

- (void)client:(PubNub *)client didReceiveStatus:(PNSubscribeStatus *)status {
    
    if (status.category == PNUnexpectedDisconnectCategory) {
        // This event happens when radio / connectivity is lost
    }
    
    else if (status.category == PNConnectedCategory) {
        
        // Connect event. You can do stuff like publish, and know you'll get it.
        // Or just use the connected event to confirm you are subscribed for
        // UI / internal notifications, etc
    }
    else if (status.category == PNReconnectedCategory) {
        
        // Happens as part of our regular operation. This event happens when
        // radio / connectivity is lost, then regained.
    }
    else if (status.category == PNDecryptionErrorCategory) {
        
        // Handle messsage decryption error. Probably client configured to
        // encrypt messages and on live data feed it received plain text.
    }
    
}

- (void)publishPNMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    ChatMessage *chatMessage = [userInfo objectForKey:kNUChatMessage];
    
    NSDictionary *pnMessage = [chatMessage getJson];
    
    [self.client publish:pnMessage toChannel:@"test_channel"
          withCompletion:^(PNPublishStatus *status) {
              
              // Check whether request successfully completed or not.
              if (!status.isError) {
                  
                  // Message successfully published to specified channel.
              }
              // Request processing failed.
              else {
                  
                  // Handle message publish error. Check 'category' property to find out possible issue
                  // because of which request did fail.
                  //
                  // Request can be resent using: [status retry];
              }
          }];
}

@end
