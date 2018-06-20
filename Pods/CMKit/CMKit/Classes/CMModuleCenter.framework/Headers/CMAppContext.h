//
//  CMAppContext.h
//  CMModuleCenter
//
//  Created by PengTao on 2017/8/24.
//  Copyright © 2017年 CML lnc. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

FOUNDATION_EXPORT NSString *const CMModuleCenterDemain;

typedef NS_ENUM(NSInteger, CMModuleEvent);
typedef NS_ENUM(int, CMAppEnvironment) {
	CMAppEnvironmentProduct = 0,
	CMAppEnvironmentBeta,
	CMAppEnvironmentDevelop
};

@class CMAppOpenURLItem, CMAppNotificationsItem, CMAppShortcutItem, CMAppUserActivityItem;
@interface CMAppContext : NSObject <NSCopying>

@property (class, nonatomic, strong, readonly) CMAppContext *shareContext;
+ (void)startWithAppEnvironment:(CMAppEnvironment)environment;

@property (nonatomic, assign, readonly) CMAppEnvironment environment;
@property (nonatomic, strong, readonly) NSDictionary *launchOptions;

@property (nonatomic, assign, readonly) CMModuleEvent moduleEventType; // CMModuleEvent >= 10000
@property (nonatomic, copy, readonly) NSDictionary *moduleEventParams;

/// OpenURL model
@property (nonatomic, strong, readonly) CMAppOpenURLItem *openURLItem;
/// Notifications Remote or Local
@property (nonatomic, strong, readonly) CMAppNotificationsItem *notificationsItem;
/// 3D-Touch model
@property (nonatomic, strong, readonly) CMAppShortcutItem *touchShortcutItem NS_CLASS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED;
/// NSUserActivity Model
@property (nonatomic, strong, readonly) CMAppUserActivityItem *userActivityItem NS_CLASS_AVAILABLE(10_10, 8_0);

@end

#pragma mark - App Items

@interface CMAppOpenURLItem : NSObject
@property (nonatomic, strong, readonly) NSURL *openURL;
@property (nonatomic, strong, readonly) NSString *sourceApplication;
@property (nonatomic, strong, readonly) NSDictionary *options NS_ENUM_AVAILABLE_IOS(9_0);
@end

@interface CMAppNotificationsItem : NSObject
@property (nonatomic, strong, readonly) NSData *deviceToken;
@property (nonatomic, strong, readonly) NSDictionary *userInfo;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) UILocalNotification *localNotification NS_CLASS_DEPRECATED_IOS(4_0, 10_0) __TVOS_PROHIBITED;
@property (nonatomic, copy, readonly) void (^resultHander)(UIBackgroundFetchResult);
@end
__IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0)
@interface CMAppNotificationsItem (UserNotifications)
@property (nonatomic, strong, readonly) UNNotification *notification;
@property (nonatomic, strong, readonly) UNNotificationResponse *response;
@property (nonatomic, copy, readonly) void (^presentationOptionsHandler)(UNNotificationPresentationOptions options);
@property (nonatomic, copy, readonly) void (^completionHandler)(void);
@property (nonatomic, strong, readonly) UNUserNotificationCenter *center;
@end

NS_CLASS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED
@interface CMAppShortcutItem : NSObject
@property (nonatomic, strong, readonly) UIApplicationShortcutItem *shortcutItem;
@property (nonatomic, copy, readonly) void(^completionHandler)(BOOL succeeded);
@end

NS_CLASS_AVAILABLE(10_10, 8_0)
@interface CMAppUserActivityItem : NSObject
@property (nonatomic, copy, readonly) NSString *userActivityType;
@property (nonatomic, strong, readonly) NSUserActivity *userActivity;
@property (nonatomic, strong, readonly) NSError *userActivityError;
@property (nonatomic, strong, readonly) void (^restorationHandler)(NSArray *restorableObjects);
@end
