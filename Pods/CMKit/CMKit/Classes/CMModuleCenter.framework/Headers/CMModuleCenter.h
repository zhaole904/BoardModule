//
//  CMModuleCenter.h
//  CMModuleCenter
//
//  Created by PengTao on 2017/8/24.
//  Copyright © 2017年 CML lnc. All rights reserved.
//

#ifndef _CMModuleCenter_
#define _CMModuleCenter_
#if __has_include(<CMModuleCenter/CMModuleManager.h>)

#import <CMModuleCenter/CMModule.h>
#import <CMModuleCenter/CMModuleManager.h>
#import <CMModuleCenter/CMAppContext.h>
#import <CMModuleCenter/CMAppDelegate.h>

#else

#import "CMModule.h"
#import "CMModuleManager.h"
#import "CMAppContext.h"
#import "CMAppDelegate.h"
#import "CMModuleCenterError.h"

#endif
#endif /* _CMModuleCenter_ */
