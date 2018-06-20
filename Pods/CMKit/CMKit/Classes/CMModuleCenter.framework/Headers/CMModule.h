//
//  CMModule.h
//  CMModuleCenter
//
//  Created by PengTao on 2017/8/24.
//  Copyright © 2017年 CML lnc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CMAppContext;

typedef NS_ENUM(NSInteger, CMModuleLevel) {
	CMModuleLevelBasic = -1L,
	CMModuleLevelNormal = 0
};

@protocol CMModule <NSObject>
typedef id<CMModule> CMModule;
@optional

- (id)service:(Protocol *)service;

@property(class, nonatomic, readonly) BOOL isSingleton;
@property(class, nonatomic, readonly) CMModuleLevel level;
@property(class, nonatomic, readonly) NSInteger priority;
@property(class, nonatomic, readonly) BOOL async;

- (void)moduleSetup:(CMAppContext *)context;
- (void)moduleTearDown:(CMAppContext *)context;
- (void)moduleUnmount:(CMAppContext *)context;
- (void)moduleInit:(CMAppContext *)context;

- (void)moduleWillResignActive:(CMAppContext *)context;
- (void)moduleDidEnterBackground:(CMAppContext *)context;
- (void)moduleDidBecomeActive:(CMAppContext *)context;
- (void)moduleWillEnterForeground:(CMAppContext *)context;
- (void)moduleWillTerminate:(CMAppContext *)context;
- (void)moduleDidReceiveMemoryWaring:(CMAppContext *)context;
- (void)moduleOpenURL:(CMAppContext *)context;
- (void)moduleQuickAction:(CMAppContext *)context NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED;

- (void)moduleDidRegisterForRemoteNotifications:(CMAppContext *)context;
- (void)moduleDidFailToRegisterForRemoteNotifications:(CMAppContext *)context;
- (void)moduleDidReceiveRemoteNotification:(CMAppContext *)context;
- (void)moduleDidReceiveLocalNotification:(CMAppContext *)context NS_DEPRECATED_IOS(4_0, 10_0) __TVOS_PROHIBITED;
- (void)moduleWillPresentNotification:(CMAppContext *)context __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0);
- (void)moduleDidReceiveNotificationResponse:(CMAppContext *)context __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED;

- (void)moduleWillContinueUserActivity:(CMAppContext *)context NS_AVAILABLE_IOS(8_0);
- (void)moduleContinueUserActivity:(CMAppContext *)context NS_AVAILABLE_IOS(8_0);
- (void)moduleDidFailToContinueUserActivity:(CMAppContext *)context NS_AVAILABLE_IOS(8_0);
- (void)moduleDidUpdateContinueUserActivity:(CMAppContext *)context NS_AVAILABLE_IOS(8_0);

- (void)moduleHandleCustomEventWithContext:(CMAppContext *)context;

@end
