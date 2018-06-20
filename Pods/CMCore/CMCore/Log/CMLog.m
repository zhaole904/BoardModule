//
//  CMLog.m
//  CMCore
//
//  Created by PengTao on 2017/12/12.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import "CMLog.h"

@implementation CMLog

static NSMutableArray *_allLoggers = nil;
#if DEBUG
static CMLogLevel _level = CMLogLevelDebug;
#else
static CMLogLevel _level = CMLogLevelInfo;
#endif

+ (void)load {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:dt];
    NSInteger yearNum = comp.year;

	printf("************************************************************************\n"
		   "\n"
		   " %s\n"
		   " Copyright © %d年 CMFT Co.,Ltd.\n"
		   " home: %s\n"
		   "\n"
		   "*************************************************************************\n",
		   NSProcessInfo.processInfo.processName.UTF8String,
           (int)yearNum,
		   NSBundle.mainBundle.bundlePath.UTF8String);
    
	[self registerLogger:[[CMTTYLogger alloc] init]];
}

+ (NSArray *)allLoggers {
	if (!_allLoggers || _allLoggers.count == 0) {
		return nil;
	}
	return _allLoggers.copy;
}

+ (void)registerLogger:(id<CMLogger>)logger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _allLoggers = [NSMutableArray array];
    });

    if (![_allLoggers containsObject:logger]) {
        [_allLoggers addObject:logger];
    }
}

+ (void)unregisterLogger:(id<CMLogger>)logger {
	@synchronized(self) {
		[_allLoggers removeObject:logger];
	}
}

+ (void)unregisterAllLoggers {
	@synchronized(self) {
		[_allLoggers removeAllObjects];
	}
}

+ (void)logWithFlag:(CMLogFlag)flag file:(const char *)file line:(int)line function:(const char *)function tag:(NSString *)tag msg:(NSString *)frmt, ... {
	if (!frmt || !frmt.length || !(self.level & flag)) {
        // 无日志，或等级不符
		return;
	}
	
	va_list args;
	va_start(args, frmt);
	NSString *msg = [[NSString alloc] initWithFormat:frmt arguments:args];
	va_end(args);

    [self.allLoggers enumerateObjectsUsingBlock:^(id<CMLogger>  _Nonnull logger, NSUInteger idx, BOOL * _Nonnull stop) {
        [logger logWithFlag:flag file:file line:line function:function tag:tag msg:msg];
    }];
}

#pragma mark - Getters & Setters

+ (CMLogLevel)level {
	return _level;
}
+ (void)setLevel:(CMLogLevel)level {
	_level = MIN(MAX(CMLogLevelOff, level), CMLogLevelAll);
}

@end


@implementation CMTTYLogger
{
	NSDateFormatter *_dateFormatter;
}

@synthesize level = _level;

- (instancetype)init {
#if DEBUG
	return [self initWithLevel:CMLogLevelDebug];
#else
	return [self initWithLevel:CMLogLevelOff];
#endif
}
- (instancetype)initWithLevel:(CMLogLevel)level {
	if (self = [super init]) {
		_level = level;
	}
	return self;
}

- (void)logWithFlag:(CMLogFlag)flag
               file:(const char *)file
               line:(int)line
           function:(const char *)function
                tag:(NSString *)tag
                msg:(NSString *)msg {
    if (!msg || !msg.length || !(self.level & flag)) {
        // 无日志，或等级不符
        return;
    }
	
	NSString *timeStr = [self.dateFormatter stringFromDate:NSDate.date];
	NSString *fileInfo = file ? [[NSString stringWithFormat:@"%s", file] lastPathComponent] : nil;
	
#define _cm_fprintfWithMaker(maker) \
	if (tag && tag.length) { \
		fprintf(stderr, "%s%s: %s(%s:%d)(%s)\n%s\n", maker, timeStr.UTF8String, function, fileInfo.UTF8String, line, tag.UTF8String, msg.UTF8String); \
	} else { \
		fprintf(stderr, "%s%s: %s(%s:%d)\n%s\n", maker, timeStr.UTF8String, function, fileInfo.UTF8String, line, msg.UTF8String); \
	}

    if (flag & CMLogLevelError) {
        _cm_fprintfWithMaker("[E]");
    } else if (flag & CMLogLevelWarning) {
        _cm_fprintfWithMaker("[W]");
    } else if (flag & CMLogLevelInfo) {
        _cm_fprintfWithMaker("[I]");
    } else if (flag & CMLogLevelDebug) {
        _cm_fprintfWithMaker("[D]");
    } else {
        _cm_fprintfWithMaker("[A]");
    }
#undef _cm_fprintfWithMaker
}

- (NSDateFormatter *)dateFormatter {
	if (!_dateFormatter) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		_dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
		_dateFormatter.timeZone = [NSTimeZone systemTimeZone];
	}
	return _dateFormatter;
}

@end
