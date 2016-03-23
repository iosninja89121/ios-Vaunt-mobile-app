/*****************************************************************************
 * Prefix header for all source files of the 'vlc-ios' target
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2013-2014 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan.org>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import <Availability.h>

#ifndef __IPHONE_8_2
#error "This project uses features only available in iOS SDK 8.2 and later."
#endif

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
#endif

#import <MobileVLCKit/MobileVLCKit.h>
#import <MediaLibraryKit/MediaLibraryKit.h>

#import "VLCConstants.h"
#import "UIColor+Presets.h"
#import "UIBarButtonItem+Theme.h"
#import "VLCAlertView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_RUNS_IOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define SYSTEM_RUNS_IOS8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

#define SYSTEM_RUNS_IOS82_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.2")

#ifdef __IPHONE_7_0
#define SYSTEM_RUNS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#else
#define SYSTEM_RUNS_IOS7 NO
#endif

#ifndef NDEBUG
#define APLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define APLog(format, ...)
#endif
