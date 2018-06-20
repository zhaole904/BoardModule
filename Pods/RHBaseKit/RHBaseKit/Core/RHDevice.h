//
//  RHDevice.h
//  RHBaseKit
//
//  Created by PengTao on 2017/7/24.
//  Copyright © 2017年 CMRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHDevice : NSObject

@property(class, nonatomic, readonly) BOOL isiPad;
@property(class, nonatomic, readonly) BOOL isiPhone;
@property(class, nonatomic, readonly) BOOL isiPod;
@property(class, nonatomic, readonly) BOOL isAppleTV;
@property(class, nonatomic, readonly) BOOL isAppleWatch;
@property(class, nonatomic, readonly) BOOL isSimulator;

@property(class, nonatomic, readonly) NSString  *systemVersion;  ///< iOS版本号
@property(class, nonatomic, readonly) float      systemVersionFloatValue;
@property(class, nonatomic, readonly) NSString  *HWModel;
@property(class, nonatomic, readonly) NSString  *platform; ///< 硬件版本，比如：iPhone7,2
@property(class, nonatomic, readonly) NSString  *platformString; ///< 硬件版本(转换成具体通用型号，如：iPhone 6s)

@property(class, nonatomic, readonly) NSUInteger cpuFrequency;   ///< 当前设备CPU频率
@property(class, nonatomic, readonly) NSUInteger busFrequency;   ///< 当前设备总线频率
@property(class, nonatomic, readonly) NSUInteger ramSize;        ///< 当前设备内存大小
@property(class, nonatomic, readonly) NSUInteger cpuNumber;      ///< CPU核心数
@property(class, nonatomic, readonly) NSUInteger totalMemory;    ///< the current device total memory
@property(class, nonatomic, readonly) NSUInteger userMemory;     ///< the current device non-kernel memory
@property(class, nonatomic, readonly) NSUInteger totalDiskSpace; ///< 当前设备总磁盘空间
@property(class, nonatomic, readonly) NSUInteger freeDiskSpace;  ///< 当前设备剩余磁盘空间
@property(class, nonatomic, readonly) NSString  *macAddress;     ///< MAC地址

@property(class, nonatomic, readonly) BOOL isRetina;
@property(class, nonatomic, readonly) BOOL isRetinaHD;

@property(class, nonatomic, readonly) BOOL isiPhone4Size;       ///< iPhone4、iPhone4S
@property(class, nonatomic, readonly) BOOL isiPhone5Size;       ///< iPhone5、iPhone5s、iPhone5c
@property(class, nonatomic, readonly) BOOL isiPhone6Size;       ///< iPhone6、iPhone6s、iPhone7
@property(class, nonatomic, readonly) BOOL isiPhone6PlusSize;   ///< iPhone6 plus、iPhone6s plus、iPhone7 plus

@end

#define RH_IOS_VERSION              (UIDevice.currentDevice.systemVersion)
#define RH_IOS_VERSION_FloatValue   (UIDevice.currentDevice.systemVersion.floatValue)

#define RH_SYSTEM_VERSION_EQUAL_TO(v)                   ([RH_IOS_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)
#define RH_SYSTEM_VERSION_GREATER_THAN(v)               ([RH_IOS_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define RH_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)   ([RH_IOS_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define RH_SYSTEM_VERSION_LESS_THAN(v)                  ([RH_IOS_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define RH_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)      ([RH_IOS_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)

#define RH_IS_IOS_5_OR_LATER       (RH_IOS_VERSION_FloatValue >= 5.0)
#define RH_IS_IOS_6_OR_LATER       (RH_IOS_VERSION_FloatValue >= 6.0)
#define RH_IS_IOS_7_OR_LATER       (RH_IOS_VERSION_FloatValue >= 7.0)
#define RH_IS_IOS_8_OR_LATER       (RH_IOS_VERSION_FloatValue >= 8.0)
#define RH_IS_IOS_9_OR_LATER       (RH_IOS_VERSION_FloatValue >= 9.0)
#define RH_IS_IOS_10_OR_LATER      (RH_IOS_VERSION_FloatValue >= 10.0)


#define RH_DEVICE_IS_IPAD          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RH_DEVICE_IS_IPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


#define RH_SCREEN_SIZE   (UIScreen.mainScreen.bounds.size)
#define RH_SCREEN_WIDTH  (UIScreen.mainScreen.bounds.size.width)
#define RH_SCREEN_HEIGHT (UIScreen.mainScreen.bounds.size.height)

#define RH_Size_iPhone4     CGSizeMake(320, 480)
#define RH_Size_iPhone5     CGSizeMake(320, 568)
#define RH_Size_iPhone6     CGSizeMake(375, 667)
#define RH_Size_iPhone6Plus CGSizeMake(414, 736)
#define RH_Size_iPad        CGSizeMake(768, 1024)
