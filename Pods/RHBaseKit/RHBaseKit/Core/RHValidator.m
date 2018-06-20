//
//  RHValidator.m
//  RHBaseKit
//
//  Created by CMRH on 16/5/26.
//  Copyright © 2016年 CMRH. All rights reserved.
//

#import "RHValidator.h"

@implementation RHValidator

// 判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    if ([self isBlankString:string]) {
        return NO;
    }
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

// 判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    if ([self isBlankString:string]) {
        return NO;
    }
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isPureNumber:(NSString*)string{
    if( ![self isPureInt:string] || ![self isPureFloat:string])
        return NO;
    
    return YES;
}


+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//检验邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 检验网址是否合法
+ (BOOL)isValidateWebUrl:(NSString *)web {
    NSString *theURL =@"(([a-zA-z0-9]|-){1,}\\.){1,}[a-zA-z0-9]{1,}-*";
    //    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", theURL];
    return [urlTest evaluateWithObject:web];
}

// 检测密码是否合法
+ (BOOL)isPassword:(NSString *)password {
    BOOL flag = NO;
    
    NSString * regex1 = @"^[\\d[a-z][A-Z]]{8,16}$";
    NSString * regex2 = @"^[[a-z][A-Z]]{8,16}$";
    NSString * regex3 = @"^\\d{8,16}$";
    
    NSPredicate *regextest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *regextest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    NSPredicate *regextest3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
    
    if (([regextest1 evaluateWithObject:password] == YES)
        || ([regextest2 evaluateWithObject:password] == YES)
        || ([regextest3 evaluateWithObject:password] == YES)
        ) {
        flag= YES;
    } else {
        flag= NO;
    }
    
    return flag;
}

// 检测身份证是否合法
+ (BOOL)isPostCard:(NSString *)postcard {
    BOOL flag = NO;
    
    //身份证正则表达式(15位)
    
    NSString *regex=@"^[\\d[A-Z]]{15}|[\\d[A-Z]]{18}$";
    
    NSPredicate *regextest1= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (([regextest1 evaluateWithObject:postcard] == YES)) {
        flag= YES;
    } else {
        flag= NO;
    }
    
    return flag;
}

// 检测出生年月是否合法
+ (BOOL)isBirthDay:(NSString *)birthday {
    BOOL flag = NO;
    
    //身份证正则表达式(15位)
    
    NSString *regex=@"[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}";
    
    NSPredicate *regextest1= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (([regextest1 evaluateWithObject:birthday] == YES)) {
        flag= YES;
    } else {
        flag= NO;
    }
    
    return flag;
}

+ (BOOL)isBetweenDate:(NSDate*)date beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    if ([date compare:beginDate] == NSOrderedAscending) {
        return NO;
    } else if ([date compare:endDate] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isValidDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    //    if ([beginDate compare:endDate] == NSOrderedAscending)
    //        return NO;
    
    if ([beginDate compare:endDate] == NSOrderedDescending)
        return NO;
    return YES;
}

// 检测手机是否合法
+ (BOOL)isMobileValid:(NSString *)mobileNum {
    BOOL isMobile = NO;
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,17,180,189
     22         */
    NSString * CT = @"^1((33|53|7[0-9]|8[0-9])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        isMobile= YES;
    } else {
        isMobile= NO;
    }
    
    //    isMobile = [mobile isMatchedByRegex:@"1[0-9]{10}"];
    return isMobile;
}
// 匹配身份证号码
+ (BOOL)isHxIdentityCard:(NSString *)postCard {
    // 判断位数
    if (postCard.length != 15 && postCard.length != 18) {
        return NO;
    }
    
    NSString *carid = postCard;
    long lSumQT  =0;
    // 加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    // 校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    // 将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:postCard];
    if (postCard.length == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = mString.UTF8String;
        for (int i=0; i<=16; i++) {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    // 判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]) {
        return NO;
    }
    // 判断年月日是否有效
    // 年份
    int strYear = [[carid substringWithRange:NSMakeRange(6,4)] intValue];
    // 月份
    int strMonth = [[carid substringWithRange:NSMakeRange(10,2)] intValue];
    // 日
    int strDay = [[carid substringWithRange:NSMakeRange(12,2)] intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.timeZone = NSTimeZone.localTimeZone;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    const char *PaperId  = carid.UTF8String;
    // 检验长度
    if( 18 != strlen(PaperId)) return -1;
    // 校验数字
    for (int i=0; i<18; i++) {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    // 验证最末的校验码
    for (int i=0; i<=16; i++) {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] ) {
        return NO;
    }
    return YES;
}

+ (BOOL)areaCode:(NSString *)code {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];

    return dic[code] != nil;
}

@end
