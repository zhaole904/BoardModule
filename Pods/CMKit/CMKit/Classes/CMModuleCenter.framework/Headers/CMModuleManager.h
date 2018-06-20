//
//  CMModuleManager.h
//  CMModuleCenter
//
//  Created by PengTao on 2017/8/24.
//  Copyright © 2017年 CML lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CM_MODULE_EXPORT \
+ (void)load { [CMModuleManager.manager registerModule:self]; }

FOUNDATION_EXPORT id CMService(Class moduleClass, Protocol *service);
#define CMService(module, service) ((id<service>)CMService(NSClassFromString([NSString stringWithUTF8String:#module]), @protocol(service)))

typedef NS_ENUM(NSInteger, CMModuleEvent) {
	CMModuleEventSetup = 0,             // 安装
	CMModuleEventTearDown,              // 拆卸
	CMModuleEventUnmount,               // 卸载
	CMModuleEventInit,                  // 初始化
	
	CMModuleEventWillResignActive,
	CMModuleEventDidEnterBackground,
	CMModuleEventDidBecomeActive,
	CMModuleEventWillEnterForeground,
	CMModuleEventWillTerminate,
	CMModuleEventDidReceiveMemoryWarning,
	CMModuleEventOpenURL,
	CMModuleEventQuickAction NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED, // 屏幕快照
	
	CMModuleEventDidRegisterForRemoteNotifications,
	CMModuleEventDidFailToRegisterForRemoteNotifications,
	CMModuleEventDidReceiveRemoteNotification,
	CMModuleEventDidReceiveLocalNotification NS_DEPRECATED_IOS(4_0, 10_0) __TVOS_PROHIBITED,
	CMModuleEventWillPresentNotification __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0),
	CMModuleEventDidReceiveNotificationResponse __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED,
	
	CMModuleEventWillContinueUserActivity NS_AVAILABLE_IOS(8_0),
	CMModuleEventContinueUserActivity NS_AVAILABLE_IOS(8_0),
	CMModuleEventDidFailToContinueUserActivity NS_AVAILABLE_IOS(8_0),
	CMModuleEventDidUpdateUserActivity NS_AVAILABLE_IOS(8_0),
	
	CMModuleEventCustom  = 10000
};

@interface CMModuleManager : NSObject

@property(class, nonatomic, strong, readonly) CMModuleManager *manager;

- (void)registerModule:(Class)moduleClass;
- (void)unregisterModule:(Class)moduleClass;

- (id)moduleByModuleClass:(Class)moduleClass;
- (id)moduleByName:(NSString *)moduleName;

- (void)triggerCustomModuleEvent:(CMModuleEvent)eventType withParams:(NSDictionary *)params;

@end

@interface CMModuleManager (Handle)

/**
 服务事件调用的工厂方法。
 * 回调的'info'参数的数据类型可以是：Dictionary、Array、String、Number、Image，Dictionary和Array中的元素必须是可被JSON序列化的数据类型
 * action 最多有两个入参，但有两个入参时最后一个必须是'completion'block
 */
- (id)performModule:(Class)module
			service:(Protocol *)service
			 action:(SEL)action
			 params:(id)params
		 completion:(void(^)(id info, NSError *error))completion;

/**
 获取模块中某个服务的主页面
 为支持Athena新增的的方法，方法不包含action参数，如果服务存在页面，启动服务，并return服务的主页
 需要在实现service:方法时，把服务的主页return

 @param service 服务
 @param module  模块
 @return 服务的首页对象，不存在返回nil
 */
+ (id)getMainPageOfservice:(Protocol *)service atModule:(Class)module;
+ (id)performModule:(Class)module service:(Protocol *)service action:(SEL)action;
+ (id)performModule:(Class)module service:(Protocol *)service action:(SEL)action params:(id)params;
+ (id)performModule:(Class)module service:(Protocol *)service action:(SEL)action params:(id)params
		 completion:(void(^)(id info, NSError *error))completion;
+ (id)performModuleName:(NSString *)moduleName serviceName:(NSString *)serviceName actionName:(NSString *)actionName params:(id)params completion:(void(^)(id info, NSError *error))completion;

@end
