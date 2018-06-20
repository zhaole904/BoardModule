//
//  RHConvertor.m
//  RHBaseKit
//
//  Created by song.zhang on 16/5/26.
//  Copyright © 2016年 song.zhang. All rights reserved.
//

#import "RHConvertor.h"
#include "RHPinyinUtil.h"

@implementation RHConvertor

/**
 * 中文转拼音缩写
 *
 * @param chineseString 中文内容
 *
 */
+ (NSString *)convertChineseToPinAbbr:(NSString *)chineseString{
    NSString *pinYinResult=[NSString string];
    for(int j=0;j<chineseString.length;j++){
        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",rhPinyinFirstLetter([chineseString characterAtIndex:j])]uppercaseString];
        
        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    return pinYinResult;
}

+ (id)convertToObject:(id)object{
    if (object == nil) {
        return @"";
    }
    return object;
}

+ (NSString *)convertToString:(id)tempString {
    return [self convertToString:tempString defaultValue:@""];
}

+ (NSString *)convertToString:(id)tempString defaultValue:(NSString *)defaultValue{
    if ([tempString isKindOfClass:[NSNull class]]||tempString==nil || [NSString stringWithFormat:@"%@",tempString].length == 0){
        return defaultValue;
    }
    
    return [NSString stringWithFormat:@"%@",tempString];
}

+ (int)convertToInt:(id)tempString{
    return [self convertToInt:tempString defaultValue:0];
}

+ (int)convertToInt:(id)tempString defaultValue:(int)defaultValue{
    if ([tempString isKindOfClass:[NSNull class]]||tempString==nil || [NSString stringWithFormat:@"%@",tempString].length == 0){
        return defaultValue;
    }
    
    return [tempString intValue];
}

+ (id)convertToNumber:(id)tempString defaultValue:(id)defaultValue{
    if ([tempString isKindOfClass:[NSNull class]] || tempString == nil || [NSString stringWithFormat:@"%@",tempString].length == 0){
        return defaultValue;
    }
    
    return tempString;
}

+ (float)convertToFloat:(id)tempString defaultValue:(float)defaultValue{
    if ([tempString isKindOfClass:[NSNull class]] || [NSString stringWithFormat:@"%@",tempString].length == 0){
        return defaultValue;
    }
    
    return [tempString floatValue];
}

+ (int)convertStrtempToInt:(NSString *)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return (strlength+1)/2;
}

@end
