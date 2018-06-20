//
//  RHValidator.h
//  RHBaseKit
//
//  Created by song.zhang on 16/5/26.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 验证器
@interface RHValidator : NSObject

+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;

+ (BOOL)isPureNumber:(NSString*)string;

/**
 * 判断字符串是否为空，返回YES/NO
 *
 * @param string 字符串
 *
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 * 检验邮箱是否合法
 *
 * @param email 邮箱字符串
 *
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 * 检测出生年月是否合法
 *
 * @param birthday 出生年月
 *
 */
+ (BOOL)isBirthDay:(NSString *)birthday;

/**
 * 检验网址是否合法
 *
 */
+ (BOOL)isValidateWebUrl:(NSString *)web;

/**
 * 检测手机是否合法
 *
 */
+ (BOOL)isMobileValid:(NSString *)mobile;

/**
 * 检测密码是否合法
 *
 */
+ (BOOL)isPassword:(NSString *)password;

/**
 * 检测身份证是否合法
 *
 */
+ (BOOL)isPostCard:(NSString *)postcard;

// 匹配身份证号码
+ (BOOL)isHxIdentityCard:(NSString *)postCard;

/**
 * 判断某时间是否再某个时间区间内
 *
 */
+ (BOOL)isBetweenDate:(NSDate*)date beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;

/**
 * 判断起始时间是否小于结束时间
 *
 */
+ (BOOL)isValidDate:(NSDate*)beginDate endDate:(NSDate*)endDate;


@end
