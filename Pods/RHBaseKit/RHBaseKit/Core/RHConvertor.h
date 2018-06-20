//
//  RHConvertor.h
//  RHBaseKit
//
//  Created by song.zhang on 16/5/26.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 转换器
@interface RHConvertor : NSObject

/**
 * 中文转拼音缩写
 *
 * @param chineseString 中文内容
 *
 */
+ (NSString *)convertChineseToPinAbbr:(NSString *)chineseString;

/**
 * 判断对象是否为空，为空则返回空字符串，否则强转成字符类型
 *
 * @param object 对象
 *
 */
+ (id)convertToObject:(id)object;

/**
 * 判断对象是否为空，为空则返回空字符串，否则强转成字符类型
 *
 * @param object 对象
 *
 */
+ (NSString *)convertToString:(id)object;

/**
 * 判断对象是否为空，为空则返回defaultValue字符串，否则强转成字符型
 *
 * @param object 对象
 *
 */
+ (NSString *)convertToString:(id)object defaultValue:(NSString *)defaultValue;


/**
 * 判断对象是否为空，为空则返回0，否则强转成整型
 *
 * @param object 对象
 *
 */
+ (int)convertToInt:(id)object;

/**
 * 判断对象是否为空，为空则返回defaultValue，否则强转成整型
 *
 * @param object 对象
 *
 */
+ (int)convertToInt:(id)object defaultValue:(int)defaultValue;


/**
 * 判断对象是否为空，为空则返回defaultValue，否则强转成浮点型
 *
 * @param object 对象
 *
 */
+ (float)convertToFloat:(NSString *)object defaultValue:(float)defaultValue;


/**
 * 判断对象是否为空，为空则返回defaultValue，否则强转成数值型
 *
 * @param object 对象
 *
 */
+ (id)convertToNumber:(id)object defaultValue:(id)defaultValue;


/**
 * 字符串强转整型
 *
 */
+ (int)convertStrtempToInt:(NSString*)strtemp;

@end
