//
//  RHDevice.m
//  RHBaseKit
//
//  Created by PengTao on 2017/7/24.
//  Copyright © 2017年 CMRH. All rights reserved.
//

#import "RHDevice.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>

@implementation RHDevice

+ (BOOL)isiPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (BOOL)isiPhone {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}
+ (BOOL)isiPod {
    return [self.platform hasPrefix:@"iPod"];
}
+ (BOOL)isAppleTV {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV;
}
+ (BOOL)isAppleWatch {
    return [self.platform hasPrefix:@"Watch"];
}
+ (BOOL)isSimulator {
    return ([self.platform isEqualToString:@"i386"]
         || [self.platform isEqualToString:@"x86_64"]);
}

+ (NSString *)systemVersion {
    return UIDevice.currentDevice.systemVersion;
}
+ (float)systemVersionFloatValue {
    return UIDevice.currentDevice.systemVersion.floatValue;
}

+ (NSString *)HWModel {
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.model", machine, &size, NULL, 0);
    NSString *HWModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return HWModel;
}

+ (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *)platformString {
    NSString *platform = self.platform;
    
    //https://www.theiphonewiki.com/wiki/Models
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
	if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
	if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
	if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
	if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
	if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
	if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
	
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    if ([platform isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    // iPad mini
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad mini Retina (China)";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
    // iPad Pro 9.7 inch
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7-inch (WiFi)";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7-inch (Cellular)";
    // iPad Pro 10.5 inch
    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5-inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5-inch (Cellular)";
    // iPad Pro 12.9 inch
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9-inch (WiFi)";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9-inch (Cellular)";
    if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9-inch 2G (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9-inch 2G (Cellular)";
	if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro (10.5-inch)";
	if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";
    // Apple TV
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3G";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3G";
    if ([platform isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4G";
	if ([platform isEqualToString:@"AppleTV6,2"])   return @"Apple TV 4K";
    // Apple Watch
    if ([platform isEqualToString:@"Watch1,1"])     return @"Apple Watch 38mm";
    if ([platform isEqualToString:@"Watch1,2"])     return @"Apple Watch 42mm";
    if ([platform isEqualToString:@"Watch2,3"])     return @"Apple Watch Series 2 38mm";
    if ([platform isEqualToString:@"Watch2,4"])     return @"Apple Watch Series 2 42mm";
    if ([platform isEqualToString:@"Watch2,6"])     return @"Apple Watch Series 1 38mm";
    if ([platform isEqualToString:@"Watch2,7"])     return @"Apple Watch Series 1 42mm";
	if ([platform isEqualToString:@"Watch3,1"])     return @"Apple Watch Series 3 38mm";
	if ([platform isEqualToString:@"Watch3,2"])     return @"Apple Watch Series 3 42mm";
	if ([platform isEqualToString:@"Watch3,3"])     return @"Apple Watch Series 3 38mm";
	if ([platform isEqualToString:@"Watch3,4"])     return @"Apple Watch Series 3 42mm";
    // Simulator
    if ([platform isEqualToString:@"i386"])         return UIDevice.currentDevice.model;
    if ([platform isEqualToString:@"x86_64"])       return UIDevice.currentDevice.model;
    
    return platform;
}

+ (NSUInteger)cpuFrequency  { return [self _rh_getSysInfo:HW_CPU_FREQ]; }
+ (NSUInteger)busFrequency  { return [self _rh_getSysInfo:HW_TB_FREQ]; }
+ (NSUInteger)ramSize       { return [self _rh_getSysInfo:HW_MEMSIZE]; }
+ (NSUInteger)cpuNumber     { return [self _rh_getSysInfo:HW_NCPU]; }
+ (NSUInteger)totalMemory   { return [self _rh_getSysInfo:HW_PHYSMEM]; }
+ (NSUInteger)userMemory    { return [self _rh_getSysInfo:HW_USERMEM]; }
+ (NSUInteger)_rh_getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSUInteger)totalDiskSpace {
    NSDictionary *attributes = [NSFileManager.defaultManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[attributes objectForKey:NSFileSystemSize] unsignedIntegerValue];
}
+ (NSUInteger)freeDiskSpace {
    NSDictionary *attributes = [NSFileManager.defaultManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[attributes objectForKey:NSFileSystemFreeSize] unsignedIntegerValue];
}

+ (NSString *)macAddress {
    // In iOS 7 and later, if you ask for the MAC address of an iOS device, the system returns the value 02:00:00:00:00:00
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Error!\n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}


+ (BOOL)isRetina {
    return [UIScreen.mainScreen respondsToSelector:@selector(displayLinkWithTarget:selector:)]
        && (UIScreen.mainScreen.scale == 2.0 || UIScreen.mainScreen.scale == 3.0);
}
+ (BOOL)isRetinaHD {
    return [UIScreen.mainScreen respondsToSelector:@selector(displayLinkWithTarget:selector:)]
        && (UIScreen.mainScreen.scale == 3.0);
}

+ (BOOL)isiPhone4Size { return [self _rh_deviceSizeEqualTo:RH_Size_iPhone4]; }
+ (BOOL)isiPhone5Size { return [self _rh_deviceSizeEqualTo:RH_Size_iPhone5]; }
+ (BOOL)isiPhone6Size { return [self _rh_deviceSizeEqualTo:RH_Size_iPhone6]; }
+ (BOOL)isiPhone6PlusSize { return [self _rh_deviceSizeEqualTo:RH_Size_iPhone6Plus]; }
+ (BOOL)_rh_deviceSizeEqualTo:(CGSize)size {
    CGSize screenSize = RH_SCREEN_SIZE;
    return(screenSize.height==size.height && screenSize.width==size.width)
    || (screenSize.height==size.width && screenSize.width==size.height);
}

@end
