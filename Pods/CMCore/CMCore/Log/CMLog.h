//
//  CMLogger.h
//  CMCore
//
//  Created by PengTao on 2017/12/12.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 日志标记
typedef NS_ENUM(NSInteger, CMLogFlag) {
    CMLogFlagError      = 1 << 0,
    CMLogFlagWarning    = 1 << 1,
    CMLogFlagInfo       = 1 << 2,
    CMLogFlagLog        = 1 << 3,
    CMLogFlagDebug      = 1 << 4
};

/// 日志等级
typedef NS_ENUM(NSUInteger, CMLogLevel) {
    CMLogLevelOff      = 0,
    CMLogLevelError    = CMLogFlagError,
    CMLogLevelWarning  = CMLogLevelError | CMLogFlagWarning,
    CMLogLevelInfo     = CMLogLevelWarning | CMLogFlagInfo,
    CMLogLevelDebug    = CMLogLevelInfo | CMLogFlagDebug,
    CMLogLevelAll      = NSUIntegerMax
};

@protocol CMLogger <NSObject>

/// 日志等级开关，超过该等级的日志不会被打印
@property(readonly, nonatomic) CMLogLevel level;

///< 日志打印入口
- (void)logWithFlag:(CMLogFlag)flag
               file:(const char *)file
               line:(int)line
           function:(const char *)function
                tag:(NSString *)tag
                msg:(NSString *)msg;

@end


@interface CMLog : NSObject

@property (class, nonatomic, assign) CMLogLevel level; ///< 总日志等级，超过该等级的日志不会被打印
@property (class, nonatomic, readonly) NSArray<id<CMLogger>> *allLoggers; ///< 所有的日志器

+ (void)registerLogger:(id<CMLogger>)logger;	///< 注册日志器
+ (void)unregisterLogger:(id<CMLogger>)logger;	///< 注销日志器
+ (void)unregisterAllLoggers;					///< 注销所有日志器

///< 日志打印总入口，内部会按日志器注册顺序依次调用日志器打印
+ (void)logWithFlag:(CMLogFlag)flag
               file:(const char *)file
               line:(int)line
           function:(const char *)function
                tag:(NSString *)tag
                msg:(NSString *)frmt, ...;

@end

/// 控制台日志器
@interface CMTTYLogger : NSObject <CMLogger>
- (instancetype)initWithLevel:(CMLogLevel)level;
@end

#define CMLogMacro(aTag, flag, frmt, ...) \
    [CMLog logWithFlag:flag file:__FILE__ line:__LINE__ function:__PRETTY_FUNCTION__ tag:aTag msg:frmt, ##__VA_ARGS__]

#define CMLogError(frmt, ...)       CMLogMacro(nil, CMLogFlagError, frmt, ##__VA_ARGS__)
#define CMLogErrorT(tag, frmt, ...) CMLogMacro(tag, CMLogFlagError, frmt, ##__VA_ARGS__)
#define CMLogWarn(frmt, ...)        CMLogMacro(nil, CMLogFlagWarning, frmt, ##__VA_ARGS__)
#define CMLogWarnT(tag, frmt, ...)  CMLogMacro(tag, CMLogFlagWarning, frmt, ##__VA_ARGS__)
#define CMLogInfo(frmt, ...)        CMLogMacro(nil, CMLogFlagInfo, frmt, ##__VA_ARGS__)
#define CMLogInfoT(tag, frmt, ...)  CMLogMacro(tag, CMLogFlaglInfo, frmt, ##__VA_ARGS__)
#define CMLogDebug(frmt, ...)       CMLogMacro(nil, CMLogFlagDebug, frmt, ##__VA_ARGS__)
#define CMLogDebugT(tag, frmt, ...) CMLogMacro(tag, CMLogFlagDebug, frmt, ##__VA_ARGS__)

#define NSLog(frmt, ...)        CMLogMacro(@"NSLog", CMLog.level, frmt, ##__VA_ARGS__)
#define CMLog(frmt, ...)        CMLogMacro(@"CMLog", CMLog.level, frmt, ##__VA_ARGS__)
#define CMLogNSError(aError)    CMLogErrorT(@"NSError", @"%@", aError)
