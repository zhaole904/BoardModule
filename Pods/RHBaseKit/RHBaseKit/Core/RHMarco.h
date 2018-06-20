//
//  RHMarco.h
//  RHBaseKit
//
//  Created by PengTao on 2017/8/8.
//  Copyright © 2017年 CMRH. All rights reserved.
//

#ifndef _RHMarco_
#define _RHMarco_

#import <Foundation/Foundation.h>

// 沙盒路径
#define RH_PATH_HOME     NSHomeDirectory()
#define RH_PATH_TEMP     NSTemporaryDirectory()
#define RH_PATH_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define RH_PATH_CACHE    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/** 快速查询一段代码的执行时间 */
/** 用法
 TICK
 code
 TOCK
 */
#define RH_TICK NSDate *startTime = [NSDate date];
#define RH_TOCK NSLog(@"Time:%f", -[startTime timeIntervalSinceNow]);


/** arc 支持performSelector: */
#define RH_SuppressPerformSelectorLeakWarning(...) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    (__VA_ARGS__) \
    _Pragma("clang diagnostic pop")

#define RH_PerformSelectorLeakWarning_Suppress_BEGIN \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
#define RH_PerformSelectorLeakWarning_Suppress_END \
    _Pragma("clang diagnostic pop")


// arc custom retain and release
#define RHARCRetain(...) void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing
#define RHARCRelease(...) void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil


#endif /* _RHMarco_ */
