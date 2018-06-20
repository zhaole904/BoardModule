#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RHBaseKit.h"
#import "RHConvertor.h"
#import "RHDevice.h"
#import "RHHttpResultModel.h"
#import "RHMarco.h"
#import "RHObserver.h"
#import "RHPinyinUtil.h"
#import "RHSystemSound.h"
#import "RHValidator.h"
#import "RHWeakStrong.h"

FOUNDATION_EXPORT double RHBaseKitVersionNumber;
FOUNDATION_EXPORT const unsigned char RHBaseKitVersionString[];

