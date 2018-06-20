//
//  CMCore.h
//  CMCore
//
//  Created by PengTao on 2018/1/3.
//  Copyright © 2018年 CMFT Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for CMCore.
FOUNDATION_EXPORT double CMCoreVersionNumber;

//! Project version string for CMCore.
FOUNDATION_EXPORT const unsigned char CMCoreVersionString[];

#ifndef _CMCore_
#define _CMCore_

#if __has_include(<CMCore/CMStorager.h>)
#import <CMCore/CMStorager.h>
#elif __has_include("CMStorager.h")
#import "CMStorager.h"
#endif /* Storage */

#if __has_include(<CMCore/CMDataBase.h>)
#import <CMCore/CMDataBase.h>
#elif __has_include("CMDataBase.h")
#import "CMDataBase.h"
#endif /* DataBase */

#if __has_include(<CMCore/CMHTTPSession.h>)
#import <CMCore/CMHTTPRequest.h>
#import <CMCore/CMHTTPSession.h>
#import <CMCore/CMHTTPSerialization.h>
#import <CMCore/CMHTTPDeserialization.h>
#elif __has_include("CMHTTPSession.h")
#import "CMHTTPRequest.h"
#import "CMHTTPSession.h"
#import "CMHTTPSerialization.h"
#import "CMHTTPDeserialization.h"
#endif /* HTTP */

#if __has_include(<CMCore/CMCompression.h>)
#import <CMCore/CMCompression.h>
#elif __has_include("CMCompression.h")
#import "CMCompression.h"
#endif /* Compression */

#if __has_include(<CMCore/CMCrypto.h>)
#import <CMCore/CMCrypto.h>
#elif __has_include("CMCrypto.h")
#import "CMCrypto.h"
#endif /* Crypto */

#if __has_include(<CMCore/CMImageUtil.h>)
#import <CMCore/CMImageUtil.h>
#elif __has_include("CMImageUtil.h")
#import "CMImageUtil.h"
#endif /* CMImageUtil */

#if __has_include(<CMCore/CMLog.h>)
#import <CMCore/CMLog.h>
#elif __has_include("CMLog.h")
#import "CMLog.h"
#endif /* CMLog */

#endif /* _CMCore_ */
